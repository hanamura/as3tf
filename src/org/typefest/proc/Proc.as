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
			__procs[proc] = true;
		}
		static private function __release(proc:Proc):void {
			delete __procs[proc];
		}
		static private function __retained(proc:Proc):Boolean {
			return proc in __procs;
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
			return __id;
		}
		public function get state():String {
			return __state;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Proc() {
			super();
			
			__ed = new EventDispatcher(this);
			
			__id    = ++__idCount;
			__state = NEW;
		}
		
		//---------------------------------------
		// Retain and Release
		//---------------------------------------
		/*
		// retain proc in static domain
		var proc:Proc = new MyProc().retain();
		*/
		public function retain():Proc {
			__retain(this);
			return this;
		}
		public function release():Proc {
			__release(this);
			return this;
		}
		
		//---------------------------------------
		// Interface
		//---------------------------------------
		public function fire():void {
			if(__state !== NEW) {
				throw new IllegalOperationError("Already started.");
			}
			_startTriggered();
		}
		
		public function start():void {
			if(__state !== NEW) {
				throw new IllegalOperationError("Already started.");
			}
			__state = STARTING;
			_delay.add(_startTriggered, "1 frame");
		}
		
		public function stop():void {
			if(__state === PROCESSING) {
				__state = STOPPING;
				
				var fn:Function;
				if(__stoppedFunc !== null) {
					fn = __stoppedFunc;
				} else {
					fn = _defaultStopped;
				}
				_drop();
				fn();
			} else if(__state === STARTING) {
				__state = STOPPING;
				
				_delay.remove(_startTriggered);
				_delay.add(_end, "1 frame");
			} else {
				throw new IllegalOperationError("Not started or already stopped.");
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
			dispatcher:*,
			types:*,
			listener:Function,
			priority:int = 0
		):void {
			if (types is String) {
				if (!__listenerFuncs) {
					__listenerFuncs = new Dictionary(false);
				}
				if (!__listenerFuncs[dispatcher]) {
					__listenerFuncs[dispatcher] = new Dictionary(false);
				}
				if (__listenerFuncs[dispatcher][types]) {
					dispatcher.removeEventListener(types, _listenTriggered);
				}
				__listenerFuncs[dispatcher][types] = listener;
				dispatcher.addEventListener(
					types,
					_listenTriggered,
					false,
					priority,
					false
				);
			} else {
				for each (var type:String in types) {
					listen(dispatcher, type, listener, priority);
				}
			}
		}
		
		public function sleep(
			time:*,
			fn:Function
		):void {
			if(__state !== PROCESSING) {
				throw new IllegalOperationError("Illegal timing.");
			}
			
			if(__sleepFunc !== null) {
				_delay.remove(_sleepTriggered);
			}
			__sleepFunc = fn;
			_delay.add(_sleepTriggered, time);
		}
		
		public function stopped(
			fn:Function
		):void {
			if(__state !== PROCESSING) {
				throw new IllegalOperationError("Illegal timing");
			}
			
			__stoppedFunc = fn;
		}
		
		public function called(
			name:*,
			fn:Function
		):* {
			if(name is QName && name.uri !== "") {
				if(!__calledNamespacedFuncs) {
					__calledNamespacedFuncs = new Dictionary(false);
				}
				if(!__calledNamespacedFuncs[name.uri]) {
					__calledNamespacedFuncs[name.uri] = new Dictionary(false);
				}
				__calledNamespacedFuncs[name.uri][name.localName] = fn;
			} else {
				if(!__calledNormalFuncs) {
					__calledNormalFuncs = new Dictionary(false);
				}
				__calledNormalFuncs[String(name)] = fn;
			}
		}
		
		//---------------------------------------
		// Drop All Registrations
		//---------------------------------------
		protected function _drop():void {
			for(var dispatcher:* in __listenerFuncs) {
				for(var type:String in __listenerFuncs[dispatcher]) {
					dispatcher.removeEventListener(type, _listenTriggered);
				}
			}
			__listenerFuncs = null;
			
			if(__sleepFunc !== null) {
				_delay.remove(_sleepTriggered);
				__sleepFunc = null;
			}
			
			__stoppedFunc = null;
			
			__calledNamespacedFuncs = null;
			__calledNormalFuncs     = null;
		}
		
		//---------------------------------------
		// Triggereds
		//---------------------------------------
		protected function _listenTriggered(e:Event):void {
			var fn:Function = __listenerFuncs[e.currentTarget][e.type];
			_drop();
			fn(e);
		}
		
		protected function _sleepTriggered():void {
			var fn:Function = __sleepFunc;
			_drop();
			fn();
		}
		
		//---------------------------------------
		// Internal
		//---------------------------------------
		protected function _startTriggered():void {
			_drop();
			__state = PROCESSING;
			_start();
			dispatchEvent(new ProcEvent(ProcEvent.START));
		}
		
		protected function _start():void {
			// override this method
		}
		
		protected function _end():void {
			if(__state === NEW || __state === END) {
				throw new IllegalOperationError("Illegal timing.");
			} else if(__state === STARTING) {
				_delay.remove(_startTriggered);
			}
			
			_drop();
			
			__state = END;
			dispatchEvent(new ProcEvent(ProcEvent.END));
			_finalize();
			
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
					__calledNamespacedFuncs
					&& name.uri in __calledNamespacedFuncs
					&& name.localName in __calledNamespacedFuncs[name.uri]
				) {
					fn = __calledNamespacedFuncs[name.uri][name.localName];
				}
			} else {
				if(
					__calledNormalFuncs
					&& strname in __calledNormalFuncs
				) {
					fn = __calledNormalFuncs[strname];
				}
			}
			
			if(fn === null) {
				var methodName:QName = new QName(proc_called, strname);
				try {
					fn = this[methodName];
				} catch (e:Error) {}
			}
			
			if(fn !== null) {
				_drop();
				return fn.apply(null, args);
			} else {
				_drop();
				args.unshift(name);
				return _defaultCalled.apply(null, args);
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
			__ed.addEventListener(t, l, uc, p, uw);
		}
		
		public function dispatchEvent(e:Event):Boolean {
			return __ed.dispatchEvent(e);
		}
		
		public function hasEventListener(t:String):Boolean {
			return __ed.hasEventListener(t);
		}
		
		public function removeEventListener(
			t:String,
			l:Function,
			uc:Boolean = false
		):void {
			__ed.removeEventListener(t, l, uc);
		}
		
		public function willTrigger(t:String):Boolean {
			return __ed.willTrigger(t);
		}
		
		//---------------------------------------
		// toString
		//---------------------------------------
		public function toString():String {
			return (
				"[" + getQualifiedClassName(this)
				+ " (Proc ID: " + id.toString() + ")]"
			);
		}
	}
}