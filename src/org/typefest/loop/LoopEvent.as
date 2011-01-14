/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.loop {
	import flash.events.Event;
	
	
	
	
	
	public class LoopEvent extends Event {
		///// type
		static public const END:String = "LoopEvent.END";
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function LoopEvent(
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
			return new LoopEvent(type, bubbles, cancelable);
		}
	}
}