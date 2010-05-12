/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.effects.stringmixer {
	import org.typefest.core.Num;
	
	public class StringMixer {
		/*
		*	// usage:
		*	
		*	var sm:StringMixer = new StringMixer("Hello World");
		*	
		*	for(var i:int = 0; i <= 20; i++) {
		*		sm.ratio = i / 20;
		*		trace(sm.text);
		*	}
		*	
		*	// output:
		*	//     -----------
		*	//     ?----------
		*	//     A\---------
		*	//     B]b--------
		*	//     D_db-------
		*	//     E`ec-------
		*	//     Gbgef------
		*	//     Hchfgu-----
		*	//     HejhiwM----
		*	//     HeljjyO----
		*	//     HelklzPf---
		*	//     Helln|Rhh--
		*	//     Hello}Sij--
		*	//     Hello Ukld-
		*	//     Hello Vlme[
		*	//     Hello Wnnf\
		*	//     Hello Woph^
		*	//     Hello Woqi_
		*	//     Hello Worka
		*	//     Hello Worlb
		*	//     Hello World
		*	
		*	*/
		
		/*
		*	This function is not optimized to keep it simple.
		*	And by default, an object shows only basic ASCII characters.
		*	Assign your own getChar function to customize its behavior.
		*	
		*	*/
		protected static function _defaultGetChar(
			dest:String,
			ratio:Number
		):String {
			if(dest === "\n") {
				return dest;
			}
			if(ratio <= 0) {
				return "-";
			}
			
			var code:int  = dest.charCodeAt(0);
			var minus:int = Math.round((1 - ratio) * 10);
			var trans:int = Num.loop(code - minus, 32, 127);
			
			return String.fromCharCode(trans);
		}
		
		protected static function _defaultGetLocalRatio(
			x:Number,
			ratio:Number
		):Number {
			var a:Number = -2;
			var b:Number = (1 - a) * ratio;
			
			return Num.pinch(0, (a * x) + b, 1);
		}
		
		//---------------------------------------
		// Instance
		//---------------------------------------
		protected var _source:String = "";
		protected var _ratio:Number  = 0;
		protected var _text:String   = "";
		
		protected var _getChar:Function       = null;
		protected var _getLocalRatio:Function = null;
		
		public function get source():String {
			return _source;
		}
		public function set source(str:String):void {
			if(_source !== str) {
				_source = str;
				_update();
			}
		}
		
		public function get ratio():Number {
			return _ratio;
		}
		public function set ratio(num:Number):void {
			num = Num.pinch(0, num, 1);
			
			if(_ratio !== num) {
				_ratio = num;
				_update();
			}
		}
		
		public function get text():String {
			return _text;
		}
		
		public function get getChar():Function {
			return _getChar;
		}
		public function set getChar(fn:Function):void {
			if(_getChar !== fn) {
				_getChar = fn;
				_update();
			}
		}
		
		public function get getLocalRatio():Function {
			return _getLocalRatio;
		}
		public function set getLocalRatio(fn:Function):void {
			if(_getLocalRatio !== fn) {
				_getLocalRatio = fn;
				_update();
			}
		}
		
		public function StringMixer(
			source:String = "",
			getChar:Function = null,
			getLocalRatio:Function = null
		) {
			super();
			
			_source = source;
			
			if(getChar === null) {
				_getChar = _defaultGetChar;
			} else {
				_getChar = getChar;
			}
			
			if(getLocalRatio === null) {
				_getLocalRatio = _defaultGetLocalRatio;
			} else {
				_getLocalRatio = getLocalRatio;
			}
			
			_update();
		}
		
		protected function _update():void {
			var chars:Array = [];
			var c:String;
			var r:Number;
			
			for(var i:int = 0; i < _source.length; i++) {
				c = _source.charAt(i);
				r = _getLocalRatio(i / (_source.length - 1), _ratio);
				
				chars.push(_getChar(c, r));
			}
			
			_text = chars.join("");
		}
	}
}