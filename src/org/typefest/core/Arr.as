/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.core {
	import flash.utils.Dictionary;
	
	public class Arr {
		/*
		*	- combination(n:int, arr:Array)
		*	- destructive::pullout(arr:Array, index:int)
		*	
		*	*/
		
		public static function index(i:uint, arr:Array):* {
			return arr[i];
		}
		
		public static function length(arr:Array):int {
			return arr.length;
		}
		
		public static function empty(arr:Array):Boolean {
			return arr.length === 0;
		}
		
		public static function single(arr:Array):Boolean {
			return arr.length === 1;
		}
		
		public static function multiple(arr:Array):Boolean {
			return arr.length > 1;
		}
		
		public static function tree(arr:Array):Boolean {
			for(var i:int = 0; i < arr.length; i++) {
				if(arr[i] is Array) {
					return true;
				}
			}
			return false;
		}
		
		public static function first(arr:Array):* {
			return arr[0];
		}
		
		public static function rest(arr:Array):Array {
			return arr.slice(1);
		}
		
		public static function most(arr:Array):Array {
			return arr.slice(0, arr.length - 1);
		}
		
		public static function last(arr:Array):* {
			return arr[arr.length - 1];
		}
		
		public static function append(...arrs:Array):Array {
			var r:Array = [];
			for(var i:int = 0; i < arrs.length; i++) {
				r.push.apply(null, arrs[i]);
			}
			return r;
		}
		
		public static function push(arr:Array, v:*):Array {
			var r:Array = Arr.copy(arr);
			r.push(v);
			return r;
		}
		
		public static function unshift(v:*, arr:Array):Array {
			var r:Array = Arr.copy(arr);
			r.unshift(v);
			return r;
		}
		
		public static function copy(arr:Array):Array {
			return arr.concat();
		}
		
		public static function copyTree(arr:Array):Array {
			var rArr:Array = [];
			for(var i:int = 0; i < arr.length; i++) {
				if(arr[i] is Array) {
					rArr.push(arguments.callee(arr[i]));
				} else {
					rArr.push(arr[i]);
				}
			}
			return rArr;
		}
		
		public static function array(...args:Array):Array {
			return args;
		}
		
		public static function range(...args:Array):Array {
			var from:Number = 0;
			var to:Number;
			var step:Number = 1;
			
			switch(args.length) {
				case 1:
					to = args[0];
					break;
				case 2:
					from = args[0];
					to   = args[1];
					break;
				case 3:
					from = args[0];
					to   = args[1];
					step = args[2];
					break;
				default:
					return [];
			}
			
			var r:Array = [];
			
			do {
				r.push(from);
			} while((from += step) < to);
			
			return r;
		}
		
		
		
		public static function every(fn:Function, arr:Array):Boolean {
			var len:int = arr.length;
			for(var i:int = 0; i < len; i++) {
				if(!fn(arr[i])) { return false; }
			}
			return true;
		}
		
		public static function some(fn:Function, arr:Array):Boolean {
			var len:int = arr.length;
			for(var i:int = 0; i < len; i++) {
				if(fn(arr[i])) { return true; }
			}
			return false;
		}
		
		public static function find(fn:Function, arr:Array):Array {
			var len:int = arr.length;
			for(var i:int = 0; i < len; i++) {
				if(fn(arr[i])) {
					return arr.slice(i);
				}
			}
			return [];
		}
		
		public static function filter(fn:Function, arr:Array):Array {
			var r:Array = [];
			var len:int = arr.length;
			var v:*;
			for(var i:int = 0; i < len; i++) {
				fn(v = arr[i]) && r.push(v);
			}
			return r;
		}
		
		public static function ifilter(fn:Function, arr:Array):Array {
			var r:Array = [];
			var len:int = arr.length;
			var v:*;
			for(var i:int = 0; i < len; i++) {
				fn(v = arr[i], i) && r.push(v);
			}
			return r;
		}
		
		public static function filterTree(fn:Function, arr:Array, saveEmpty:Boolean = true):Array {
			var r:Array = [];
			var temp:Array;
			for(var i:int = 0; i < arr.length; i++) {
				if(arr[i] is Array) {
					temp = arguments.callee(fn, arr[i], saveEmpty);
					if(saveEmpty || !Arr.empty(temp)) {
						r.push(temp);
					}
				} else {
					if(fn(arr[i])) {
						r.push(arr[i]);
					}
				}
			}
			return r;
		}
		
		public static function filterCount(fn:Function, arr:Array):int {
			var c:int = 0;
			var len:int = arr.length;
			for(var i:int = 0; i < len; i++) {
				fn(arr[i]) && c++;
			}
			return c;
		}
		
		public static function and(arr:Array, ...fns:Array):Array {
			var rec:Function = function(arr:Array, fns:Array):Array {
				if(empty(fns) || empty(arr)) {
					return arr;
				} else {
					return arguments.callee(filter(first(fns), arr), rest(fns));
				}
			}
			return rec(arr, fns);
		}
		
		public static function or(arr:Array, ...fns:Array):Array {
			var rec:Function = function(arr:Array, fns:Array, acc:Array, len:uint):Array {
				if(Arr.empty(fns) || acc.length == len) {
					return acc;
				} else {
					var fn:Function = Arr.first(fns);
					var fs:Array = [];
					var val:*;

					for(var i:int = 0; i < arr.length; i++) {
						val = arr[i];
						(fn(val) ? acc : fs).push(val);
					}

					return arguments.callee(fs, Arr.rest(fns), acc, len);
				}
			}
			return rec(arr, fns, [], arr.length);
		}
		
		public static function map(fn:Function, arr:Array):Array {
			var r:Array = [];
			var len:int = arr.length;
			for(var i:int = 0; i < len; i++) {
				r.push(fn(arr[i]));
			}
			return r;
		}
		
		public static function imap(fn:Function, arr:Array):Array {
			var r:Array = [];
			var len:int = arr.length;
			for(var i:int = 0; i < len; i++) {
				r.push(fn(arr[i], i));
			}
			return r;
		}
		
		public static function mapArgs(fn:Function, ...args:Array):Array {
			var rArr:Array = [];
			var len:uint = Math.min.apply(null, Arr.map(Arr.length, args));
			var argList:Array;
			for(var i:int = 0; i < len; i++) {
				argList = Arr.map(Fn.reserve(Arr.index, i), args);
				rArr.push(fn.apply(null, argList));
			}
			return rArr;
		}
		
		public static function mapTree(fn:Function, arr:Array):Array {
			var r:Array = [];
			for(var i:int = 0; i < arr.length; i++) {
				if(arr[i] is Array) {
					r.push(arguments.callee(fn, arr[i]));
				} else {
					r.push(fn(arr[i]));
				}
			}
			return r;
		}
		
		public static function mapSide(fn:Function, arr:Array):Array {
			var r:Array = [];
			for(var i:int = 1; i < arr.length; i++) {
				r.push(fn(arr[i - 1], arr[i]));
			}
			return r;
		}
		
		public static function each(fn:Function, arr:Array):void {
			var len:int = arr.length;
			for(var i:int = 0; i < len; i++) {
				fn(arr[i]);
			}
		}
		
		public static function ieach(fn:Function, arr:Array):void {
			var len:int = arr.length;
			for(var i:int = 0; i < len; i++) {
				fn(arr[i], i);
			}
		}
		
		public static function eachArgs(fn:Function, ...args:Array):void {
			var r:Array = [];
			var len:uint = Math.min.apply(null, Arr.map(Arr.length, args));
			for(var i:int = 0; i < len; i++) {
				fn.apply(null, Arr.map(Fn.reserve(Arr.index, i), args));
			}
		}
		
		public static function eachTree(fn:Function, arr:Array):void {
			for(var i:int = 0; i < arr.length; i++) {
				if(arr[i] is Array) {
					arguments.callee(fn, arr[i]);
				} else {
					fn(arr[i]);
				}
			}
		}
		
		public static function eachSide(fn:Function, arr:Array):void {
			for(var i:int = 1; i < arr.length; i++) {
				fn(arr[i - 1], arr[i]);
			}
		}
		
		static public function zip(...arrs:Array):Array {
			var len:int = Math.min.apply(null, select(arrs, "length"));
			var _:Array = [];
			
			for (var i:int = 0; i < len; i++) {
				_.push(select(arrs, i));
			}
			
			return _;
		}
		
		public static function foldLeft(fn:Function, init:*, arr:Array):* {
			if(empty(arr)) {
				return init;
			} else {
				return arguments.callee(fn, fn(init, first(arr)), rest(arr));
			}
		}
		
		public static function foldRight(fn:Function, init:*, arr:Array):* {
			if(empty(arr)) {
				return init;
			} else {
				return arguments.callee(fn, fn(last(arr), init), most(arr));
			}
		}
		
		public static function select(arr:Array, sel:*):Array {
			var r:Array = [];
			var len:int = arr.length;
			
			for(var i:int = 0; i < len; i++) {
				r.push(arr[i][sel]);
			}
			return r;
		}
		
		public static function best(fn:Function, arr:Array):* {
			var r:*     = arr[0];
			var len:int = arr.length;
			
			for(var i:int = 1; i < len; i++) {
				r = fn(r, arr[i]);
			}
			return r;
		}
		
		public static function flatten(arr:Array, level:int = -1):Array {
			var r:Array = [];
			var len:uint = arr.length;
			for(var i:int = 0; i < len; i++) {
				if(arr[i] is Array) {
					if(level == 0) {
						r.push(arr[i]);
					} else if(level < 0) {
						r.push.apply(null, arguments.callee(arr[i], level));
					} else {
						r.push.apply(null, arguments.callee(arr[i], level - 1));
					}
				} else {
					r.push(arr[i]);
				}
			}
			return r;
		}
		
		public static function slide(arr:Array, count:int):Array {
			var r:Array = arr.concat();
			var reg:int = Num.loop(count, 0, arr.length);
			
			if(reg !== 0) {
				r.splice.apply(null, [0, 0].concat(r.splice(arr.length - reg, reg)));
			}
			
			return r;
		}
		
		public static function unique(arr:Array):Array {
			var r:Array = [];
			var len:int = arr.length;
			var dict:Dictionary = new Dictionary();
			for(var i:int = 0; i < len; i++) {
				if(dict[arr[i]] === undefined) {
					r.push(arr[i]);
					dict[arr[i]] = true;
				}
			}
			return r;
		}
		
		public static function has(obj:*, arr:Array):Boolean {
			return arr.indexOf(obj) !== -1;
		}
		
		public static function hasTree(obj:*, arr:Array):Boolean {
			for(var i:int = 0; i < arr.length; i++) {
				if(arr[i] is Array) {
					if(arguments.callee(obj, arr[i])) {
						return true;
					}
				} else {
					if(arr[i] === obj) {
						return true;
					}
				}
			}
			return false;
		}
		
		public static function common(a:Array, b:Array):Boolean {
			for each(var elem:* in a) {
				if(has(elem, b)) {
					return true;
				}
			}
			return false;
		}
		
		/* Array’s order does matter. */
		public static function equal(arr1:Array, arr2:Array):Boolean {
			if(arr1.length != arr2.length) { return false }
			var len:uint = arr1.length;
			for(var i:int = 0; i < len; i++) {
				if(arr1[i] !== arr2[i]) { return false }
			}
			return true;
		}
		
		/* Arrays’ order does matter. */
		public static function equalTree(arr1:Array, arr2:Array):Boolean {
			if(arr1.length != arr2.length) { return false }
			var len:uint = arr1.length;
			for(var i:int = 0; i < len; i++) {
				if((arr1[i] is Array) && (arr2[i] is Array)) {
					if(!arguments.callee(arr1[i], arr2[i])) { return false }
				} else {
					if(arr1[i] !== arr2[i]) { return false }
				}
			}
			return true;
		}
		
		/* Array’s order doesn’t matter. */
		public static function same(arr1:Array, arr2:Array):Boolean {
			if(arr1.length != arr2.length) { return false }
			var len:uint = arr1.length;
			var a2:Array = Arr.copy(arr2);
			var index:int;
			for(var i:int = 0; i < len; i++) {
				index = a2.indexOf(arr1[i]);
				if(index == -1) { return false }
				a2.splice(index, 1);
			}
			return true;
		}
		
		/* Arrays’ order doesn’t matter. */
		public static function sameTree(arr1:Array, arr2:Array):Boolean {
			if(arr1.length != arr2.length) { return false }
			var len:uint = arr1.length;
			var a2:Array = Arr.copy(arr2);
			var index:uint;
			for(var i:int = 0; i < len; i++) {
				if(arr1[i] is Array) {
					var hasSame:Boolean = false;
					for(var j:int = 0; j < a2.length; j++) {
						if(a2[j] is Array) {
							if(arguments.callee(arr1[i], a2[j])) {
								hasSame = true;
								a2.splice(j, 1);
								break;
							}
						}
					}
					if(!hasSame) { return false }
				} else {
					index = a2.indexOf(arr1[i]);
					if(index == -1) { return false }
					a2.splice(index, 1);
				}
			}
			return true;
		}
		
		public static function member(obj:*, arr:Array):Array {
			for(var i:uint = 0; i < arr.length; i++) {
				if(arr[i] === obj) { return arr.slice(i) }
			}
			return [];
		}
		
		public static function count(obj:*, arr:Array):uint {
			var n:uint = 0;
			for(var i:uint = 0; i < arr.length; i++) {
				if(arr[i] === obj) { n++ }
			}
			return n;
		}
		
		/* via http://la.ma.la/blog/diary_200608300350.htm */
		public static function shuffle(arr:Array):Array {
			var r:Array = Arr.copy(arr);
			var i:uint = r.length;
			var j:uint;
			var t:*;
			while(i) {
				j = Math.floor(Math.random() * i);
				t = r[--i];
				r[i] = r[j];
				r[j] = t;
			}
			return r;
		}
		
		public static function reverse(arr:Array):Array {
			var rArr:Array = [];
			for(var i:int = arr.length - 1; i >= 0; i--) {
				rArr.push(arr[i]);
			}
			return rArr;
		}
		
		public static function remove(obj:*, arr:Array):Array {
			var r:Array = [];
			var len:int = arr.length;
			var data:*;
			
			for(var i:int = 0; i < len; i++) {
				data = arr[i];
				
				(data !== obj) && r.push(data);
			}
			
			return r;
		}
		
		public static function pick(arr:Array):* {
			return arr[Math.floor(Math.random() * arr.length)];
		}
		
		public static function unite(...arrs:Array):Array {
			var dict:Dictionary = new Dictionary();
			var len:int = arrs.length;
			var r:Array = [];
			var arrLen:int;
			var arr:Array;
			var elem:*;
			var i:int;
			var j:int;
			
			for(i = 0; i < len; i++) {
				arr = arrs[i];
				arrLen = arr.length;
				for(j = 0; j < arrLen; j++) {
					elem = arr[j];
					if(dict[elem] === undefined) {
						dict[elem] = true;
						r.push(elem);
					}
				}
			}
			
			return r;
		}
		
		public static function subtract(base:Array, sub:Array, unique:Boolean = true):Array {
			var subDict:Dictionary = new Dictionary();
			var elem:*;
			
			for each(elem in sub) {
				subDict[elem] = true;
			}
			
			var r:Array = [];
			var len:int = base.length;
			var i:int;
			
			if(unique) {
				var rDict:Dictionary = new Dictionary();
				
				for(i = 0; i < len; i++) {
					elem = base[i];
					
					if(subDict[elem] === undefined && rDict[elem] === undefined) {
						r.push(elem);
						rDict[elem] = true;
					}
				}
			} else {
				for(i = 0; i < len; i++) {
					elem = base[i];
					
					if(subDict[elem] === undefined) {
						r.push(elem);
					}
				}
			}
			
			return r;
		}
		
		public static function _intersect(...arrs:Array):Array {
			
			if(arrs.length == 0) {
				return [];
			} else if(arrs.length == 1) {
				return Arr.copy(Arr.first(arrs));
			}
			
			var $intersect:Function = function(first:Array, second:Array):Array {
				var firstDict:Dictionary  = new Dictionary();
				var secondDict:Dictionary = new Dictionary();
				var result:Array          = [];
				var val:*;
				var i:int;
				
				for(i = 0; i < first.length; i++) {
					firstDict[first[i]] = true;
				}
				
				for(i = 0; i < second.length; i++) {
					val = second[i];
					if(firstDict[val] !== undefined && secondDict[val] === undefined) {
						secondDict[val] = true;
						result.push(val);
					}
				}
				
				return result;
			}
			
			var rec:Function = function(first:Array, rest:Array):Array {
				if(Arr.empty(rest)) {
					return first;
				} else {
					var second:Array = Arr.first(rest);
					return arguments.callee($intersect(first, second), Arr.rest(rest));
				}
			}
			
			return rec(Arr.first(arrs), Arr.rest(arrs));
		}
		
		public static function intersect(...arrs:Array):Array {
			
			var len:int = arrs.length;
			
			if(len == 0) {
				return [];
			} else if(len == 1) {
				return Arr.copy(Arr.first(arrs));
			}
			
			var dict:Dictionary = new Dictionary();
			var result:Array = [];
			var arrDict:Dictionary;
			var arr:Array = arrs[0];
			var elem:*;
			var i:int;
			var j:int;
			
			for(i = 0; i < arr.length; i++) {
				dict[arr[i]] = 1;
			}
			
			for(i = 1; i < len - 1; i++) {
				arr = arrs[i];
				arrDict = new Dictionary();
				for(j = 0; j < arr.length; j++) {
					elem = arr[j];
					if(dict[elem] !== undefined && arrDict[elem] === undefined) {
						arrDict[elem] = true;
						dict[elem]++;
					}
				}
			}
			
			arr = arrs[len - 1];
			arrDict = new Dictionary();
			for(i = 0; i < arr.length; i++) {
				elem = arr[i];
				if(dict[elem] !== undefined && arrDict[elem] === undefined) {
					arrDict[elem] = true;
					dict[elem]++;
					if(dict[elem] == len) {
						result.push(elem);
					}
				}
			}
			
			return result;
			
		}
		
		public static function exclude(arr1:Array, arr2:Array, unique:Boolean = true):Array {
			return Arr.subtract(arr1.concat(arr2), Arr.intersect(arr1, arr2), unique);
		}
	}
}