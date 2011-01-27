/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.transitions.keytween {
	import flash.events.Event;
	
	
	
	
	
	public class KeyTweenEvent extends Event {
		///// types
		static public const START:String  = "KeyTweenEvent.START";
		static public const UPDATE:String = "KeyTweenEvent.UPDATE";
		static public const END:String    = "KeyTweenEvent.END";
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function KeyTweenEvent(
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
			return new KeyTweenEvent(type, bubbles, cancelable);
		}
	}
}