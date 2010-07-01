/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.core {
	import flash.utils.Dictionary;
	
	
	
	
	
	public class Arr {
		/*
		
		- combination(n:int, arr:Array)
		
		*/
		
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
		
		static public function copyTree(arr:Array):Array {
			var _:Array = [];
			
			for each (var value:* in arr) {
				if (value is Array) {
					_.push(copyTree(value));
				} else {
					_.push(value);
				}
			}
			
			return _;
		}
		
		public static function array(...args:Array):Array {
			return args;
		}
		
		
		
		
		
		//---------------------------------------
		// range
		//---------------------------------------
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
		
		
		
		
		
		//---------------------------------------
		// every / some
		//---------------------------------------
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
		
		
		
		
		
		//---------------------------------------
		// find
		//---------------------------------------
		public static function find(fn:Function, arr:Array):Array {
			var len:int = arr.length;
			for(var i:int = 0; i < len; i++) {
				if(fn(arr[i])) {
					return arr.slice(i);
				}
			}
			return [];
		}
		
		
		
		
		
		//---------------------------------------
		// filter
		//---------------------------------------
		static public function filter(fn:Function, a:*):Array {
			var _:Array = [];
			
			for each (var value:* in a) {
				if (fn(value)) {
					_.push(value);
				}
			}
			return _;
		}
		static public function ifilter(fn:Function, a:*):Array {
			var _:Array = [];
			var i:int   = 0;
			
			for each (var value:* in a) {
				if (fn(value, i++)) {
					_.push(value);
				}
			}
			return _;
		}
		static public function filterTree(
			fn:Function,
			arr:Array,
			keep:Boolean = true
		):Array {
			var _:Array = [];
			var result:Array;
			
			for each (var value:* in arr) {
				if (value is Array) {
					result = filterTree(fn, value);
					
					if (keep || result.length) {
						_.push(result);
					}
				} else {
					if (fn(value)) {
						_.push(value);
					}
				}
			}
			
			return _;
		}
		static public function filterCount(fn:Function, a:*):int {
			var count:int = 0;
			
			for each (var value:* in a) {
				if (fn(value)) {
					count++;
				}
			}
			return count;
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
		
		
		
		
		
		//---------------------------------------
		// map
		//---------------------------------------
		static public function map(fn:Function, ...arrs:Array):Array {
			var _:Array = [];
			var len:int = Math.min.apply(null, select(arrs, "length"));
			
			for (var i:int = 0; i < len; i++) {
				_.push(fn.apply(null, select(arrs, i)));
			}
			return _;
		}
		static public function imap(fn:Function, ...arrs:Array):Array {
			var _:Array = [];
			var len:int = Math.min.apply(null, select(arrs, "length"));
			
			for (var i:int = 0; i < len; i++) {
				_.push(fn.apply(null, select(arrs, i).concat([i])));
			}
			return _;
		}
		static public function mapTree(fn:Function, a:Array):Array {
			var _:Array = [];
			
			for each (var value:* in a) {
				if (value is Array) {
					_.push(mapTree(fn, value));
				} else {
					_.push(fn(value));
				}
			}
			
			return _;
		}
		static public function mapSide(fn:Function, arr:Array):Array {
			var _:Array = [];
			
			for (var i:int = 1; i < arr.length; i++) {
				_.push(fn(arr[i - 1], arr[i]));
			}
			return _;
		}
		
		
		
		
		
		//---------------------------------------
		// each
		//---------------------------------------
		static public function each(fn:Function, ...arrs:Array):void {
			var len:int = Math.min.apply(null, select(arrs, "length"));
			
			for (var i:int = 0; i < len; i++) {
				fn.apply(null, select(arrs, i));
			}
		}
		static public function ieach(fn:Function, ...arrs:Array):void {
			var len:int = Math.min.apply(null, select(arrs, "length"));
			
			for (var i:int = 0; i < len; i++) {
				fn.apply(null, select(arrs, i).concat([i]));
			}
		}
		static public function eachTree(fn:Function, arr:Array):void {
			for each (var value:* in arr) {
				if (value is Array) {
					eachTree(fn, value);
				} else {
					fn(value);
				}
			}
		}
		static public function eachSide(fn:Function, arr:Array):void {
			for (var i:int = 1; i < arr.length; i++) {
				fn(arr[i - 1], arr[i]);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// zip
		//---------------------------------------
		static public function zip(...arrs:Array):Array {
			var len:int = Math.min.apply(null, select(arrs, "length"));
			var _:Array = [];
			
			for (var i:int = 0; i < len; i++) {
				_.push(select(arrs, i));
			}
			
			return _;
		}
		
		
		
		
		//---------------------------------------
		// fold
		//---------------------------------------
		static public function foldLeft(fn:Function, init:*, arr:Array):* {
			if (arr.length) {
				return foldLeft(fn, fn(init, arr[0]), arr.slice(1));
			} else {
				return init;
			}
		}
		static public function foldRight(fn:Function, init:*, arr:Array):* {
			if (arr.length) {
				return foldRight(fn, fn(arr[arr.length - 1], init), arr.slice(0, -1));
			} else {
				return init;
			}
		}
		
		
		
		
		
		//---------------------------------------
		// select / dig / take
		//---------------------------------------
		static public function select(a:*, key:*):Array {
			var _:Array = [];
			
			for each (var value:* in a) {
				_.push(a[key]);
			}
			return _;
		}
		static public function dig(a:*, keys:Array):Array {
			var _:Array = [];
			
			for each (var value:* in a) {
				_.push(Misc.dig(value, keys));
			}
			return _;
		}
		static public function take(a:*, keys:Array, def:* = null):Array {
			var _:Array = [];
			
			for each (var value:* in a) {
				_.push(Misc.take(value, keys, def));
			}
			return _;
		}
		
		
		
		
		
		//---------------------------------------
		// best
		//---------------------------------------
		public static function best(fn:Function, arr:Array):* {
			var r:*     = arr[0];
			var len:int = arr.length;
			
			for(var i:int = 1; i < len; i++) {
				r = fn(r, arr[i]);
			}
			return r;
		}
		
		
		
		
		
		//---------------------------------------
		// flatten
		//---------------------------------------
		static public function flatten(arr:Array, level:int = -1):Array {
			var _:Array = [];
			
			for each (var value:* in arr) {
				if (level !== 0 && value is Array) {
					_.push.apply(null, flatten(value, level - 1));
				} else {
					_.push(value);
				}
			}
			
			return _;
		}
		
		
		
		
		
		//---------------------------------------
		// slide
		//---------------------------------------
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
		
		
		
		
		
		//---------------------------------------
		// equality
		//---------------------------------------
		///// Array’s order does matter.
		static public function equal(a:Array, b:Array):Boolean {
			if (a.length !== b.length) {
				return false;
			}
			for (var i:int = 0; i < a.length; i++) {
				if (a[i] !== b[i]) {
					return false;
				}
			}
			return true;
		}
		///// Arrays’ order does matter.
		static public function equalTree(a:Array, b:Array):Boolean {
			if (a.length !== b.length) {
				return false;
			}
			for (var i:int = 0; i < a.length; i++) {
				if (a[i] !== b[i]) {
					if (a[i] is Array && b[i] is Array) {
						if (!equalTree(a[i], b[i])) {
							return false;
						}
					} else {
						return false;
					}
				}
			}
			return true;
		}
		///// Array’s order doesn’t matter.
		static public function same(a:Array, b:Array):Boolean {
			if (a.length !== b.length) {
				return false;
			}
			
			b = b.concat();
			var i:int;
			
			for each (var value:* in a) {
				i = b.indexOf(value);
				
				if (i < 0) {
					return false;
				} else {
					b.splice(i, 1);
				}
			}
			
			return true;
		}
		///// Arrays’ order doesn’t matter.
		static public function sameTree(a:Array, b:Array):Boolean {
			if (a.length !== b.length) {
				return false;
			}
			
			b = b.concat();
			var i:int;
			var value2:*;
			var cont:Boolean;
			
			for each (var value:* in a) {
				if (value is Array) {
					cont = false;
					
					for each (value2 in b) {
						if (value2 is Array) {
							if (sameTree(value, value2)) {
								b.splice(b.indexOf(value2), 1);
								cont = true;
								break;
							}
						}
					}
					
					if (!cont) {
						return false;
					}
				} else {
					i = b.indexOf(value);
					
					if (i < 0) {
						return false;
					} else {
						b.splice(i, 1);
					}
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
		
		
		
		
		
		//---------------------------------------
		// shuffle
		//---------------------------------------
		///// via http://la.ma.la/blog/diary_200608300350.htm
		public static function shuffle(arr:Array):Array {
			var r:Array = arr.concat();
			var i:uint  = r.length;
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
		
		
		
		
		
		//---------------------------------------
		// reverse
		//---------------------------------------
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
		
		
		
		
		
		//---------------------------------------
		// pick
		//---------------------------------------
		public static function pick(arr:Array):* {
			return arr[Math.floor(Math.random() * arr.length)];
		}
		
		
		
		
		
		//---------------------------------------
		// set operations
		//---------------------------------------
		static public function unite(...aa:Array):Array {
			var _:Array        = [];
			var set:Dictionary = new Dictionary();
			var a:*;
			var v:*;
			
			for each (a in aa) {
				for each (v in a) {
					if (!set[v]) {
						set[v] = true;
						_.push(v);
					}
				}
			}
			
			return _;
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