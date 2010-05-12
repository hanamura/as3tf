/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time {
	import flash.events.Event;
	import org.typefest.core.Arr;
	
	public class AlarmEvent extends Event {
		public static const ALARM:String = "alarm";
		
		public var latestDate:Date = null;
		public var latestValue:*   = null;
		public var dates:Array     = null;
		public var values:Array    = null;
		public var items:Array     = null;
		public var date:Date       = null;
		
		public function AlarmEvent(
			type:String, bubbles:Boolean = false, cancelable:Boolean = false
		) {
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event {
			var event:AlarmEvent = new AlarmEvent(this.type, this.bubbles, this.cancelable);
			
			event.latestDate  = new Date(this.latestDate);
			event.latestValue = this.latestValue;
			event.dates       = Arr.map(function(date:Date):Date {
				return new Date(date.time);
			}, this.dates);
			event.values = this.values.concat();
			event.items  = Arr.map(function(item:*):* {
				return {date:new Date(item.date.time), value:item.value};
			}, this.items);
			event.date = new Date(this.date.time);
			
			return event;
		}
	}
}