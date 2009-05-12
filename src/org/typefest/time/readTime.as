/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time {
	/*
	
	// example expressions:
	// 
	// readTime(timeExpression:*)
	// -> [time:Number, frame:Boolean]
	// 
	// readTime(timeExpression:*, cont:Function)
	// -> cont(time:Number, frame:Boolean)
	// 
	// readTime(timeExpression:*, timeCont:Function, frameCont:Function)
	// -> timeCont(seconds:Number) or frameCont(frames:int)
	
	*/
	public function readTime(time:*, fn1:Function = null, fn2:Function = null):* {
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