/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.core {
	
	
	public class Rnd extends Object {
		
		/*
		
		// returns generator
		
		var r:Function = Rnd.antirepeat("hello", "world", "foo", "bar");
		r();
		r();
		r();
		
		*/
		static public function antirepeat(...args:Array):Function {
			var len:int = args.length;
			
			if (len === 1) {
				var x:* = args[0];
				args = null;
				return function():* {
					return x;
				}
			} else {
				var _:Function = function():* {
					var j:int = Math.floor(Math.random() * len);
					_ = function():* {
						var i:int = Math.floor(Math.random() * (len - 1));
						(i >= j) && i++;
						return args[j = i];
					}
					return args[j];
				}
				return function():* {
					return _();
				}
			}
		}
		
		/*
		// returns generator
		// be careful to avoid infinite loop
		*/
		static public function antirepeatWrapper(generator:Function):Function {
			var _:Function = function():* {
				var x:* = generator();
				_ = function():* {
					var y:*;
					do {
						y = generator();
					} while (y === x);
					return x = y;
				}
				return x;
			}
			return function():* {
				_();
			}
		}
		
		/*
		// returns generator
		*/
		static public function shift(...args:Array):Function {
			return function():* {
				if (args.length > 0) {
					return args.splice(Math.floor(Math.random() * args.length), 1)[0];
				} else {
					throw new Error("Stop iteration.");
				}
			}
		}
		static public function loopedShift(...args:Array):Function {
			var store:Array = args.concat();
			
			return function():* {
				if (!args.length) {
					args = store.concat();
				}
				return args.splice(Math.floor(Math.random() * args.length), 1)[0];
			}
		}
		
		/*
		
		// returns generator
		
		var r:Function = Rnd.rate(
			["hello", 5],
			["world", 3],
			["foo",   1],
			["bar",   0.2]
		);
		r();
		r();
		r();
		
		*/
		static public function rate(...pairs:Array):Function {
			var denominator:Number = 0;
			for each (var pair:Array in pairs) {
				denominator += pair[1];
			}
			
			var thresholds:Array = [];
			var numerator:Number = 0;
			var elements:Array   = [];
			for (var i:int = 0; i < pairs.length; i++) {
				numerator += pairs[i][1];
				thresholds.push(numerator / denominator);
				elements.push(pairs[i][0]);
			}
			
			var len:int = pairs.length;
			
			return function():* {
				var random:Number = Math.random();
				for (var i:int = 0; i < len; i++) {
					if (random < thresholds[i]) {
						return elements[i];
					}
				}
			}
		}
	}
}