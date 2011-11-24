/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

/*
inspired by ActionScript Thread Library 1.0
http://www.libspark.org/wiki/Thread

and by a blog entry,
http://www.metaphor.co.jp/masuda/blog/?p=24
*/

package org.typefest.proc {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.EventPhase;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import org.typefest.data.DeepDict;
	import org.typefest.time.lazy.Lazy;
	
	
	
	
	
	public class Proc extends EventDispatcher {
		///// procs
		static protected var _procs:Dictionary = new Dictionary(false);
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// phase
		protected var _phase:String = ProcPhase.NEW;
		
		public function get phase():String { return _phase }
		
		
		
		///// lazy
		protected var _lazy:Lazy = null;
		
		
		
		///// stores
		store var _start:Function        = null;
		store var _end:Function          = null;
		store var _listen:DeepDict       = null;
		store var _sleep:Function        = null;
		store var _called:Function       = null;
		store var _calledWith:DeepDict   = null;
		store var _assigned:Function     = null;
		store var _assignedWith:DeepDict = null;
		store var _gotten:Function       = null;
		store var _gottenWith:DeepDict   = null;
		store var _stopped:Function      = null;
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Proc(start:Function = null, end:Function = null) {
			super();
			
			store::_start = start;
			store::_end   = end;
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			store::_listen       = new DeepDict();
			store::_calledWith   = new DeepDict();
			store::_assignedWith = new DeepDict();
			store::_gottenWith   = new DeepDict();
			_lazy                = Lazy.lazy;
			
			_onInit();
		}
		protected function _onInit():void {}
		
		
		
		
		
		//---------------------------------------
		// retain / release
		//---------------------------------------
		public function retain():Proc { _procs[this] = true; return this }
		public function release():void { delete _procs[this] }
		
		
		
		
		
		//---------------------------------------
		// start
		//---------------------------------------
		public function start():void {
			if (_phase === ProcPhase.NEW) {
				_phase = ProcPhase.STARTING;
				_lazy.add(proxy::_start, "1");
			} else {
				throw new IllegalOperationError();
			}
		}
		public function fire():void {
			if (_phase === ProcPhase.NEW) {
				proxy::_start();
			} else {
				throw new IllegalOperationError();
			}
		}
		proxy function _start():void {
			_phase = ProcPhase.PROCESSING;
			
			var fn:Function = store::_start || _onStart;
			
			fn.call(this);
			
			if (_phase === ProcPhase.PROCESSING) {
				dispatchEvent(new ProcEvent(ProcEvent.START));
			}
		}
		protected function _onStart():void {}
		
		
		
		
		
		//---------------------------------------
		// stop
		//---------------------------------------
		public function stop():void {
			if (_phase === ProcPhase.STARTING) {
				_lazy.remove(proxy::_start);
				end();
			} else if (_phase === ProcPhase.PROCESSING) {
				var fn:Function = store::_stopped || _onStop;
				
				drop();
				
				_phase = ProcPhase.STOPPING;
				
				fn.call(this);
			} else {
				throw new IllegalOperationError();
			}
		}
		protected function _onStop():void {
			end();
		}
		
		
		
		
		
		//---------------------------------------
		// end
		//---------------------------------------
		public function end():void {
			drop();
			
			_phase = ProcPhase.END;
			
			var fn:Function = store::_end || _onEnd;
			
			fn.call(this);
			
			dispatchEvent(new ProcEvent(ProcEvent.END));
		}
		protected function _onEnd():void {}
		
		
		
		
		
		//---------------------------------------
		// listen
		//---------------------------------------
		public function listen(
			disp:IEventDispatcher,
			type:String,
			listener:Function,
			uc:Boolean = false,
			p:int      = 0,
			uw:Boolean = false
		):void {
			store::_listen.set([disp, type, uc], listener);
			
			disp.addEventListener(type, proxy::_listen, uc, p, uw);
		}
		///// listen proxy
		proxy function _listen(e:Event):void {
			var disp:IEventDispatcher = e.currentTarget as IEventDispatcher;
			var type:String           = e.type;
			var uc:Boolean            = e.eventPhase === EventPhase.CAPTURING_PHASE;
			
			var listener:Function = store::_listen.get([disp, type, uc]);
			
			drop();
			
			listener.call(this, e);
		}
		
		
		
		
		
		//---------------------------------------
		// sleep
		//---------------------------------------
		public function sleep(time:*, fn:Function):void {
			store::_sleep = fn;
			
			_lazy.add(proxy::_sleep, time);
		}
		///// sleep proxy
		proxy function _sleep():void {
			var fn:Function = store::_sleep;
			
			drop();
			
			fn.call(this);
		}
		
		
		
		
		
		//---------------------------------------
		// called
		//---------------------------------------
		public function called(fn:Function):void {
			store::_called = fn;
		}
		public function calledWith(name:*, fn:Function):void {
			if (name is QName) {
				store::_calledWith.set([name.uri, name.localName], fn);
			} else {
				store::_calledWith.set([name], fn);
			}
		}
		public function call(name:*, ...args:Array):* {
			var keys:Array = (name is QName) ? [name.uri, name.localName] : [name];
			var fn:Function;
			
			if (store::_calledWith.has(keys)) {
				fn = store::_calledWith.get(keys);
				drop();
				return fn.apply(this, args);
			} else if (store::_called) {
				fn = store::_called;
				drop();
				return fn.apply(this, [name].concat(args));
			}
		}
		
		
		
		
		
		//---------------------------------------
		// assigned
		//---------------------------------------
		public function assigned(fn:Function):void {
			store::_assigned = fn;
		}
		public function assignedWith(name:*, fn:Function):void {
			if (name is QName) {
				store::_assignedWith.set([name.uri, name.localName], fn);
			} else {
				store::_assignedWith.set([name], fn);
			}
		}
		public function assign(name:*, value:*):void {
			var keys:Array = (name is QName) ? [name.uri, name.localName] : [name];
			var fn:Function;
			
			if (store::_assignedWith.has(keys)) {
				fn = store::_assignedWith.get(keys);
				drop();
				fn.call(this, value);
			} else if (store::_assigned) {
				fn = store::_assigned;
				drop();
				fn.call(this, name, value);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// gotten
		//---------------------------------------
		public function gotten(fn:Function):void {
			store::_gotten = fn;
		}
		public function gottenWith(name:*, fn:Function):void {
			if (name is QName) {
				store::_gottenWith.set([name.uri, name.localName], fn);
			} else {
				store::_gottenWith.set([name], fn);
			}
		}
		public function get(name:*):* {
			var keys:Array = (name is QName) ? [name.uri, name.localName] : [name];
			var fn:Function;
			
			if (store::_gottenWith.has(keys)) {
				fn = store::_gottenWith.get(keys);
				drop();
				return fn.call(this);
			} else if (store::_gotten) {
				fn = store::_gotten;
				drop();
				return fn.call(this, name);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// stopped
		//---------------------------------------
		public function stopped(fn:Function):void {
			store::_stopped = fn;
		}
		
		
		
		
		
		//---------------------------------------
		// drop
		//---------------------------------------
		public function drop():void {
			///// drop listen
			store::_listen.each(function(keys:Array, listener:Function):void {
				var disp:IEventDispatcher = keys[0];
				var type:String           = keys[1];
				var uc:Boolean            = keys[2];
				
				disp.removeEventListener(type, proxy::_listen, uc);
			});
			store::_listen.clear();
			
			
			
			///// drop sleep
			store::_sleep = null;
			
			_lazy.remove(proxy::_sleep);
			
			
			
			///// drop stopped
			store::_stopped = null;
			
			
			
			///// drop called
			store::_called = null;
			store::_calledWith.clear();
			
			///// drop assigned
			store::_assigned = null;
			store::_assignedWith.clear();
			
			///// drop gotten
			store::_gotten = null;
			store::_gottenWith.clear();
		}
	}
}