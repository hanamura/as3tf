/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.core {
	public class Num {
		//---------------------------------------
		// sign
		//---------------------------------------
		public static function sign(num:Number):int {
			return num > 0 ? 1 : num < 0 ? -1 : 0;
		}
		
		
		
		
		
		//---------------------------------------
		// pinch
		//---------------------------------------
		public static function pinch(min:Number, target:Number, max:Number):Number {
			return target < min ? min : target > max ? max : target;
		}
		
		
		
		
		
		//---------------------------------------
		// even
		//---------------------------------------
		public static function even(num:int):Boolean {
			return (num % 2 == 0);
		}
		
		
		
		
		
		//---------------------------------------
		// interger
		//---------------------------------------
		public static function integer(num:Number):Boolean {
			return (num % 1) == 0;
		}
		
		
		
		
		
		//---------------------------------------
		// loop
		//---------------------------------------
		/* 
		*	var degree:Number;
		*	
		*	degree = 560;
		*	Num.loop(degree, -180, 180); // -160
		*	
		*	degree = -650;
		*	Num.loop(degree, -180, 180); // 70
		*	
		*	degree = 180;
		*	Num.loop(degree, -180, 180); // -180
		*	
		*	*/
		public static function loop(target:Number, min:Number, max:Number):Number {
			var volume:Number = max - min;
			var v:Number = target - max;
			while(v < 0) { v += volume }
			return (v % volume) + min;
		}
		
		
		
		
		
		//---------------------------------------
		// distance
		//---------------------------------------
		public static function clockwise(a:Number, b:Number, length:Number):Number {
			while(b > a) {
				b -= length;
			}
			while(b < a) {
				b += length;
			}
			
			return b - a;
		}
		public static function nearer(a:Number, b:Number, length:Number):Number {
			var c:Number = clockwise(a, b, length);
			
			return (c >= length / 2) ? c - length : c;
		}
		
		
		
		
		
		//---------------------------------------
		// average
		//---------------------------------------
		public static function average(...args:Array):Number {
			return Num.add.apply(null, args) / args.length;
		}
		
		
		
		
		
		//---------------------------------------
		// round
		//---------------------------------------
		public static function round(num:Number, level:int):Number {
			var effect:Number = Math.pow(10, level);
			return Math.round(num * effect) / effect;
		}
		
		
		
		
		
		//---------------------------------------
		// between
		//---------------------------------------
		public static function between(a:Number, b:Number, ratio:Number = 0.5):Number {
			return a + ((b - a) * ratio);
		}
		
		
		
		
		
		//---------------------------------------
		// add, sub, mul, div
		//---------------------------------------
		public static function add(...args:Array):Number {
			var rNum:Number = 0;
			for(var i:uint = 0; i < args.length; i++) {
				rNum += args[i];
			}
			return rNum;
		}
		public static function sub(base:Number, ...rest:Array):Number {
			if(rest.length == 0) {
				return -base;
			} else {
				for(var i:uint = 0; i < rest.length; i++) {
					base -= rest[i];
				}
				return base;
			}
		}
		public static function mul(...args:Array):Number {
			var rNum:Number = 1;
			for(var i:uint = 0; i < args.length; i++) {
				rNum *= args[i];
			}
			return rNum;
		}
		public static function div(base:Number, ...rest:Array):Number {
			if(rest.length == 0) {
				return 1 / base;
			} else {
				for(var i:uint = 0; i < rest.length; i++) {
					base /= rest[i];
				}
				return base;
			}
		}
		
		
		
		
		
		//---------------------------------------
		// random
		//---------------------------------------
		public static function coin():Number {
			return (Math.random() < 0.5) ? 1 : -1;
		}
		public static function random(...nums:Array):Number {
			if(Arr.empty(nums)) {
				return Math.random();
			} else if(Arr.single(nums)) {
				return Math.random() * nums[0];
			} else {
				return (Math.random() * (nums[1] - nums[0])) + nums[0];
			}
		}
		
		
		
		
		
		//---------------------------------------
		// gcd & lcm
		//---------------------------------------
		static public function gcd(a:int, b:int):int {
			return (a >= b) ? _gcd(a, b) : _gcd(b, a);
		}
		static protected function _gcd(m:int, n:int):int {
			return n ? _gcd(n, m % n) : m;
		}
		static public function lcm(a:int, b:int):int {
			return (a && b) ? ((a * b) / gcd(a, b)) : 0;
		}
		
		
		
		
		
		//---------------------------------------
		// radian & degree
		//---------------------------------------
		public static function radToDeg(rad:Number):Number {
			return rad * 57.29577951308232;
		}
		public static function degToRad(deg:Number):Number {
			return deg * 0.017453292519943295;
		}
	}
}