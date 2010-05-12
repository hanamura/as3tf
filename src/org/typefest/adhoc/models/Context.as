/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.adhoc.models {
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	dynamic public class Context extends Proxy {
		protected static function _makeKey(name:*):String {
			if(name is QName) {
				return name.localName;
			} else if(name is String) {
				return name;
			} else {
				return String(name);
			}
		}
		
		//---------------------------------------
		// Instance
		//---------------------------------------
		protected var _object:* = null;
		
		protected var _enum:Array = null;
		
		public function get object():* {
			var r:* = {};
			for(var key:* in _object) {
				r[key] = _object[key];
			}
			return r;
		}
		
		public function Context(object:*) {
			super();
			
			_object = {};
			
			for(var key:* in object) {
				_object[key] = object[key];
			}
		}
		
		//---------------------------------------
		// Proxy: Set / Get
		//---------------------------------------
		override flash_proxy function getProperty(name:*):* {
			var key:String = _makeKey(name);
			
			if(key in _object) {
				return _object[key];
			} else {
				throw new ArgumentError("Context.getProperty: no property, " + key);
			}
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
			var key:String = _makeKey(name);
			
			if(key in _object) {
				_object[key] = value;
			} else {
				throw new ArgumentError("Context.setProperty: no property, " + key);
			}
		}
		
		override flash_proxy function callProperty(name:*, ...args:Array):* {
			var key:String = _makeKey(name);
			
			if(key in _object) {
				return _object[key].apply(null, args);
			} else {
				throw new ArgumentError("Context.setProperty: no property, " + key);
			}
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
			return _makeKey(name) in _object;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean {
			throw new ArgumentError("Context.deleteProperty: error");
		}
		
		//---------------------------------------
		// Proxy: Iteration
		//---------------------------------------
		override flash_proxy function nextName(index:int):String {
			return _enum[index - 1];
		}
		
		override flash_proxy function nextNameIndex(index:int):int {
			if(index === 0) {
				_enum = [];
				for(var key:String in _object) {
					_enum.push(key);
				}
			}
			
			if(index < _enum.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		
		override flash_proxy function nextValue(index:int):* {
			return _object[_enum[index - 1]];
		}
	}
}