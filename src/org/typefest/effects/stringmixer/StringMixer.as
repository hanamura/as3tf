/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.effects.stringmixer {
	public class StringMixer extends Object {
		/*
		
		// usage:
		
		var mixer:StringMixer = new StringMixer("Hello World");
		
		for(var i:int = 0; i <= 20; i++) {
			mixer.ratio = i / 20;
			trace(mixer.text);
		}
		
		// output:
		//     
		//     ?
		//     A\
		//     B]b
		//     D_db
		//     E`ec
		//     Gbgef
		//     Hchfgu
		//     HejhiwM
		//     HeljjyO
		//     HelklzPf
		//     Helln|Rhh
		//     Hello}Sij
		//     Hello Ukld
		//     Hello Vlme[
		//     Hello Wnnf\
		//     Hello Woph^
		//     Hello Woqi_
		//     Hello Worka
		//     Hello Worlb
		//     Hello World
		
		*/
		
		static public function loop(target:Number, min:Number, max:Number):Number {
			var range:Number = max - min;
			var num:Number   = target - max;
			
			while (num < 0) {
				num += range;
			}
			return (num % range) + min;
		}
		
		//---------------------------------------
		// instance
		//---------------------------------------
		protected var _dest:String  = null;
		protected var _text:String  = "";
		protected var _ratio:Number = 0;
		
		public function get dest():String {
			return _dest;
		}
		public function set dest(str:String):void {
			if (_dest !== str) {
				_dest = str;
				_update();
			}
		}
		public function get text():String {
			return _text;
		}
		public function get ratio():Number {
			return _ratio;
		}
		public function set ratio(num:Number):void {
			num = num < 0 ? 0 : num > 1 ? 1 : num;
			
			if (_ratio !== num) {
				_ratio = num;
				_update();
			}
		}
		
		///// custom functions
		protected var _localRatioFunction:Function = null;
		protected var _charFunction:Function       = null;
		
		public function get localRatioFunction():Function {
			return _localRatioFunction;
		}
		public function set localRatioFunction(fn:Function):void {
			if (_localRatioFunction !== fn) {
				_localRatioFunction = fn;
				_update();
			}
		}
		public function get charFunction():Function {
			return _charFunction;
		}
		public function set charFunction(fn:Function):void {
			if (_charFunction !== fn) {
				_charFunction = fn;
				_update();
			}
		}
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function StringMixer(
			dest:String                 = "",
			localRatioFunction:Function = null,
			charFunction:Function       = null
		) {
			super();
			
			_dest               = dest;
			_localRatioFunction = localRatioFunction;
			_charFunction       = charFunction;
			
			_update();
		}
		
		//---------------------------------------
		// get local ratio / get char
		//---------------------------------------
		/*
		// Override these methods or
		// set localRatioFunction and charFunction
		// to change behavior.
		// (better performance with overriding)
		*/
		protected function _getLocalRatio(
			index:int,
			length:int,
			ratio:Number
		):Number {
			///// Length of string is not concerned. DIY.
			
			if (_localRatioFunction !== null) {
				return _localRatioFunction.call(this, index, length, ratio);
			} else {
				var position:Number = index / (length - 1);
				var a:Number = -2;
				var b:Number = (1 - a) * ratio;
				var r:Number = (a * position) + b;

				return r < 0 ? 0 : r > 1 ? 1 : r;
			}
		}
		protected function _getChar(dest:String, ratio:Number):String {
			///// Non-ascii characters are not concerned. DIY.
			
			if (_charFunction !== null) {
				return _charFunction.call(this, dest, ratio);
			} else {
				if (dest === "\n") {
					return "\n";
				}
				if (ratio <= 0) {
					return "";
				}
				if (ratio >= 1) {
					return dest;
				}
				var code:int  = dest.charCodeAt(0);
				var minus:int = Math.round((1 - ratio) * 10);
				var trans:int = loop(code - minus, 32, 127);
				
				return String.fromCharCode(trans);
			}
		}
		
		//---------------------------------------
		// update
		//---------------------------------------
		protected function _update():void {
			var chars:Array = [];
			var len:int     = _dest.length;
			var c:String;
			var r:Number;
			
			for (var i:int = 0; i < len; i++) {
				c = _dest.charAt(i);
				r = _getLocalRatio(i, len, _ratio);
				chars.push(_getChar(c, r));
			}
			_text = chars.join("");
		}
	}
}