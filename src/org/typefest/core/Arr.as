/*
Copyright (c) 2011 Taro Hanamura
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
			return arr.slice(0, -1);
		}
		
		public static function last(arr:Array):* {
			return arr[arr.length - 1];
		}
		
		static public function append(...arrs:Array):Array {
			return [].concat.apply(null, arrs);
		}
		
		static public function push(arr:Array, value:*):Array {
			arr = arr.concat();
			arr.push(value);
			return arr;
		}
		
		static public function unshift(arr:Array, value:*):Array {
			arr = arr.concat();
			arr.unshift(value);
			return arr;
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
		// fill
		//---------------------------------------
		static public function fill(length:int, data:* = null):Array {
			var _:Array = [];
			
			while (_.length < length) {
				_.push(data);
			}
			return _;
		}
		static public function jam(length:int, fn:Function):Array {
			var _:Array = [];
			
			while (_.length < length) {
				_.push(fn());
			}
			return _;
		}
		
		
		
		
		
		//---------------------------------------
		// every / some
		//---------------------------------------
		static public function every(fn:Function, a:*):Boolean {
			for each (var value:* in a) {
				if (!fn(value)) {
					return false;
				}
			}
			return true;
		}
		static public function some(fn:Function, a:*):Boolean {
			for each (var value:* in a) {
				if (fn(value)) {
					return true;
				}
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
		
		
		
		
		
		//---------------------------------------
		// and / or
		//---------------------------------------
		static public function and(arr:Array, ...fns:Array):Array {
			arr = arr.concat();
			
			while (fns.length && arr.length) {
				arr = filter(fns.shift(), arr);
			}
			return arr;
		}
		static public function or(arr:Array, ...fns:Array):Array {
			var _:Array = [];
			var value:*;
			var fn:Function;
			var some:Boolean;
			
			for each (value in arr) {
				some = false;
				
				for each (fn in fns) {
					if (fn(value)) {
						some = true;
						break;
					}
				}
				if (some) {
					_.push(value);
				}
			}
			
			return _;
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
				_.push(value[key]);
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
		static public function reverse(a:*):Array {
			var _:Array = [];
			
			for each (var value:* in a) {
				_.unshift(value);
			}
			return _;
		}
		
		
		
		
		
		static public function remove(object:*, a:*):Array {
			var _:Array = [];
			
			for each (var value:* in a) {
				if (value !== object) {
					_.push(value);
				}
			}
			return _;
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
		static public function subtract(a:Array, b:Array, unique:Boolean = true):Array {
			var _:Array         = [];
			var subs:Dictionary = new Dictionary();
			var value:*;
			
			for each (value in b) {
				subs[value] = true;
			}
			for each (value in a) {
				if (!subs[value]) {
					if (unique) {
						subs[value] = true;
					}
					_.push(value);
				}
			}
			
			return _;
		}
		static public function intersect(...aa:Array):Array {
			var d1:Dictionary = new Dictionary();
			var d2:Dictionary;
			var a:*;
			var v:*;
			
			a = aa.shift();
			
			for each (v in a) {
				d1[v] = true;
			}
			
			for each (a in aa) {
				d2 = new Dictionary();
				
				for each (v in a) {
					if (d1[v]) {
						d2[v] = true;
					}
				}
				
				d1 = d2;
			}
			
			var _:Array = [];
			
			for (v in d1) {
				_.push(v);
			}
			
			return _;
		}
		public static function exclude(a:Array, b:Array, unique:Boolean = true):Array {
			return subtract(a.concat(b), intersect(a, b), unique);
		}
	}
}