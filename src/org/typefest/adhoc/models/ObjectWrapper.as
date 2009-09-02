/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.adhoc.models {
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	dynamic public class ObjectWrapper extends Proxy {
		protected static function _passKey(name:*, cont:Function, ...args:Array):* {
			var string:String;
			
			if(name is QName) {
				string = name.localName;
			} else if(name is String) {
				string = name;
			} else {
				string = String(name);
			}
			
			var prefix:String;
			var key:String;
			
			if(string.charAt(0) === "$") {
				prefix = "$";
				key    = string.substr(1);
			} else {
				prefix = "";
				key    = string;
			}
			
			args.unshift(prefix, key);
			
			return cont.apply(null, args);
		}
		
		//---------------------------------------
		// Instance
		//---------------------------------------
		protected var _rawObject:*      = null;
		protected var _modifiedObject:* = null;
		
		protected var _enum:Array  = null;
		
		public function get rawObject():* {
			return _rawObject;
		}
		
		public function ObjectWrapper(rawObject:*) {
			super();
			
			_rawObject      = rawObject;
			_modifiedObject = {};
		}
		
		//---------------------------------------
		// Proxy: Set / Get
		//---------------------------------------
		override flash_proxy function setProperty(name:*, value:*):void {
			_passKey(name, _setProperty, value);
		}
		protected function _setProperty(prefix:String, key:String, value:*):void {
			if(prefix === "$") {
				throw new ArgumentError("ObjectWrapper._setProperty: error");
			} else {
				if(key in _rawObject) {
					_modifiedObject[key] = value;
				} else {
					throw new ArgumentError("ObjectWrapper._setProperty: error");
				}
			}
		}
		
		override flash_proxy function getProperty(name:*):* {
			return _passKey(name, _getProperty);
		}
		protected function _getProperty(prefix:String, key:String):* {
			if(prefix === "$") {
				if(key in _rawObject) {
					return _rawObject[key];
				} else {
					throw new ArgumentError("ObjectWrapper._getProperty: error");
				}
			} else {
				if(key in _modifiedObject) {
					return _modifiedObject[key];
				} else if(key in _rawObject) {
					return _rawObject[key];
				} else {
					throw new ArgumentError("ObjectWrapper._getProperty: error");
				}
			}
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
			return _passKey(name, _hasProperty);
		}
		protected function _hasProperty(prefix:String, key:String):Boolean {
			return key in _rawObject;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean {
			throw new ArgumentError("ObjectWrapper.deleteProperty: unable to delete");
		}
		
		override flash_proxy function callProperty(name:*, ...args:Array):* {
			args.unshift(name, _callProperty);
			return _passKey.apply(null, args);
		}
		protected function _callProperty(prefix:String, key:String, ...args:Array):* {
			return _getProperty(prefix, key).apply(null, args);
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
				for(var key:String in _rawObject) {
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
			return _getProperty("", _enum[index - 1]);
		}
	}
}