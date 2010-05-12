/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.events {
	import flash.events.Event;
	
	public class SilentErrorEvent extends Event {
		static public const ERROR:String          = "SilentErrorEvent.ERROR";
		static public const IO_ERROR:String       = "SilentErrorEvent.IO_ERROR";
		static public const SECURITY_ERROR:String = "SilentErrorEvent.SECURITY_ERROR";
		
		// remote resource is not valid
		static public const RESOURCE_ERROR:String = "SilentErrorEvent.RESOURCE_ERROR";
		
		//---------------------------------------
		// Instance
		//---------------------------------------
		public var text:String = null;
		
		public function SilentErrorEvent(
			type:String,
			bubbles:Boolean    = false,
			cancelable:Boolean = false,
			text:String        = ""
		) {
			super(type, bubbles, cancelable);
			this.text = text;
		}
		
		override public function clone():Event {
			return new SilentErrorEvent(
				type,
				bubbles,
				cancelable,
				text
			);
		}
	}
}