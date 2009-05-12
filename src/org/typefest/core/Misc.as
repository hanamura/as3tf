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
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import org.typefest.namespaces.destructive;
	
	public class Misc {
		/*
		*	todo:
		*	
		*	- make dig safer for premitive values
		*	
		*	*/
		
		public static function pass(obj:*):* {
			return obj;
		}
		
		public static function eeeq(a:*, b:*):Boolean {
			return a === b;
		}
		
		public static function eeq(a:*, b:*):Boolean {
			return a == b;
		}
		
		public static function eeeqFn(obj:*):Function {
			return function(val:*):Boolean {
				return val === obj;
			}
		}
		
		public static function eeqFn(obj:*):Function {
			return function(val:*):Boolean {
				return val == obj;
			}
		}
		
		public static function select(obj:*, sel:String):* {
			return obj[sel];
		}
		
		public static function selectFn(sel:String):Function {
			return function(obj:*):* {
				return obj[sel];
			}
		}
		
		destructive static function assign(obj:*, sel:String, value:*):void {
			obj[sel] = value;
		}
		
		public static function dig(obj:*, ...sels:Array):* {
			var rec:Function = function(obj:*, sels:Array):* {
				if(obj === null || obj === undefined || Arr.empty(sels)) {
					return obj;
				} else {
					return arguments.callee(obj[Arr.first(sels)], Arr.rest(sels));
				}
			}
			return rec(obj, sels);
		}
		
		public static function digFn(...sels:Array):Function {
			return function(obj:*):* {
				return dig.apply(null, Arr.unshift(obj, sels));
			}
		}
		
		// destructive static function bury(obj:*, ...rest:Array):void {
		// 	
		// }
		
		// dig having default
		public static function strike(obj:*, def:*, ...sels:Array):* {
			var dug:* = dig.apply(null, Arr.unshift(obj, sels));
			
			return (dug === undefined) ? def : dug;
		}
		
		public static function isFn(cl:Class):Function {
			return function(obj:*):Boolean {
				return obj is cl;
			}
		}
		
		public static function strictIs(obj:*, cl:Class):Boolean {
			return cl === Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		
		public static function strictIsFn(cl:Class):Function {
			return function(obj:*):Boolean {
				return cl === Class(getDefinitionByName(getQualifiedClassName(obj)));
			}
		}
	}
}