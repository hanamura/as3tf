/*
Copyright (c) 2009 Taro Hanamura
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
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	import org.typefest.time.draft.Delay;
	
	dynamic public class Proc extends Proxy implements IEventDispatcher {
		static public const NEW:String        = "new";
		static public const STARTING:String   = "starting";
		static public const PROCESSING:String = "processing";
		static public const STOPPING:String   = "stopping";
		static public const END:String        = "end";
		
		static private var __procs:Dictionary = new Dictionary(false);
		static private var __idCount:int        = 0;
		
		static private function __retain(proc:Proc):void {
			if(proc.state === NEW && !(proc in __procs)) {
				__procs[proc] = true;
			} else {
				throw new IllegalOperationError("Illegal timing.");
			}
		}
		static private function __release(proc:Proc):void {
			if(proc.state === END && proc in __procs) {
				delete __procs[proc];
			} else {
				throw new IllegalOperationError("Illegal timing.");
			}
		}
		
		static protected var _delay:Delay = new Delay();
		
		//---------------------------------------
		// Instance
		//---------------------------------------
		private var __ed:EventDispatcher = null;
		
		protected var _id:int       = 0;
		protected var _state:String = null;
		
		protected var _listenerFuncs:Dictionary = null;
		
		protected var _sleepFunc:Function   = null;
		protected var _stoppedFunc:Function = null;
		
		protected var _calledNamespacedFuncs:Dictionary = null;
		protected var _calledNormalFuncs:Dictionary     = null;
		
		public function get id():int {
			return this._id;
		}
		public function get state():String {
			return this._state;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Proc() {
			super();
			
			this.__ed = new EventDispatcher(this);
			
			this._id    = ++__idCount;
			this._state = NEW;
			
			__retain(this);
		}
		
		//---------------------------------------
		// Interface
		//---------------------------------------
		public function fire():void {
			if(this._state !== NEW) {
				throw new IllegalOperationError("Illegal timing.");
			}
			this._startTriggered();
		}
		
		public function start():void {
			if(this._state !== NEW) {
				throw new IllegalOperationError("Illegal timing.");
			}
			this._state = STARTING;
			_delay.add(this._startTriggered, "1 frame");
		}
		
		public function stop():void {
			if(this._state === PROCESSING) {
				this._state = STOPPING;
				
				var fn:Function;
				if(this._stoppedFunc !== null) {
					fn = this._stoppedFunc;
				} else {
					fn = this._defaultStopped;
				}
				this._drop();
				fn();
			} else if(this._state === STARTING) {
				this._state = STOPPING;
				
				_delay.remove(this._startTriggered);
				_delay.add(this._end, "1 frame");
			} else {
				throw new IllegalOperationError("Illegal timing.");
			}
		}
		
		//---------------------------------------
		// Default Listeners
		//---------------------------------------
		protected function _defaultStopped():void {
			// override this method
		}
		
		protected function _defaultCalled(name:*, ...args:Array):* {
			// override this method or it throws runtime error
			
			throw new IllegalOperationError(
				"Property \"" + String(name) + "\" not found."
				+ " This method must be overridden to catch a property."
			);
		}
		
		//---------------------------------------
		// Registrations
		//---------------------------------------
		public function listen(
			dispatcher:IEventDispatcher,
			type:String,
			listener:Function,
			priority:int = 0
		):void {
			if(!this._listenerFuncs) {
				this._listenerFuncs = new Dictionary(false);
			}
			if(!this._listenerFuncs[dispatcher]) {
				this._listenerFuncs[dispatcher] = new Dictionary(false);
			}
			if(this._listenerFuncs[dispatcher][type]) {
				dispatcher.removeEventListener(type, this._listenTriggered);
			}
			this._listenerFuncs[dispatcher][type] = listener;
			dispatcher.addEventListener(
				type,
				this._listenTriggered,
				false,
				priority,
				false
			);
		}
		
		public function sleep(
			time:*,
			fn:Function
		):void {
			if(this._state !== PROCESSING) {
				throw new IllegalOperationError("Illegal timing.");
			}
			
			if(this._sleepFunc !== null) {
				_delay.remove(this._sleepTriggered);
			}
			this._sleepFunc = fn;
			_delay.add(this._sleepTriggered, time);
		}
		
		public function stopped(
			fn:Function
		):void {
			if(this._state !== PROCESSING) {
				throw new IllegalOperationError("Illegal timing");
			}
			
			this._stoppedFunc = fn;
		}
		
		public function called(
			name:*,
			fn:Function
		):* {
			if(name is QName && name.uri !== "") {
				if(!this._calledNamespacedFuncs) {
					this._calledNamespacedFuncs = new Dictionary(false);
				}
				if(!this._calledNamespacedFuncs[name.uri]) {
					this._calledNamespacedFuncs[name.uri] = new Dictionary(false);
				}
				this._calledNamespacedFuncs[name.uri][name.localName] = fn;
			} else {
				if(!this._calledNormalFuncs) {
					this._calledNormalFuncs = new Dictionary(false);
				}
				this._calledNormalFuncs[String(name)] = fn;
			}
		}
		
		//---------------------------------------
		// Drop All Registrations
		//---------------------------------------
		protected function _drop():void {
			for(var dispatcher:* in this._listenerFuncs) {
				for(var type:String in this._listenerFuncs[dispatcher]) {
					dispatcher.removeEventListener(type, this._listenTriggered);
				}
			}
			this._listenerFuncs = null;
			
			if(this._sleepFunc !== null) {
				_delay.remove(this._sleepTriggered);
				this._sleepFunc = null;
			}
			
			this._stoppedFunc = null;
			
			this._calledNamespacedFuncs = null;
			this._calledNormalFuncs     = null;
		}
		
		//---------------------------------------
		// Triggereds
		//---------------------------------------
		protected function _listenTriggered(e:Event):void {
			var fn:Function = this._listenerFuncs[e.currentTarget][e.type];
			this._drop();
			fn(e);
		}
		
		protected function _sleepTriggered():void {
			var fn:Function = this._sleepFunc;
			this._drop();
			fn();
		}
		
		//---------------------------------------
		// Internal
		//---------------------------------------
		protected function _startTriggered():void {
			this._state = PROCESSING;
			this._start();
			this.dispatchEvent(new ProcEvent(ProcEvent.START));
		}
		
		protected function _start():void {
			// override this method
		}
		
		protected function _end():void {
			if(this._state === NEW || this._state === END) {
				throw new IllegalOperationError("Illegal timing.");
			} else if(this._state === STARTING) {
				_delay.remove(this._startTriggered);
			}
			
			this._drop();
			
			this._state = END;
			this.dispatchEvent(new ProcEvent(ProcEvent.END));
			this._finalize();
			
			__release(this);
		}
		
		protected function _finalize():void {
			// override this method
		}
		
		//---------------------------------------
		// Proxy
		//---------------------------------------
		override flash_proxy function callProperty(name:*, ...args:Array):* {
			var fn:Function;
			var strname:String = String(name);
			
			if(name is QName && name.uri !== "") {
				if(
					this._calledNamespacedFuncs
					&& name.uri in this._calledNamespacedFuncs
					&& name.localName in this._calledNamespacedFuncs[name.uri]
				) {
					fn = this._calledNamespacedFuncs[name.uri][name.localName];
				}
			} else {
				if(
					this._calledNormalFuncs
					&& strname in this._calledNormalFuncs
				) {
					fn = this._calledNormalFuncs[strname];
				}
			}
			
			if(fn === null) {
				var methodName:QName = new QName(proc_called, strname);
				try {
					fn = this[methodName];
				} catch (e:Error) {}
			}
			
			if(fn !== null) {
				this._drop();
				return fn.apply(null, args);
			} else {
				this._drop();
				args.unshift(name);
				return this._defaultCalled.apply(null, args);
			}
		}
		
		//---------------------------------------
		// IEventDispatcher
		//---------------------------------------
		public function addEventListener(
			t:String,
			l:Function,
			uc:Boolean = false,
			p:int = 0,
			uw:Boolean = false
		):void {
			this.__ed.addEventListener(t, l, uc, p, uw);
		}
		
		public function dispatchEvent(e:Event):Boolean {
			return this.__ed.dispatchEvent(e);
		}
		
		public function hasEventListener(t:String):Boolean {
			return this.__ed.hasEventListener(t);
		}
		
		public function removeEventListener(
			t:String,
			l:Function,
			uc:Boolean = false
		):void {
			this.__ed.removeEventListener(t, l, uc);
		}
		
		public function willTrigger(t:String):Boolean {
			return this.__ed.willTrigger(t);
		}
	}
}