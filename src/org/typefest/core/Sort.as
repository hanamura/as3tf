/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.core {
	public class Sort {
		
		public static function larger(a:Number, b:Number):int {
			if(a > b) {
				return -1;
			} else if(a < b) {
				return 1;
			} else {
				return 0;
			}
		}
		
		public static function smaller(a:Number, b:Number):int {
			if(a < b) {
				return -1;
			} else if(a > b) {
				return 1;
			} else {
				return 0;
			}
		}
		
		/*
		*	var compareSeason:Function = Sort.referred("spring", "summer", "fall", "winter");
		*	
		*	var arr:Array = [
		*		"winter", "summer", "winter", "fall",
		*		"spring", "summer", "fall", "spring"
		*	];
		*	
		*	var sorted:Array = Sort.sort(arr, compareSeason);
		*	
		*	// sorted is [spring, spring, summer, summer, fall, fall, winter, winter]
		*	
		*	*/
		public static function referred(...values:Array):Function {
			var len:int = values.length;
			
			return function(a:*, b:*):int {
				var v:*;
				
				for(var i:int = 0; i < len; i++) {
					v = values[i];
					
					if(a === v) {
						if(b === v) {
							return 0;
						} else {
							return -1;
						}
					} else if(b === v) {
						return 1;
					}
				}
				return 0;
			}
		}
		
		// public static function dug(compare:Function, ...sels:Array):Function {
		// 	return function(a:*, b:*):int {
		// 		
		// 	}
		// }
		
		/*
		*	var smaller:Function = Sort.translate(Math.min);
		*	
		*	var arr:Array = [2, 3, 1, 0, 5, 6, 2.3, 6.1, 4.3, 5.1];
		*	
		*	var sorted:Array = Sort.sort(arr, smaller);
		*	
		*	// sorted is [0, 1, 2, 2.3, 3, 4.3, 5, 5.1, 6, 6.1]
		*	
		*	*/
		public static function translate(fn:Function):Function {
			return function(a:*, b:*):int {
				if(fn(a, b) === a) {
					return -1;
				} else {
					return 1;
				}
			}
		}
		
		public static function complement(compare:Function):Function {
			return function(a:*, b:*):int {
				return -compare(a, b);
			}
		}
		
		public static function compose(...compares:Array):Function {
			return function(a:*, b:*):int {
				var result:int = compares[0](a, b);
				var index:int  = 1;
				
				while(result === 0 && index < compares.length) {
					result = compares[index](a, b);
					index++;
				}
				return result;
			}
		}
		
		public static function first(arr:Array, compare:Function):* {
			var len:int = arr.length;
			
			var a:* = arr[0];
			var b:*;
			
			for(var i:int = 1; i < len; i++) {
				b = arr[i];
				
				if(compare(a, b) > 0) {
					a = b;
				}
			}
			
			return a;
		}
		
		public static function ifirst(arr:Array, compare:Function):int {
			var len:int = arr.length;
			
			var index:int = 0;
			
			var a:* = arr[0];
			var b:*;
			
			for(var i:int = 1; i < len; i++) {
				b = arr[i];
				
				if(compare(a, b) > 0) {
					a = b;
					index = i;
				}
			}
			
			return index;
		}
		
		public static function last(arr:Array, compare:Function):* {
			var len:int = arr.length;
			
			var a:* = arr[len - 1];
			var b:*;
			
			for(var i:int = len - 2; i >= 0; i--) {
				b = arr[i];
				
				if(compare(a, b) < 0) {
					a = b;
				}
			}
			
			return a;
		}
		
		public static function ilast(arr:Array, compare:Function):int {
			var len:int = arr.length;
			
			var index:int = 0;
			
			var a:* = arr[len - 1];
			var b:*;
			
			for(var i:int = len - 2; i >= 0; i--) {
				b = arr[i];
				
				if(compare(a, b) < 0) {
					a = b;
					index = i;
				}
			}
			
			return index;
		}
		
		/*
		*	// array must be previously sorted
		*	
		*	var arr:Array  = [];
		*	var data:Array = [2, 3, 1, 0, 5, 6, 2.3, 6.1, 4.3, 5.1];
		*	
		*	var num:Number;
		*	var index:int;
		*	
		*	while(data.length > 0) {
		*		num   = data.pop();
		*		index = Sort.lookup(arr, num, Sort.smaller);
		*		arr.splice(index, 0, num);
		*	}
		*	
		*	// now, arr is [0, 1, 2, 2.3, 3, 4.3, 5, 5.1, 6, 6.1]
		*	
		*	*/
		public static function lookup(arr:Array, data:*, fn:Function):int {
			if(arr.length <= 0) {
				return 0;
			} else if(arr.length === 1) {
				return (fn(arr[0], data) <= 0) ? 1 : 0;
			} else if(arr.length === 2) {
				if(fn(arr[0], data) > 0) {
					return 0;
				} else if(fn(arr[1], data) <= 0) {
					return 2;
				} else {
					return 1;
				}
			} else {
				var start:int    = 0;
				var end:int      = arr.length - 1;
				var left:Boolean = true;
				var center:int, index:int;
				
				while(true) {
					if(end - start === 1) {
						if(left) {
							index = (fn(arr[start], data) <= 0) ? end : start;
						} else {
							index = (fn(arr[end], data) <= 0) ? end + 1 : end;
						}
						break;
					} else {
						center = Math.floor((start + end) * 0.5);
						
						if(fn(arr[center], data) <= 0) {
							start = center;
							left  = false;
						} else {
							end  = center;
							left = true;
						}
					}
				}
				
				return index;
			}
		}
		
		public static function sort(arr:Array, compare:Function = null):Array {
			return arr.concat().sort((compare === null) ? Sort.smaller : compare);
		}
	}
}