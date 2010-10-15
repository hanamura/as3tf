/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	
	
	
	
	public class TrueDict extends Proxy {
		///// translation
		static private const TRUE:*  = {};
		static private const FALSE:* = {};
		static private function filter(key:*):* {
			return (key is Boolean) ? (key ? TRUE : FALSE) : key;
		}
		static private function unfilter(key:*):* {
			return (key === TRUE) ? true : (key === FALSE) ? false : key;
		}
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// weakkeys
		protected var _weakKeys:Boolean = false;
		
		///// dict
		protected var _dict:Dictionary = null;
		
		///// values
		protected var _values:Array = null;
		
		
		
		///// length
		public function get length():int {
			var count:int = 0;
			for each (var value:* in _dict) { count++ }
			return count;
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function TrueDict(weakKeys:Boolean = false) {
			super();
			
			_weakKeys = weakKeys;
			
			_dict = new Dictionary(_weakKeys);
		}
		
		
		
		
		
		//---------------------------------------
		// operations
		//---------------------------------------
		public function set(key:*, value:*):void {
			_dict[filter(key)] = value;
		}
		public function get(key:*):* {
			return _dict[filter(key)];
		}
		public function has(key:*):Boolean {
			return filter(key) in _dict;
		}
		public function del(key:*):Boolean {
			return delete _dict[filter(key)];
		}
		public function clear():void {
			_dict = new Dictionary(_weakKeys);
		}
		
		
		
		
		
		//---------------------------------------
		// to array
		//---------------------------------------
		public function toArray():Array {
			var _:Array = [];
			
			for each (var value:* in _dict) {
				_.push(value);
			}
			
			return _;
		}
		
		
		
		
		
		//---------------------------------------
		// each
		//---------------------------------------
		public function each(fn:Function):void {
			for (var key:* in _dict) {
				fn(unfilter(key), _dict[key]);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// proxy
		//---------------------------------------
		override flash_proxy function nextNameIndex(index:int):int {
			if (!index) {
				_values = toArray();
			}
			if (index < _values.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		override flash_proxy function nextValue(index:int):* {
			return _values[index - 1];
		}
	}
}