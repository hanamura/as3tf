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

package org.typefest.dev {
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class Benchmark {
		protected static var _dict:Dictionary = new Dictionary();
		
		protected static function _str(n:int, len:int):String {
			var s:String = n.toString();
			
			while(s.length < len) {
				s = " " + s;
			}
			
			return s;
		}
		
		public static function start(name:String, option:String = null):String {
			_dict[name] = new T(getTimer());
			
			var out:String = "[Benchmark:" + name + " start   0]                    |                   |";
			
			if(option !== null) {
				out += " " + option;
			}
			
			trace(out);
			return out;
		}
		
		public static function check(name:String, option:String = null):String {
			if(_dict[name] !== undefined) {
				var curr:Number      = getTimer();
				var t:T              = _dict[name];
				var fromLast:String  = _str(curr - t.last, 6);
				var fromStart:String = _str(curr - t.start, 6);
				var count:String     = _str(++t.count, 3);
				
				t.last = curr;
				
				var out:String = "[Benchmark:" + name + " check " + count + "] from start: " + fromStart + " | from last: " + fromLast + " |";
				
				if(option !== null) {
					out += " " + option;
				}
				
				trace(out);
				return out;
			} else {
				trace("[Benchmark:" + name + " undef]");
				return "[Benchmark:" + name + " undef]";
			}
		}
		
		public static function end(name:String, option:String = null):String {
			if(_dict[name] !== undefined) {
				var curr:Number      = getTimer();
				var t:T              = _dict[name];
				var fromLast:String  = _str(curr - t.last, 6);
				var fromStart:String = _str(curr - t.start, 6);
				var count:String     = _str(++t.count, 3);
				
				delete _dict[name];
				
				var out:String = "[Benchmark:" + name + " end   " + count + "] from start: " + fromStart + " | from last: " + fromLast + " |";
				
				if(option !== null) {
					out += " " + option;
				}
				
				trace(out);
				return out;
			} else {
				trace("[Benchmark:" + name + " undef]");
				return "[Benchmark:" + name + " undef]";
			}
		}
	}
}

internal class T {
	public var start:Number = 0;
	public var last:Number  = 0;
	public var count:int    = 0;
	
	public function T(start:Number) {
		this.start = this.last = start;
	}
}