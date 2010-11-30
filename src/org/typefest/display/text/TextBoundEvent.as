/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.text {
	import flash.events.Event;
	
	
	
	
	
	public class TextBoundEvent extends Event {
		///// types
		static public const RESIZE_COMPOSITION:String = "TextBoundEvent.RESIZE_COMPOSITION";
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function TextBoundEvent(
			type:String,
			bubbles:Boolean    = false,
			cancelable:Boolean = false
		) {
			super(type, bubbles, cancelable);
		}
		
		
		
		
		
		//---------------------------------------
		// clone
		//---------------------------------------
		override public function clone():Event {
			return new TextBoundEvent(type, bubbles, cancelable);
		}
	}
}