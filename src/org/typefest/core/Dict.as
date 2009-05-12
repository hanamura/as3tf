/*
as3tf
http://code.google.com/p/as3tf/

Licensed under the MIT License

Copyright (c) 2008 Taro Hanamura

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
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