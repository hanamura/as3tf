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
	public class Obj {
		
		public static function empty(obj:Object):Boolean {
			for(var prop:String in obj) {
				return false;
			}
			return true;
		}
		
		public static function filter(fn:Function, obj:Object):Object {
			var r:Object = {};
			for(var prop:String in obj) {
				fn(prop, obj[prop]) && (r[prop] = obj[prop]);
			}
			return r;
		}
		
		public static function filterProp(fn:Function, obj:Object):Array {
			var r:Array = [];
			for(var prop:String in obj) {
				fn(prop, obj[prop]) && r.push(prop);
			}
			return r;
		}
		
		public static function filterValue(fn:Function, obj:Object):Array {
			var r:Array = [];
			for(var prop:String in obj) {
				fn(prop, obj[prop]) && r.push(obj[prop]);
			}
			return r;
		}
		
		public static function map(fn:Function, obj:Object):Object {
			var r:Object = {};
			for(var prop:String in obj) {
				r[prop] = fn(obj[prop]);
			}
			return r;
		}
		
		public static function copy(obj:Object):Object {
			var rObj:Object = {};
			for(var prop:String in obj) {
				rObj[prop] = obj[prop];
			}
			return rObj;
		}
		
		public static function length(obj:Object):int {
			var len:int = 0;
			for(var prop:String in obj) {
				len++;
			}
			return len;
		}
		
		public static function props(obj:Object):Array {
			var r:Array = [];
			for(var prop:String in obj) {
				r.push(prop);
			}
			return r;
		}
		
		public static function values(obj:Object):Array {
			var r:Array = [];
			for each(var value:* in obj) {
				r.push(value);
			}
			return r;
		}
		
		public static function hasProp(obj:Object, prop:String):Boolean {
			for(var p:String in obj) {
				if(p === prop) {
					return true;
				}
			}
			return false;
		}
		
		public static function hasValue(obj:Object, value:*):Boolean {
			for each(var v:* in obj) {
				if(v === value) {
					return true;
				}
			}
			return false;
		}
		
		public static function merge(base:Object, fill:Object):Object {
			var r:Object = {};
			var prop:String;
			
			for(prop in base) {
				r[prop] = base[prop];
			}
			for(prop in fill) {
				!r.hasOwnProperty(prop) && (r[prop] = fill[prop]);
			}
			return r;
		}
	}
}