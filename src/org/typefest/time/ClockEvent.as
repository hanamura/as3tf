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

package org.typefest.time {
	import flash.events.Event;
	
	public class ClockEvent extends Event {
		public static const FULL_YEAR:String = "fullYear";
		public static const MONTH:String     = "month";
		public static const DATE:String      = "date";
		public static const HOURS:String     = "hours";
		public static const MINUTES:String   = "minutes";
		public static const SECONDS:String   = "seconds";
		
		/*
		*	a negative value means unavailable
		*	*/
		public var fullYearChangeCount:int = -1;
		public var monthChangeCount:int    = -1;
		public var dateChangeCount:int     = -1;
		public var hoursChangeCount:int    = -1;
		public var minutesChangeCount:int  = -1;
		public var secondsChangeCount:int  = -1;
		
		public var date:Date = null;
		
		public function ClockEvent(
			type:String, bubbles:Boolean = false, cancelable:Boolean = false
		) {
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event {
			var event:ClockEvent = new ClockEvent(this.type, this.bubbles, this.cancelable);
			
			event.fullYearChangeCount = this.fullYearChangeCount;
			event.monthChangeCount    = this.monthChangeCount;
			event.dateChangeCount     = this.dateChangeCount;
			event.hoursChangeCount    = this.hoursChangeCount;
			event.minutesChangeCount  = this.minutesChangeCount;
			event.secondsChangeCount  = this.secondsChangeCount;
			
			event.date = new Date(this.date.time);
			
			return event;
		}
	}
}