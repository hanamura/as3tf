/*
as3tf
http://code.google.com/p/as3tf/

Licensed under the MIT License

Copyright (c) 2008 Taro Hanamura

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package org.typefest.core {
	public class Str {
		public static function empty(str:String):Boolean {
			return str == "";
		}
		
		public static function upper(str:String):String {
			return str.toUpperCase();
		}
		
		public static function lower(str:String):String {
			return str.toLowerCase();
		}
		
		public static function first(str:String):String {
			return str.charAt(0);
		}
		
		public static function rest(str:String):String {
			return str.substr(1);
		}
		
		public static function most(str:String):String {
			return str.substr(0, str.length - 1);
		}
		
		public static function last(str:String):String {
			return str.charAt(str.length - 1);
		}
		
		public static function compare(str1:String, str2:String):int {
			var len1:int = str1.length;
			var len2:int = str2.length;
			var len:int  = (len1 < len2) ? len1 : len2;
			var code1:int;
			var code2:int;
			
			for(var i:int = 0; i < len; i++) {
				code1 = str1.charCodeAt(i);
				code2 = str2.charCodeAt(i);
				if(code1 < code2) {
					return -1;
				} else if(code1 > code2) {
					return 1;
				}
			}
			
			if(len1 < len2) {
				return -1;
			} else if(len1 > len2) {
				return 1;
			} else {
				return 0;
			}
		}
		
		public static function right(str:String, len:int, pad:String = " "):String {
			while(str.length < len) {
				str = pad + str;
			}
			return str;
		}
		
		public static function center(str:String, len:int, pad:String = " "):String {
			var left:Boolean = true;
			while(str.length < len) {
				str = left ? str + pad : pad + str;
				left = !left;
			}
			return str;
		}
		
		public static function left(str:String, len:int, pad:String = " "):String {
			while(str.length < len) {
				str = str + pad;
			}
			return str;
		}
		
		/*
		*	// Python-style String Formatting Operations
		*	// http://www.python.org/doc/lib/typesseq-strings.html
		*	// 
		*	// conversion types, g and G are not supported yet
		*	
		*	Str.format(string, value0, value1, value2...);
		*	Str.format(string, dict); // dict is not needed to be a Dictionary
		*	
		*	*/
		public static function format(source:String, ...args:Array):String {
			var ext:RegExp = /%(?:\((.+?)\))?([#0 +-]+)?((?:[1-9]\d*)|\*)?(?:\.((?:\d+)|\*))?([hlL])?([diouxXeEfFgGcrs%])/g;
			
			var arg0:* = args[0];
			
			return source.replace(ext, function(...$:Array):String {
				var matchString:String     = $[0];
				
				var mappingKey:String      = $[1];
				var conversionFlags:String = $[2];
				var minimumFieldWidth:int  = ($[3] === "") ? -1 : (($[3] === "*") ? parseInt(args.shift()) : parseInt($[3]));
				var precision:int          = ($[4] === "") ? -1 : (($[4] === "*") ? parseInt(args.shift()) : parseInt($[4]));
				var lengthModifier:String  = $[5];
				var conversionType:String  = $[6];
				
				var matchIndex:int         = $[7];
				var entireString:String    = $[8];
				
				var val:* = (mappingKey === "") ? args.shift() : arg0[mappingKey];
				
				var left:Boolean = conversionFlags.indexOf("-") !== -1;
				
				var pad:String;
				if(!left && conversionFlags.indexOf("0") !== -1) {
					pad = "0";
				} else {
					pad = " ";
				}
				
				var sign:String;
				if(conversionFlags.indexOf("+") !== -1) {
					sign = "+";
				} else if(conversionFlags.indexOf(" ") !== -1) {
					sign = " ";
				} else {
					sign = "";
				}
				
				var alt:Boolean = conversionFlags.indexOf("#") !== -1;
				
				return _conversionTypes[conversionType](val, pad, left, sign, alt, minimumFieldWidth, precision);
			});
		}
		// alt  : true / false
		// pad  : 0 / space
		// left : true / false
		// sign : plus / space / empty
		protected static var _conversionTypes:Object = {};
		_conversionTypes["d"] = function(val:*, pad:String, left:Boolean, sign:String, alt:Boolean, width:int, precision:int):String {
			var i:int = parseInt(val);

			if(i < 0) {
				sign = "-";
				i *= -1;
			}

			var s:String = Str.right(i.toString(), precision, "0");

			if(pad === "0") {
				s = Str.right(s, width - sign.length, pad);
				s = sign + s;
			} else {
				s = sign + s;
				s = (left ? Str.left : Str.right)(s, width, pad);
			}

			return s;
		}
		_conversionTypes["i"] = _conversionTypes["d"];
		_conversionTypes["o"] = function(val:*, pad:String, left:Boolean, sign:String, alt:Boolean, width:int, precision:int):String {
			var i:int = parseInt(val);

			if(i < 0) {
				sign = "-";
				i *= -1;
			}

			var s:String = Str.right(i.toString(8), precision, "0");

			var prefix:String = alt ? "0" : "";

			if(pad === "0") {
				s = Str.right(s, width - sign.length - prefix.length, pad);
				s = sign + prefix + s;
			} else {
				s = sign + prefix + s;
				s = (left ? Str.left : Str.right)(s, width, pad);
			}

			return s;
		}
		_conversionTypes["u"] = _conversionTypes["d"];
		_conversionTypes["x"] = function(val:*, pad:String, left:Boolean, sign:String, alt:Boolean, width:int, precision:int):String {
			var i:int = parseInt(val);

			if(i < 0) {
				sign = "-";
				i *= -1;
			}

			var s:String = Str.right(i.toString(16), precision, "0");

			var prefix:String = alt ? "0x" : "";

			if(pad === "0") {
				s = Str.right(s, width - sign.length - prefix.length, pad);
				s = sign + prefix + s;
			} else {
				s = sign + prefix + s;
				s = (left ? Str.left : Str.right)(s, width, pad);
			}

			return s;
		}
		_conversionTypes["X"] = function(val:*, pad:String, left:Boolean, sign:String, alt:Boolean, width:int, precision:int):String {
			return _conversionTypes["x"](val, pad, left, sign, alt, width, precision).toUpperCase();
		}
		_conversionTypes["e"] = function(val:*, pad:String, left:Boolean, sign:String, alt:Boolean, width:int, precision:int):String {
			var f:Number = parseFloat(val);

			if(precision === -1) {
				precision = 6;
			}

			var s:String;

			if(f === 0) {
				s = "0";

				if(alt || precision > 0) {
					s = s + "." + Str.left("", precision, "0");
				}

				s = s + "e+00";
			} else {
				if(f < 0) {
					sign = "-";
					f *= -1;
				}

				var exp:String = f.toExponential(precision + 1);
				var ext:RegExp = (/^(\d+)(?:\.(\d+))?(?:(e[+-])(\d+))?$/);

				var $:*      = ext.exec(exp);
				var $head:*  = $[1];
				var $tail:*  = $[2];
				var $e:*     = $[3];
				var $place:* = $[4];

				if($e === undefined) {
					$e     = "e+";
					$place = "00";
				}

				$place = Str.right($place, 2, "0");

				var rounded:String = Math.round(parseInt($head + $tail) / 10).toString();

				s = rounded.charAt(0);

				if(alt || rounded.length > 1) {
					s = s + "." + rounded.substr(1);
				}

				s = s + $e + $place;
			}

			if(pad === "0") {
				s = Str.right(s, width - sign.length, pad);
				s = sign + s;
			} else {
				s = sign + s;
				s = (left ? Str.left : Str.right)(s, width, pad);
			}

			return s;
		}
		_conversionTypes["E"] = function(val:*, pad:String, left:Boolean, sign:String, alt:Boolean, width:int, precision:int):String {
			return _conversionTypes["e"](val, pad, left, sign, alt, width, precision).toUpperCase();
		}
		_conversionTypes["f"] = function(val:*, pad:String, left:Boolean, sign:String, alt:Boolean, width:int, precision:int):String {
			var f:Number = parseFloat(val);

			if(precision === -1) {
				precision = 6;
			}

			if(f < 0) {
				sign = "-";
				f *= -1;
			}

			var i:int = Math.floor(f);

			if(i > 0) {
				precision += i.toString().length;
			}

			var s:String = (precision === 0) ? Math.round(f).toString() : f.toPrecision(precision);

			if(alt && s.indexOf(".") === -1) {
				s = s + ".";
			}

			if(pad === "0") {
				s = Str.right(s, width - sign.length, pad);
				s = sign + s;
			} else {
				s = sign + s;
				s = (left ? Str.left : Str.right)(s, width, pad);
			}

			return s;
		}
		_conversionTypes["F"] = _conversionTypes["f"];
		// _conversionTypes["g"] = function(val:*, pad:String, left:Boolean, sign:String, alt:Boolean, width:int, precision:int):String {
        // 
		// }
		// _conversionTypes["G"] = function(val:*, pad:String, left:Boolean, sign:String, alt:Boolean, width:int, precision:int):String {
        // 
		// }
		_conversionTypes["c"] = function(val:*, pad:String, left:Boolean, sign:String, alt:Boolean, width:int, precision:int):String {
			var s:String = (val is int) ? String.fromCharCode(val) : val.toString().charAt(0);
			return (left ? Str.left : Str.right)(s, width, " ");
		}
		_conversionTypes["r"] = function(val:*, pad:String, left:Boolean, sign:String, alt:Boolean, width:int, precision:int):String {
			return (left ? Str.left : Str.right)(val.toString(), width, " ");
		}
		_conversionTypes["s"] = function(val:*, pad:String, left:Boolean, sign:String, alt:Boolean, width:int, precision:int):String {
			return (left ? Str.left : Str.right)(val.toString(), width, " ");
		}
		_conversionTypes["%"] = function(val:*, pad:String, left:Boolean, sign:String, alt:Boolean, width:int, precision:int):String {
			return (left ? Str.left : Str.right)("%", width, " ");
		}
		
		// public static function decodeCER(str:String):String {
		// 	return str.replace(/&#(x?)([^;]+);/g, function(...$:Array):String {
		// 		if($[1] === "x") {
		// 			return String.fromCharCode(parseInt("0x" + $[2]));
		// 		} else {
		// 			return String.fromCharCode(parseInt($[2]));
		// 		}
		// 	});
		// }
	}
}