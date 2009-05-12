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