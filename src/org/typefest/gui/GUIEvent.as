/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.gui {
	import flash.events.Event;
	
	
	
	
	
	public class GUIEvent extends Event {
		///// types
		static public const SELECT:String = "GUIEvent.SELECT";
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		protected var _data:* = null;
		
		public function get data():* { return _data }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function GUIEvent(
			type:String,
			bubbles:Boolean    = false,
			cancelable:Boolean = false,
			data:*             = null
		) {
			super(type, bubbles, cancelable);
			
			_data = data;
		}
		
		
		
		
		
		//---------------------------------------
		// clone
		//---------------------------------------
		override public function clone():Event {
			return new GUIEvent(type, bubbles, cancelable, _data);
		}
	}
}