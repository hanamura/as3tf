/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time {
	import flash.events.Event;
	import org.typefest.core.Arr;
	
	public class TickEvent extends Event {
		public static const TICK:String = "tick";
		
		public var latestPoint:Number = 0;
		public var latestValue:*      = null;
		public var points:Array       = null;
		public var values:Array       = null;
		public var items:Array        = null;
		public var date:Date          = null;
		
		public function TickEvent(
			type:String, bubbles:Boolean = false, cancelable:Boolean = false
		) {
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event {
			var event:TickEvent = new TickEvent(this.type, this.bubbles, this.cancelable);
			event.latestPoint = this.latestPoint;
			event.latestValue = this.latestValue;
			event.points      = this.points.concat();
			event.values      = this.values.concat();
			event.items       = Arr.map(function(item:Object):Object {
				return {point:item.point, value:item.value};
			}, this.items);
			event.date        = new Date(this.date.time);
			
			return event;
		}
	}
}