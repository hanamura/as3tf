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
	
	import flash.utils.getQualifiedClassName;
	
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
		
		private var __id:int       = 0;
		private var __state:String = null;
		
		private var __listenerFuncs:Dictionary         = null;
		private var __sleepFunc:Function               = null;
		private var __stoppedFunc:Function             = null;
		private var __calledNamespacedFuncs:Dictionary = null;
		private var __calledNormalFuncs:Dictionary     = null;
		
		public function get id():int {
			return this.__id;
		}
		public function get state():String {
			return this.__state;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Proc() {
			super();
			
			this.__ed = new EventDispatcher(this);
			
			this.__id    = ++__idCount;
			this.__state = NEW;
			
			__retain(this);
		}
		
		//---------------------------------------
		// Interface
		//---------------------------------------
		public function fire():void {
			if(this.__state !== NEW) {
				throw new IllegalOperationError("Illegal timing.");
			}
			this._startTriggered();
		}
		
		public function start():void {
			if(this.__state !== NEW) {
				throw new IllegalOperationError("Illegal timing.");
			}
			this.__state = STARTING;
			_delay.add(this._startTriggered, "1 frame");
		}
		
		public function stop():void {
			if(this.__state === PROCESSING) {
				this.__state = STOPPING;
				
				var fn:Function;
				if(this.__stoppedFunc !== null) {
					fn = this.__stoppedFunc;
				} else {
					fn = this._defaultStopped;
				}
				this._drop();
				fn();
			} else if(this.__state === STARTING) {
				this.__state = STOPPING;
				
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
			if(!this.__listenerFuncs) {
				this.__listenerFuncs = new Dictionary(false);
			}
			if(!this.__listenerFuncs[dispatcher]) {
				this.__listenerFuncs[dispatcher] = new Dictionary(false);
			}
			if(this.__listenerFuncs[dispatcher][type]) {
				dispatcher.removeEventListener(type, this._listenTriggered);
			}
			this.__listenerFuncs[dispatcher][type] = listener;
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
			if(this.__state !== PROCESSING) {
				throw new IllegalOperationError("Illegal timing.");
			}
			
			if(this.__sleepFunc !== null) {
				_delay.remove(this._sleepTriggered);
			}
			this.__sleepFunc = fn;
			_delay.add(this._sleepTriggered, time);
		}
		
		public function stopped(
			fn:Function
		):void {
			if(this.__state !== PROCESSING) {
				throw new IllegalOperationError("Illegal timing");
			}
			
			this.__stoppedFunc = fn;
		}
		
		public function called(
			name:*,
			fn:Function
		):* {
			if(name is QName && name.uri !== "") {
				if(!this.__calledNamespacedFuncs) {
					this.__calledNamespacedFuncs = new Dictionary(false);
				}
				if(!this.__calledNamespacedFuncs[name.uri]) {
					this.__calledNamespacedFuncs[name.uri] = new Dictionary(false);
				}
				this.__calledNamespacedFuncs[name.uri][name.localName] = fn;
			} else {
				if(!this.__calledNormalFuncs) {
					this.__calledNormalFuncs = new Dictionary(false);
				}
				this.__calledNormalFuncs[String(name)] = fn;
			}
		}
		
		//---------------------------------------
		// Drop All Registrations
		//---------------------------------------
		protected function _drop():void {
			for(var dispatcher:* in this.__listenerFuncs) {
				for(var type:String in this.__listenerFuncs[dispatcher]) {
					dispatcher.removeEventListener(type, this._listenTriggered);
				}
			}
			this.__listenerFuncs = null;
			
			if(this.__sleepFunc !== null) {
				_delay.remove(this._sleepTriggered);
				this.__sleepFunc = null;
			}
			
			this.__stoppedFunc = null;
			
			this.__calledNamespacedFuncs = null;
			this.__calledNormalFuncs     = null;
		}
		
		//---------------------------------------
		// Triggereds
		//---------------------------------------
		protected function _listenTriggered(e:Event):void {
			var fn:Function = this.__listenerFuncs[e.currentTarget][e.type];
			this._drop();
			fn(e);
		}
		
		protected function _sleepTriggered():void {
			var fn:Function = this.__sleepFunc;
			this._drop();
			fn();
		}
		
		//---------------------------------------
		// Internal
		//---------------------------------------
		protected function _startTriggered():void {
			this._drop();
			this.__state = PROCESSING;
			this._start();
			this.dispatchEvent(new ProcEvent(ProcEvent.START));
		}
		
		protected function _start():void {
			// override this method
		}
		
		protected function _end():void {
			if(this.__state === NEW || this.__state === END) {
				throw new IllegalOperationError("Illegal timing.");
			} else if(this.__state === STARTING) {
				_delay.remove(this._startTriggered);
			}
			
			this._drop();
			
			this.__state = END;
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
					this.__calledNamespacedFuncs
					&& name.uri in this.__calledNamespacedFuncs
					&& name.localName in this.__calledNamespacedFuncs[name.uri]
				) {
					fn = this.__calledNamespacedFuncs[name.uri][name.localName];
				}
			} else {
				if(
					this.__calledNormalFuncs
					&& strname in this.__calledNormalFuncs
				) {
					fn = this.__calledNormalFuncs[strname];
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
		
		//---------------------------------------
		// toString
		//---------------------------------------
		public function toString():String {
			return "[Proc " + this.id.toString() + "]";
		}
	}
}