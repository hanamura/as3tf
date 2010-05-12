/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.core {
	import flash.utils.*;
	
	public class Dict {
		public static function filter(
			fn:Function,
			dict:Dictionary,
			weakKeys:Boolean = false
		):Dictionary {
			var r:Dictionary = new Dictionary(weakKeys);
			for(var key:* in dict) {
				if(fn(key, dict[key])) {
					r[key] = dict[key];
				}
			}
			return r;
		}
		
		public static function filterKey(fn:Function, dict:Dictionary):Array {
			var r:Array = [];
			for(var key:* in dict) {
				if(fn(key, dict[key])) {
					r.push(key);
				}
			}
			return r;
		}
		
		public static function filterValue(fn:Function, dict:Dictionary):Array {
			var r:Array = [];
			for(var key:* in dict) {
				if(fn(key, dict[key])) {
					r.push(dict[key]);
				}
			}
			return r;
		}
		
		public static function empty(dict:Dictionary):Boolean {
			for each(var key:* in dict) {
				return false;
			}
			return true;
		}
		
		public static function length(dict:Dictionary):int {
			var len:int = 0;
			for(var key:* in dict) {
				len++;
			}
			return len;
		}
		
		public static function copy(
			dict:Dictionary,
			weakKeys:Boolean = false
		):Dictionary {
			var r:Dictionary = new Dictionary(weakKeys);
			for(var key:* in dict) {
				r[key] = dict[key];
			}
			return r;
		}
		
		public static function keys(dict:Dictionary):Array {
			var r:Array = [];
			for(var key:* in dict) {
				r.push(key);
			}
			return r;
		}
		
		public static function values(dict:Dictionary):Array {
			var r:Array = [];
			for each(var value:* in dict) {
				r.push(value);
			}
			return r;
		}
		
		public static function hasKey(obj:*, dict:Dictionary):Boolean {
			for(var key:* in dict) {
				if(obj === key) { return true }
			}
			return false;
		}
		
		public static function hasValue(obj:*, dict:Dictionary):Boolean {
			for each(var value:* in dict) {
				if(obj === value) { return true }
			}
			return false;
		}
		
		static public function invert(
			dict:Dictionary,
			weakKeys:Boolean = false
		):Dictionary {
			var r:Dictionary = new Dictionary(weakKeys);
			for(var key:* in dict) {
				r[dict[key]] = key;
			}
			return r;
		}
	}
}