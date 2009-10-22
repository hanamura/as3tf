/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.transitions.follow {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	[Event(name="complete", type="flash.events.Event.COMPLETE")]
	dynamic public class Follow extends Proxy implements IEventDispatcher {
		static protected function __key(name:*):String {
			if (name is QName) {
				return name.localName;
			} else if (name is String) {
				return name;
			} else {
				return String(name);
			}
		}
		
		//---------------------------------------
		// instance
		//---------------------------------------
		private var __ed:EventDispatcher = null;
		
		protected var _dest:*          = null;
		protected var _curr:ValueProxy = null;
		protected var _options:*       = null;
		
		public function get targets():Array {
			return _curr.targets;
		}
		
		protected var _moving:Boolean = false;
		
		public function get moving():Boolean {
			return _moving;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Follow(target:* = null, init:* = null) {
			super();
			
			__ed = new EventDispatcher(this);
			
			var keys:Array = [];
			_dest = {};
			for (var key:String in init) {
				_dest[key] = init[key];
				keys.push(key);
			}
			_curr = new ValueProxy(init);
			
			_addKeys.apply(null, keys);
			
			_options = {};
			
			target && add(target);
		}
		
		//---------------------------------------
		// add / remove
		//---------------------------------------
		public function add(...targets:Array):void {
			_curr.add.apply(null, targets);
		}
		
		public function remove(...targets:Array):void {
			_curr.remove.apply(null, targets);
		}
		
		public function has(target:*):Boolean {
			return _curr.has(target);
		}
		
		public function clear():void {
			_curr.clear();
		}
		
		//---------------------------------------
		// Proxy
		//---------------------------------------
		override flash_proxy function setProperty(name:*, value:*):void {
			var key:String = __key(name);
			
			if (key in _dest) {
				if (_dest[key] !== value) {
					_dest[key] = value;
					
					_updateKeys.apply(null, [key]);
				}
			} else {
				_dest[key] = value;
				_curr[key] = value;
				
				_addKeys.apply(null, [key]);
			}
		}
		
		override flash_proxy function getProperty(name:*):* {
			return _dest[__key(name)];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
			return __key(name) in _dest;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean {
			var key:String = __key(name);
			
			if (key in _dest) {
				delete _curr[key];
				delete _dest[key];
				
				_cancelKeys.apply(null, [key]);
				
				return true;
			} else {
				return false;
			}
		}
		
		override flash_proxy function callProperty(name:*, ...args:Array):* {
			var key:String = __key(name);
			
			if (args.length <= 0) {
				return getOption(key);
			} else {
				if (args.length === 1 && args[0] === null) {
					removeOption(key);
				} else {
					setOption.apply(null, [key].concat(args));
				}
			}
		}
		
		//---------------------------------------
		// shortcuts
		//---------------------------------------
		public function setOption(key:String, ...args:Array):void {
			_options[key] = args;
		}
		public function getOption(key:String):* {
			return _options[key];
		}
		public function removeOption(key:String):void {
			delete _options[key];
		}
		
		public function setValues(values:*):void {
			var adds:Array    = [];
			var updates:Array = [];
			
			for (var key:String in values) {
				if (key in _dest) {
					if (_dest[key] !== values[key]) {
						_dest[key] = values[key];
						updates.push(key);
					}
				} else {
					_dest[key] = values[key];
					_curr[key] = values[key];
					
					adds.push(key);
				}
			}
			
			if (adds.length > 0) {
				_addKeys.apply(null, adds);
			}
			if (updates.length > 0) {
				_updateKeys.apply(null, updates);
			}
		}
		public function removeKeys(...keys:Array):void {
			var _:Array = [];
			
			for each (var key:String in keys) {
				if (key in _dest) {
					delete _curr[key];
					delete _dest[key];
					_.push(key);
				}
			}
			
			if (_.length > 0) {
				_cancelKeys.apply(null, _);
			}
		}
		
		//---------------------------------------
		// get current value
		//---------------------------------------
		protected function $(key:String):* {
			return _curr[key];
		}
		
		//---------------------------------------
		// update
		//---------------------------------------
		protected function _addKeys(...keys:Array):void {
			throw new IllegalOperationError("Override this method.");
		}
		protected function _updateKeys(...keys:Array):void {
			throw new IllegalOperationError("Override this method.");
		}
		protected function _cancelKeys(...keys:Array):void {
			throw new IllegalOperationError("Override this method.");
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
		
		public function hasEventListener(t:String):Boolean {
			return __ed.hasEventListener(t);
		}
		
		public function willTrigger(t:String):Boolean {
			return __ed.willTrigger(t);
		}
		
		public function dispatchEvent(e:Event):Boolean {
			return __ed.dispatchEvent(e);
		}
	}
}
