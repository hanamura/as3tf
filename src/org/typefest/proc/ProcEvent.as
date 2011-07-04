/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.proc {
	import flash.events.Event;
	
	
	
	
	
	public class ProcEvent extends Event {
		///// types
		static public const START:String = "ProcEvent.START";
		static public const END:String   = "ProcEvent.END";
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function ProcEvent(
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
			return new ProcEvent(type, bubbles, cancelable);
		}
	}
}