/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.core {
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import org.typefest.namespaces.destructive;
	
	
	
	
	
	public class Misc {
		//---------------------------------------
		// identity
		//---------------------------------------
		public static function pass(object:*):* {
			return object;
		}
		
		
		
		
		
		//---------------------------------------
		// strict equality
		//---------------------------------------
		public static function eeeq(a:*, b:*):Boolean {
			return a === b;
		}
		public static function eeeqFn(b:*):Function {
			return function(a:*):Boolean {
				return a === b;
			}
		}
		
		
		
		
		
		//---------------------------------------
		// equality
		//---------------------------------------
		public static function eeq(a:*, b:*):Boolean {
			return a == b;
		}
		public static function eeqFn(b:*):Function {
			return function(a:*):Boolean {
				return a == b;
			}
		}
		
		
		
		
		
		//---------------------------------------
		// assign
		//---------------------------------------
		destructive static function assign(object:*, key:*, value:*):void {
			object[key] = value;
		}
		
		
		
		
		
		//---------------------------------------
		// select
		//---------------------------------------
		public static function select(object:*, key:String):* {
			return object[key];
		}
		public static function selectFn(key:String):Function {
			return function(object:*):* {
				return object[key];
			}
		}
		
		
		
		
		
		//---------------------------------------
		// dig
		//---------------------------------------
		static public function dig(object:*, keys:Array):* {
			keys = keys.concat();
			
			while (keys.length) {
				object = object[keys.shift()];
			}
			return object;
		}
		static public function digFn(keys:Array):Function {
			return function(object:*):* {
				return dig.apply(null, [object].concat([keys]));
			}
		}
		
		
		
		
		
		//---------------------------------------
		// take
		//---------------------------------------
		///// exception-free version of dig
		static public function take(object:*, keys:Array, def:* = null):* {
			keys = keys.concat();
			
			var key:*;
			
			while (keys.length) {
				key = keys.shift();
				
				if (object is Object && key in object) {
					object = object[key];
				} else {
					return def;
				}
			}
			return object;
		}
		static public function takeFn(keys:Array, def:* = null):Function {
			return function(object:*):* {
				return take.apply(null, [object].concat([keys, def]));
			}
		}
		
		
		
		
		
		//---------------------------------------
		// is
		//---------------------------------------
		public static function isFn(cl:Class):Function {
			return function(obj:*):Boolean {
				return obj is cl;
			}
		}
		
		
		
		
		
		//---------------------------------------
		// strict is
		//---------------------------------------
		public static function strictIs(obj:*, cl:Class):Boolean {
			return cl === Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		public static function strictIsFn(cl:Class):Function {
			return function(obj:*):Boolean {
				return cl === Class(getDefinitionByName(getQualifiedClassName(obj)));
			}
		}
		
		
		
		
		
		//---------------------------------------
		// clone
		//---------------------------------------
		static public function clone(a:*):* {
			var ba:ByteArray = new ByteArray();
			ba.writeObject(a);
			ba.position = 0;
			return ba.readObject();
		}
	}
}