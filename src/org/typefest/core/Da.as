/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.core {
	public class Da {
		static public const W3CDTF_EXP:RegExp = /^(\d{4})(?:-(\d{2})(?:-(\d{2})(?:T(\d{2}):(\d{2})(?::(\d{2})(?:(\.\d+))?)?((?:(?:\+|-)\d{2}:\d{2})|Z))?)?)?$/;
		
		public static function compareEarlier(a:Date, b:Date):int {
			if(a.time < b.time) {
				return -1;
			} else if(a.time > b.time) {
				return 1;
			} else {
				return 0;
			}
		}
		
		public static function compareLater(a:Date, b:Date):int {
			if(b.time < a.time) {
				return -1;
			} else if(b.time > a.time) {
				return 1;
			} else {
				return 0;
			}
		}
		
		public static function copy(d:Date):Date {
			return new Date(d.time);
		}
		
		public static function valid(d:Date):Boolean {
			return d.toString() !== "Invalid Date";
		}
		
		public static function dateToTime(date:Number):Number {
			return date * 86400000; // 24 * 60 * 60 * 1000 = 86400000
		}
		
		public static function hoursToTime(hours:Number):Number {
			return hours * 3600000; // 60 * 60 * 1000 = 3600000
		}
		
		public static function minutesToTime(minutes:Number):Number {
			return minutes * 60000; // 60 * 1000 = 60000
		}
		
		public static function secondsToTime(seconds:Number):Number {
			return seconds * 1000;
		}
		
		public static function timeToDate(time:Number):Number {
			return time / 86400000;
		}
		
		public static function timeToHours(time:Number):Number {
			return time / 3600000;
		}
		
		public static function timeToMinutes(time:Number):Number {
			return time / 60000;
		}
		
		public static function timeToSeconds(time:Number):Number {
			return time / 1000;
		}
		
		public static function addTime(d:Date, ...times:Array):Date {
			return new Date(d.time + Num.add.apply(null, times));
		}
		
		public static function addSeconds(d:Date, ...seconds:Array):Date {
			return new Date(d.time + Num.add.apply(null, Arr.map(secondsToTime, seconds)));
		}
		
		public static function addMinutes(d:Date, ...minutes:Array):Date {
			return new Date(d.time + Num.add.apply(null, Arr.map(minutesToTime, minutes)));
		}
		
		public static function addHours(d:Date, ...hours:Array):Date {
			return new Date(d.time + Num.add.apply(null, Arr.map(hoursToTime, hours)));
		}
		
		public static function addDate(d:Date, ...dates:Array):Date {
			return new Date(d.time + Num.add.apply(null, Arr.map(dateToTime, dates)));
		}
		
		/*
		// http://www.w3.org/TR/NOTE-datetime
		// 
		// recommend using as3corelib
		// http://code.google.com/p/as3corelib/
		*/
		static public function w3cdtfToDate(str:String):Date {
			var $:* = W3CDTF_EXP.exec(str);
			
			if($) {
				var d:Date = new Date(0);
				
				d.fullYearUTC = parseInt($[1]);
				
				if($[2] !== undefined) {
					
					d.monthUTC = parseInt($[2]) - 1;
					
					if($[3] !== undefined) {
						
						d.dateUTC = parseInt($[3]);
						
						if($[4] !== undefined) {
							
							d.hoursUTC   = parseInt($[4]);
							d.minutesUTC = parseInt($[5]);
							
							if($[6] !== undefined) {
								
								d.secondsUTC = parseInt($[6]);
								
								if($[7] !== undefined) {
									
									d.millisecondsUTC = parseFloat($[7]) * 1000;
								}
							}
							
							var tz:String = $[8];
							
							if(tz !== "Z") {
								var tzhours:int   = parseInt(tz.substr(1, 2));
								var tzminutes:int = parseInt(tz.substr(4, 2));
								var sign:int      = (tz.charAt(0) === "+") ? -1 : 1;
								
								d.time += (hoursToTime(tzhours) + minutesToTime(tzminutes)) * sign;
							}
						}
					}
				}
				
				return d;
			} else {
				throw new ArgumentError("Da.w3cdtfToDate: parse error");
			}
		}
	}
}