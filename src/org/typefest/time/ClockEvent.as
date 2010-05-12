/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
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