/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

/*
inspired by following tweet:
http://twitter.com/alumican_net/status/17525818028720128
*/

package org.typefest.loop {
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	
	
	
	public class Loop extends EventDispatcher {
		///// props
		protected var _body:Function = null;
		protected var _scope:*       = null;
		protected var _count:int     = 0;
		protected var _cont:Function = null;
		
		public function get body():Function { return _body }
		public function set body(_:Function):void { _body = _ }
		public function get scope():* { return _scope }
		public function set scope(_:*):void { _scope = _ }
		public function get count():int { return _count }
		public function set count(_:int):void { _count = _ }
		public function get cont():Function { return _cont }
		public function set cont(_:Function):void { _cont = _ }
		
		///// tasks
		protected var _engine:Bitmap = null;
		protected var _tasks:Array   = [];
		protected var _child:Loop    = null;
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Loop(
			body:Function,
			scope:*       = null,
			count:int     = 10,
			cont:Function = null
		) {
			super();
			
			_body  = body;
			_scope = scope;
			_count = count;
			_cont  = cont;
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {}
		
		
		
		
		
		//---------------------------------------
		// start / stop
		//---------------------------------------
		public function start():void {
			if (!_engine) {
				_engine = new Bitmap();
				_engine.addEventListener(Event.ENTER_FRAME, _loop);
			}
		}
		public function stop():void {
			if (_engine) {
				_engine.removeEventListener(Event.ENTER_FRAME, _loop);
				
				if (_child) {
					_child.removeEventListener(LoopEvent.END, _childEnd);
					_child.removeEventListener(LoopErrorEvent.ERROR, _childError);
					_child = null;
				}
			}
		}
		
		
		
		
		
		//---------------------------------------
		// loop
		//---------------------------------------
		protected function _loop(e:Event):void {
			var count:int = _count;
			
			try {
				while (count--) { _next()() }
			} catch (e:Break) {
				return _toEnd();
			} catch (e:Loop) {
				return _toNest(e);
			} catch (e:Error) {
				return _toError(e);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// to end
		//---------------------------------------
		protected function _toEnd():void {
			dispatchEvent(new LoopEvent(LoopEvent.END));
			
			stop();
		}
		
		
		
		
		
		//---------------------------------------
		// to nest
		//---------------------------------------
		protected function _toNest(loop:Loop):void {
			_engine.removeEventListener(Event.ENTER_FRAME, _loop);
			
			_child = loop;
			_child.start();
			
			if (_child.cont is Function) {
				_tasks.unshift(function():void { loop.cont.call(_scope) });
			}
			
			_child.addEventListener(LoopEvent.END, _childEnd);
			_child.addEventListener(LoopErrorEvent.ERROR, _childError);
		}
		///// nest end
		protected function _childEnd(e:LoopEvent):void {
			_child.removeEventListener(LoopEvent.END, _childEnd);
			_child.removeEventListener(LoopErrorEvent.ERROR, _childError);
			_child = null;
			
			_engine.addEventListener(Event.ENTER_FRAME, _loop);
		}
		///// nest error
		protected function _childError(e:LoopErrorEvent):void {
			_child.removeEventListener(LoopEvent.END, _childEnd);
			_child.removeEventListener(LoopErrorEvent.ERROR, _childError);
			_child = null;
			
			dispatchEvent(e);
			
			stop();
		}
		
		
		
		
		
		//---------------------------------------
		// to error
		//---------------------------------------
		protected function _toError(e:Error):void {
			dispatchEvent(new LoopErrorEvent(LoopErrorEvent.ERROR, false, false, "", e));
			stop();
		}
		
		
		
		
		
		//---------------------------------------
		// next
		//---------------------------------------
		protected function _next():Function {
			if (_tasks.length) {
				return _tasks.shift();
			} else {
				return function():void { _body.call(_scope) }
			}
		}
	}
}