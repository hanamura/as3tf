/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.core {
	import flash.utils.Dictionary;
	
	public class Fn {
		protected static const _MEMO:Dictionary = new Dictionary(); // for memoize
		
		public static const EXPIRED:Object = {}; // for limit
		public static const BLANK:Object   = {}; // for reserve
		
		public static function call(fn:Function, ...args:Array):* {
			return fn.apply(null, args);
		}
		
		public static function apply(fn:Function, args:Array):* {
			return fn.apply(null, args);
		}
		
		public static function bind(obj:*, fn:Function):Function {
			return function(...args:Array):* {
				return fn.apply(obj, args);
			}
		}
		
		public static function limit(count:uint, fn:Function):Function {
			var l:int = count;
			(l == 0) && (fn = null);
			return function(...args:Array):* {
				var r:*;
				r = (l > 0) ? fn.apply(this, args) : Fn.EXPIRED;
				(l > -1) && l--;
				(l == 0) && (fn = null);
				return r;
			}
		}
		
		public static function complement(fn:Function):Function {
			return function(...args:Array):Boolean {
				return !fn.apply(this, args);
			}
		}
		
		/*
		*	var fn:Function = Fn.compose(a, b, c);
		*	
		*	fn(argument); // is same as c(b(a(argument)))
		*	*/
		public static function compose(...fns:Array):Function {
			var rec:Function = function(fns:Array, arg:*):* {
				if(Arr.empty(fns)) {
					return arg;
				} else {
					return arguments.callee(Arr.rest(fns), Arr.first(fns).call(this, arg));
				}
			}
			return function(...args:Array):* {
				return rec(Arr.rest(fns), Arr.first(fns).apply(this, args));
			}
		}
		
		static public function calling(sel:*, ...args:Array):Function {
			return function(x:*):* {
				return x[sel].apply(null, args);
			}
		}
		static public function setting(sel:*, value:*):Function {
			return function(x:*):void {
				x[sel] = value;
			}
		}
		static public function getting(sel:*):Function {
			return function(x:*):* {
				return x[sel];
			}
		}
		
		/*
		*	// usage:
		*	
		*	var addTen:Function = Fn.reserve(Num.add, 10);
		*	addTen(5); // returns 15. it equals "Num.add(10, 5)"
		*	
		*	var oneToTen:Function = Fn.reserve(Num.pinch, 1, Fn.BLANK, 10);
		*	oneToTen(20); // returns 10. it equals "Num.pinch(1, 20, 10)"
		*	*/
		static public function reserve(fn:Function, ...a:Array):Function {
			return function(...b:Array):* {
				var c:Array = [];
				
				for each (var value:* in a) {
					if (value === Fn.BLANK) {
						c.push(b.shift());
					} else {
						c.push(value);
					}
				}
				return fn.apply(this, c.concat(b));
			}
		}
		
		/*
		*	// incomplete. recommended not using
		*	
		*	*/
		public static function memoize(fn:Function):Function {
			if(fn in _MEMO) {
				return _MEMO[fn];
			} else {
				var results:Dictionary  = new Dictionary();
				var argsDict:Dictionary = new Dictionary();

				return _MEMO[fn] = function(...args:Array):* {

					var dict:Dictionary = argsDict;
					var count:int       = 0;
					var arg:*;
					var some:Boolean;
					var key:*;

					while(true) {
						if(count >= args.length) {
							if(dict in results) {
								return results[dict];
							} else {
								return results[dict] = fn.apply(null, args);
							}
						} else {
							arg  = args[count++];
							some = false;

							for(key in dict) {
								if(key === arg) {
									some = true;
									break;
								}
							}

							if(!some) {
								dict[arg] = new Dictionary();
							}
							dict = dict[arg];
						}
					}
				}
			}
		}
		
		public static function unmemoize(fn:Function):Boolean {
			return delete _MEMO[fn];
		}
		
		/*
		*	// via http://www.loveruby.net/ja/misc/ycombinator.html
		*	//
		*	// usage:
		*	
		*	var fact0:Function = function(f:Function):Function {
		*		return function(n:Number):Number {
		*			if(n === 0) {
		*				return 1;
		*			} else {
		*				return n * f(n - 1);
		*			}
		*		}
		*	}
		*	
		*	Fn.y(fact0)(5); // 120
		*	
		*	*/
		public static function y(f:Function):Function {
			return function(proc:Function):Function {
				return f(function(x:*):* {
					return proc(proc)(x);
				});
			}(function(proc:Function):Function {
				return f(function(x:*):* {
					return proc(proc)(x);
				});
			});
		}
		
		/*
		*	// compatible with multiple arguments
		*	
		*	*/
		public static function ym(f:Function):Function {
			return function(proc:Function):Function {
				return f(function(...args:Array):* {
					return proc(proc).apply(null, args);
				});
			}(function(proc:Function):Function {
				return f(function(...args:Array):* {
					return proc(proc).apply(null, args);
				});
			});
		}
		
		static public function create(Klass:Class, ...args:Array):* {
			switch (args.length) {
				case 0:
					return new Klass();
					break;
				case 1:
					return new Klass(args[0]);
					break;
				case 2:
					return new Klass(args[0], args[1]);
					break;
				case 3:
					return new Klass(args[0], args[1], args[2]);
					break;
				case 4:
					return new Klass(args[0], args[1], args[2], args[3]);
					break;
				case 5:
					return new Klass(args[0], args[1], args[2], args[3], args[4]);
					break;
				case 6:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5]);
					break;
				case 7:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
					break;
				case 8:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
					break;
				case 9:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
					break;
				case 10:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
					break;
				case 11:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]);
					break;
				case 12:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11]);
					break;
				case 13:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12]);
					break;
				case 14:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13]);
					break;
				case 15:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14]);
					break;
				case 16:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15]);
					break;
				case 17:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16]);
					break;
				case 18:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17]);
					break;
				case 19:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18]);
					break;
				case 20:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19]);
					break;
				case 21:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20]);
					break;
				case 22:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21]);
					break;
				case 23:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22]);
					break;
				case 24:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23]);
					break;
				case 25:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24]);
					break;
				case 26:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25]);
					break;
				case 27:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26]);
					break;
				case 28:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27]);
					break;
				case 29:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28]);
					break;
				case 30:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29]);
					break;
				case 31:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30]);
					break;
				case 32:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31]);
					break;
				case 33:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32]);
					break;
				case 34:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33]);
					break;
				case 35:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34]);
					break;
				case 36:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35]);
					break;
				case 37:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36]);
					break;
				case 38:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37]);
					break;
				case 39:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38]);
					break;
				case 40:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39]);
					break;
				case 41:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40]);
					break;
				case 42:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41]);
					break;
				case 43:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42]);
					break;
				case 44:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43]);
					break;
				case 45:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44]);
					break;
				case 46:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45]);
					break;
				case 47:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46]);
					break;
				case 48:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47]);
					break;
				case 49:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48]);
					break;
				case 50:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49]);
					break;
				case 51:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50]);
					break;
				case 52:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51]);
					break;
				case 53:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52]);
					break;
				case 54:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53]);
					break;
				case 55:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54]);
					break;
				case 56:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55]);
					break;
				case 57:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56]);
					break;
				case 58:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57]);
					break;
				case 59:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58]);
					break;
				case 60:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59]);
					break;
				case 61:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60]);
					break;
				case 62:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61]);
					break;
				case 63:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62]);
					break;
				case 64:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63]);
					break;
				case 65:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64]);
					break;
				case 66:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65]);
					break;
				case 67:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66]);
					break;
				case 68:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67]);
					break;
				case 69:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68]);
					break;
				case 70:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69]);
					break;
				case 71:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70]);
					break;
				case 72:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71]);
					break;
				case 73:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72]);
					break;
				case 74:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73]);
					break;
				case 75:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74]);
					break;
				case 76:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75]);
					break;
				case 77:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76]);
					break;
				case 78:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77]);
					break;
				case 79:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78]);
					break;
				case 80:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79]);
					break;
				case 81:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80]);
					break;
				case 82:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81]);
					break;
				case 83:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82]);
					break;
				case 84:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83]);
					break;
				case 85:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84]);
					break;
				case 86:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85]);
					break;
				case 87:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85], args[86]);
					break;
				case 88:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85], args[86], args[87]);
					break;
				case 89:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85], args[86], args[87], args[88]);
					break;
				case 90:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85], args[86], args[87], args[88], args[89]);
					break;
				case 91:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85], args[86], args[87], args[88], args[89], args[90]);
					break;
				case 92:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85], args[86], args[87], args[88], args[89], args[90], args[91]);
					break;
				case 93:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85], args[86], args[87], args[88], args[89], args[90], args[91], args[92]);
					break;
				case 94:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85], args[86], args[87], args[88], args[89], args[90], args[91], args[92], args[93]);
					break;
				case 95:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85], args[86], args[87], args[88], args[89], args[90], args[91], args[92], args[93], args[94]);
					break;
				case 96:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85], args[86], args[87], args[88], args[89], args[90], args[91], args[92], args[93], args[94], args[95]);
					break;
				case 97:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85], args[86], args[87], args[88], args[89], args[90], args[91], args[92], args[93], args[94], args[95], args[96]);
					break;
				case 98:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85], args[86], args[87], args[88], args[89], args[90], args[91], args[92], args[93], args[94], args[95], args[96], args[97]);
					break;
				case 99:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85], args[86], args[87], args[88], args[89], args[90], args[91], args[92], args[93], args[94], args[95], args[96], args[97], args[98]);
					break;
				case 100:
					return new Klass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29], args[30], args[31], args[32], args[33], args[34], args[35], args[36], args[37], args[38], args[39], args[40], args[41], args[42], args[43], args[44], args[45], args[46], args[47], args[48], args[49], args[50], args[51], args[52], args[53], args[54], args[55], args[56], args[57], args[58], args[59], args[60], args[61], args[62], args[63], args[64], args[65], args[66], args[67], args[68], args[69], args[70], args[71], args[72], args[73], args[74], args[75], args[76], args[77], args[78], args[79], args[80], args[81], args[82], args[83], args[84], args[85], args[86], args[87], args[88], args[89], args[90], args[91], args[92], args[93], args[94], args[95], args[96], args[97], args[98], args[99]);
					break;
				default:
					throw new ArgumentError("Too many arguments");
			}
		}
		
		static public function creating(Klass:Class):Function {
			return function(...args:Array):* {
				return create.apply(null, [Klass].concat(args));
			}
		}
	}
}