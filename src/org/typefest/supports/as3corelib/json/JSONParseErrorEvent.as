/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.supports.as3corelib.json {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	
	
	
	
	public class JSONParseErrorEvent extends ErrorEvent {
		static public const PARSE_ERROR:String = "JSONParseErrorEvent.PARSE_ERROR";
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		protected var _location:int = 0;
		protected var _json:String  = null;
		
		public function get location():int {
			return _location;
		}
		public function get json():String {
			return _json;
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function JSONParseErrorEvent(
			type:String,
			bubbles:Boolean    = false,
			cancelable:Boolean = false,
			message:String     = "",
			location:int       = 0,
			json:String        = ""
		) {
			super(type, bubbles, cancelable, message);
			
			_location = location;
			_json     = json;
		}
		
		
		
		
		
		//---------------------------------------
		// event
		//---------------------------------------
		override public function clone():Event {
			return new JSONParseErrorEvent(
				type, bubbles, cancelable, text, _location, _json
			);
		}
	}
}