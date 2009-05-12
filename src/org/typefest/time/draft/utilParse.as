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

package org.typefest.time.draft {
	/*
	*	// utilParse(timeExpression:*)
	*	// -> [time:Number, frame:Boolean]
	*	
	*	// utilParse(timeExpression:*, cont:Function)
	*	// -> cont(time:Number, frame:Boolean)
	*	
	*	// utilParse(timeExpression:*, timeCont:Function, frameCont:Function)
	*	// -> timeCont(seconds:Number) or frameCont(frames:int)
	*	
	*	*/
	public function utilParse(time:*, fn1:Function = null, fn2:Function = null):* {
		var number:Number = 0;
		var frame:Boolean = false;
		
		if(time is Number) {
			number = time;
		} else if(time is String) {
			var $:* = _frameexp.exec(time);
			
			if($) {
				number = parseInt($[1]);
				frame  = true;
			} else {
				var unit:String;
				var some:Boolean = false;
				
				while($ = _timeexp.exec(time)) {
					unit = $[2].toLowerCase();
					
					if(unit in _units) {
						number += _units[unit](parseFloat($[1]));
					}
					some = true;
				}
				
				if(!some) {
					number = parseFloat(time);
				}
			}
		} else {
			number = parseFloat(time);
		}
		
		return isNaN(number) ? null
		                     : (fn1 === null) ? [number, frame]
		                                      : (fn2 === null) ? fn1(number, frame)
		                                                       : frame ? fn2(number)
		                                                               : fn1(number);
	}
}

import flash.utils.Dictionary;

internal var _frameexp:RegExp  = /^\s*([0-9]+)\s*(?:frames?)?\s*$/i;
internal var _timeexp:RegExp   = /([0-9.]+)\s*([a-z]+)\s*/ig;
internal var _units:Dictionary = new Dictionary();
_units["millisecond"] = _units["milliseconds"] = function(time:Number):Number {
	return time / 1000;
}
_units["second"] = _units["seconds"] = _units["sec"] = function(time:Number):Number {
	return time;
}
_units["minute"] = _units["minutes"] = _units["min"] = function(time:Number):Number {
	return time * 60;
}
_units["hour"] = _units["hours"] = function(time:Number):Number {
	return time * 60 * 60;
}
_units["day"] = _units["days"] = function(time:Number):Number {
	return time * 60 * 60 * 24;
}