/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
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