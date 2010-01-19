/*
Copyright (c) 2009 Taro Hanamura
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
		public static function reserve(fn:Function, ...args1:Array):Function {
			return function(...opts:Array):* {
				var args2:Array = [];
				var i:uint = 0;
				var o:uint = 0;
				for(; i < args1.length; i++) {
					if(args1[i] == Fn.BLANK) {
						args2.push(opts[o++]);
					} else {
						args2.push(args1[i]);
					}
				}
				for(; o < opts.length; o++) {
					args2.push(opts[o]);
				}
				return fn.apply(this, args2);
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
	}
}