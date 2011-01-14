/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	public class Set extends Proxy {
		protected var _d:Dictionary = null;
		protected var _l:Array      = null;
		
		//---------------------------------------
		// weakkeys
		//---------------------------------------
		protected var _weakKeys:Boolean = false;
		
		public function get weakKeys():Boolean {
			return _weakKeys;
		}
		
		//---------------------------------------
		// length
		//---------------------------------------
		public function get length():int {
			var count:int = 0;
			for (var key:* in _d) {
				count++;
			}
			return count;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Set(init:* = null, weakKeys:Boolean = false) {
			super();
			
			_weakKeys = weakKeys;
			
			_d = new Dictionary(_weakKeys);
			
			var values:Array = [];
			
			for each (var value:* in init) {
				values.push(value);
			}
			add.apply(null, values);
		}
		
		//---------------------------------------
		// operations
		//---------------------------------------
		public function add(...values:Array):void {
			for each (var value:* in values) {
				_d[value] = true;
			}
		}
		public function remove(...values:Array):void {
			for each (var value:* in values) {
				delete _d[value];
			}
		}
		public function has(value:*):Boolean {
			return value in _d;
		}
		public function clear():void {
			_d = new Dictionary(_weakKeys);
		}
		
		//---------------------------------------
		// to string etc.
		//---------------------------------------
		public function toString():String {
			return "";
		}
		public function toArray():Array {
			var _:Array = [];
			for (var key:* in _d) {
				_.push(key);
			}
			return _;
		}
		public function toDict(weakKeys:Boolean = false):Dictionary {
			var _:Dictionary = new Dictionary(weakKeys);
			for (var key:* in _d) {
				_[key] = true;
			}
			return _;
		}
		
		//---------------------------------------
		// proxy
		//---------------------------------------
		override flash_proxy function nextNameIndex(index:int):int {
			if (!index) {
				_l = [];
				for (var value:* in _d) {
					_l.push(value);
				}
			}
			
			if (index < _l.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		override flash_proxy function nextValue(index:int):* {
			return _l[index - 1];
		}
	}
}