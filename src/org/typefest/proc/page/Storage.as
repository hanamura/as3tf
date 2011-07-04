/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.proc.page {
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	
	
	
	
	dynamic public class Storage extends Proxy {
		///// to key
		static private function toKey(name:*):String {
			return name is QName ? name.localName : String(name);
		}
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// parent
		protected var _parent:Storage = null;
		
		public function get parent():Storage { return _parent }
		public function set parent(storage:Storage):void { _parent = storage }
		
		///// data
		protected var _data:* = {};
		
		///// temp
		protected var _temp:Array = null;
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Storage(parent:Storage = null) {
			super();
			
			_parent = parent;
		}
		
		
		
		
		
		//---------------------------------------
		// get / set
		//---------------------------------------
		public function get(key:String):* {
			return key in _data ? _data[key] : _parent ? _parent.get(key) : undefined;
		}
		public function set(key:String, value:*):void {
			_data[key] = value;
		}
		public function has(key:String):Boolean {
			return key in _data || !!_parent && _parent.has(key);
		}
		public function own(key:String):Boolean {
			return key in _data;
		}
		public function del(key:String):Boolean {
			return delete _data[key];
		}
		public function clear():void {
			_data = {};
		}
		
		
		
		
		
		//---------------------------------------
		// proxy
		//---------------------------------------
		override flash_proxy function getProperty(name:*):* {
			return get(toKey(name));
		}
		override flash_proxy function setProperty(name:*, value:*):void {
			set(toKey(name), value);
		}
		override flash_proxy function hasProperty(name:*):Boolean {
			return has(toKey(name));
		}
		override flash_proxy function deleteProperty(name:*):Boolean {
			return del(toKey(name));
		}
		override flash_proxy function callProperty(name:*, ...args:Array):* {
			return get(toKey(name)).apply(null, args);
		}
		override flash_proxy function nextNameIndex(index:int):int {
			if (!index) {
				_temp = [];
				for (var key:String in _data) {
					_temp.push(key);
				}
			}
			return index < _temp.length ? index + 1 : 0;
		}
		override flash_proxy function nextName(index:int):String {
			return _temp[index - 1];
		}
		override flash_proxy function nextValue(index:int):* {
			return _data[_temp[index - 1]];
		}
	}
}