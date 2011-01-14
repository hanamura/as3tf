/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time.tick {
	import flash.events.Event;
	
	
	
	
	
	public class TickEvent extends Event {
		///// type
		static public const TICK:String = "TickEvent.TICK";
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// props
		protected var _items:Array     = null;
		protected var _date:Date       = null;
		protected var _position:Number = 0;
		
		public function get items():Array { return _items.concat() }
		public function get date():Date { return new Date(_date.time) }
		public function get position():Number { return _position }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function TickEvent(
			type:String,
			bubbles:Boolean    = false,
			cancelable:Boolean = false,
			items:Array        = null, // not nullable
			date:Date          = null,
			position:Number    = NaN
		) {
			super(type, bubbles, cancelable);
			
			_items    = items.concat();
			_date     = new Date(date.time);
			_position = position;
		}
		
		
		
		
		
		//---------------------------------------
		// override
		//---------------------------------------
		override public function clone():Event {
			return new TickEvent(type, bubbles, cancelable, _items, _date, _position);
		}
	}
}