/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.adhoc.sharedobject {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.SharedObject;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	dynamic public class LSO extends Proxy implements IEventDispatcher {
		/*
		
		// usage:
		
		var so:LSO = new LSO("name", "/", {
			hello:"HELLO",
			world:"WORLD",
			foo:1
		});
		
		trace(so.hello); // HELLO
		trace(so.bar) // undefined
		
		so.bar = 2;
		
		trace(so.bar); // 2
		
		so.clear();
		
		trace(so.hello) // HELLO
		trace(so.bar); // undefined
		
		so.clearAll();
		
		trace(so.hello); // undefined
		
		*/
		
		static protected function _toKey(name:*):String {
			if (name is QName) {
				return name.localName;
			} else if (name is String) {
				return name;
			} else {
				return name as String;
			}
		}
		
		//---------------------------------------
		// Instance
		//---------------------------------------
		private var __ed:EventDispatcher = null;
		
		protected var _so:SharedObject = null;
		protected var _defaults:*      = null;
		protected var _dynamic:Boolean = false;
		protected var _methods:*       = null;
		
		protected var _keys:Array = null;
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function LSO(
			name:String,
			path:String,
			defaults:* = null,
			dyanmic:Boolean = true
		) {
			super();
			
			__ed = new EventDispatcher(this);
			
			_so       = SharedObject.getLocal(name, path);
			_defaults = defaults ? defaults : {};
			_dynamic  = dyanmic;
			
			_methods = {
				//---------------------------------------
				// Operations
				//---------------------------------------
				"clear":function():void {
					_so.clear();
				},
				"clearAll":function():void {
					_so.clear();
					_defaults = {};
				},
				//---------------------------------------
				// Get Object
				//---------------------------------------
				"toObject":function():* {
					var _:* = {};
					for (var key:String in this) {
						_[key] = this[key];
					}
					return _;
				}
			};
		}
		
		//---------------------------------------
		// Proxy
		//---------------------------------------
		override flash_proxy function getProperty(name:*):* {
			var key:String = _toKey(name);
			
			if (!(key in _so.data) && key in _defaults) {
				_so.data[key] = _defaults[key];
				_safeFlush();
			}
			return _so.data[key];
			
			// in case dynamic
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
			var key:String = _toKey(name);
			
			if (_dynamic || key in _defaults) {
				if (_so.data[key] !== value) {
					_so.data[key] = value;
					_safeFlush();
					
					dispatchEvent(new Event(Event.CHANGE));
				}
			} else {
				throw new IllegalOperationError('Unable to set "' + key + '"');
			}
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
			var key:String = _toKey(name);
			
			return key in _so.data || key in _defaults;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean {
			var key:String = _toKey(name);
			
			if (_defaults[key] !== _so.data[key]) {
				var result:Boolean = delete _so.data[key];
				
				dispatchEvent(new Event(Event.CHANGE));
				
				return result;
			} else {
				return delete _so.data[key];
			}
		}
		
		public function dispose(name:*):Boolean {
			var key:String   = _toKey(name);
			var some:Boolean = false;
			
			if (key in _so.data) {
				delete _so.data[key];
				some = true;
			}
			if (key in _defaults) {
				delete _defaults[key];
				some = true;
			}
			
			return some;
		}
		
		override flash_proxy function callProperty(name:*, ...args:Array):* {
			var key:String = _toKey(name);
			
			if (key in _methods) {
				return _methods[key].apply(this, args);
			} else {
				throw new IllegalOperationError('Unable to call "' + key + '"');
			}
		}
		
		//---------------------------------------
		// Iteration
		//---------------------------------------
		override flash_proxy function nextName(index:int):String {
			return _keys[index - 1];
		}
		
		override flash_proxy function nextNameIndex(index:int):int {
			if (index === 0) {
				_keys = [];
				var set:* = {};
				var key:String;
				for (key in _so.data) {
					set[key] = true;
				}
				for (key in _defaults) {
					set[key] = true;
				}
				for (key in set) {
					_keys.push(key);
				}
			}
			if (index < _keys.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		
		override flash_proxy function nextValue(index:int):* {
			return this[_keys[index - 1]];
		}
		
		//---------------------------------------
		// Shortcuts
		//---------------------------------------
		protected function _safeFlush():void {
			try {
				_so.flush();
			} catch (e:Error) {}
		}
		
		//---------------------------------------
		// IEventDispatcher
		//---------------------------------------
		public function addEventListener(
			t:String,
			l:Function,
			uc:Boolean = false,
			p:int      = 0,
			uw:Boolean = false
		):void {
			__ed.addEventListener(t, l, uc, p, uw);
		}
		public function removeEventListener(
			t:String,
			l:Function,
			uc:Boolean = false
		):void {
			__ed.removeEventListener(t, l, uc);
		}
		public function dispatchEvent(e:Event):Boolean {
			return __ed.dispatchEvent(e);
		}
		public function hasEventListener(t:String):Boolean {
			return __ed.hasEventListener(t);
		}
		public function willTrigger(t:String):Boolean {
			return __ed.willTrigger(t);
		}
	}
}
