/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.events {
	import flash.events.Event;
	
	public class AltEvent extends Event {
		static public const UPDATE:String     = "AltEvent.UPDATE";
		
		static public const START:String      = "AltEvent.START";
		static public const END:String        = "AltEvent.END";
		
		static public const PLAY:String       = "AltEvent.PLAY";
		static public const PAUSE:String      = "AltEvent.PAUSE";
		static public const RESUME:String     = "AltEvent.RESUME";
		static public const STOP:String       = "AltEvent.STOP";
		static public const REWIND:String     = "AltEvent.REWIND";
		
		static public const INTERRUPT:String  = "AltEvent.INTERRUPT";
		
		static public const STEP:String       = "AltEvent.STEP";
		static public const TICK:String       = "AltEvent.TICK";
		static public const LOOP:String       = "AltEvent.LOOP";
		static public const REPEAT:String     = "AltEvent.REPEAT";
		static public const REPOSITION:String = "AltEvent.REPOSITION";
		static public const REARRANGE:String  = "AltEvent.REARRANGE";
		static public const RESCALE:String    = "AltEvent.RESCALE";
		
		static public const SUCCESS:String    = "AltEvent.SUCCESS";
		static public const FAIL:String       = "AltEvent.FAIL";
		
		//---------------------------------------
		// instance
		//---------------------------------------
		protected var _data:* = null;
		
		public function get data():* {
			return _data;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function AltEvent(
			type:String,
			bubbles:Boolean    = false,
			cancelable:Boolean = false,
			data:*             = null
		) {
			super(type, bubbles, cancelable);
			
			_data = data;
		}
		
		override public function clone():Event {
			return new AltEvent(type, bubbles, cancelable, data);
		}
	}
}