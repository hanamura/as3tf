/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.transitions.follow {
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	dynamic public class ValueProxy extends Proxy {
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
		protected var _values:* = {};
		
		protected var _targets:Dictionary = new Dictionary(true);
		
		private var __temp:Array = null;
		
		public function get targets():Array {
			var _:Array = [];
			
			for (var target:* in _targets) {
				_.push(target);
			}
			
			return _;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function ValueProxy(init:*) {
			super();
			
			for (var key:String in init) {
				_values[key] = init[key];
			}
		}
		
		//---------------------------------------
		// add / remove
		//---------------------------------------
		public function add(...targets:Array):void {
			for each (var target:* in targets) {
				for (var key:String in _values) {
					if (key in target) {
						target[key] = _values[key];
					}
				}
				_targets[target] = true;
			}
		}
		
		public function remove(...targets:Array):void {
			for each (var target:* in targets) {
				if (target in _targets) {
					delete _targets[target];
				}
			}
		}
		
		public function has(target:*):Boolean {
			return target in _targets;
		}
		
		public function clear():void {
			_targets = new Dictionary(true);
		}
		
		
		//---------------------------------------
		// Proxy
		//---------------------------------------
		override flash_proxy function setProperty(name:*, value:*):void {
			var key:String = __key(name);
			
			if (_values[key] !== value) {
				_values[key] = value;
				
				for (var target:* in _targets) {
					if (key in target) {
						target[key] = value;
					}
				}
			}
		}
		
		override flash_proxy function getProperty(name:*):* {
			return _values[__key(name)];
		}
		
		override flash_proxy function callProperty(name:*, ...args:Array):* {
			var key:String = __key(name);
			
			for (var target:* in _targets) {
				if (key in target && target[key] is Function) {
					target[key].apply(null, args);
				}
			}
			
			return undefined;
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
			return __key(name) in _values;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean {
			return delete _values[__key(name)];
		}
		
		override flash_proxy function nextName(index:int):String {
			return __temp[index - 1];
		}
		
		override flash_proxy function nextNameIndex(index:int):int {
			if (index === 0) {
				__temp = [];
				
				for (var key:String in _values) {
					__temp.push(key);
				}
			}
			
			if (index < __temp.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		
		override flash_proxy function nextValue(index:int):* {
			return _values[__temp[index - 1]];
		}
	}
}