/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.loop {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	
	
	
	
	public class LoopErrorEvent extends ErrorEvent {
		///// types
		static public const ERROR:String = "LoopErrorEvent.ERROR";
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// error
		protected var _error:Error = null;
		
		public function get error():Error { return _error }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function LoopErrorEvent(
			type:String,
			bubbles:Boolean    = false,
			cancelable:Boolean = false,
			text:String        = "",
			error:Error        = null
		) {
			super(type, bubbles, cancelable, text);
			
			_error = error;
		}
		
		
		
		
		
		//---------------------------------------
		// clone
		//---------------------------------------
		override public function clone():Event {
			return new LoopErrorEvent(type, bubbles, cancelable, text, _error);
		}
	}
}