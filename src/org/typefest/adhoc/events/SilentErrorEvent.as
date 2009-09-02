/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.adhoc.events {
	import flash.events.Event;
	
	public class SilentErrorEvent extends Event {
		static public const ERROR:String          = "error";
		static public const IO_ERROR:String       = "ioError";
		static public const SECURITY_ERROR:String = "securityError";
		
		// remote resource is not valid
		static public const RESOURCE_ERROR:String = "resourceError";
		
		//---------------------------------------
		// Instance
		//---------------------------------------
		public var text:String = null;
		
		public function SilentErrorEvent(
			type:String,
			bubbles:Boolean = false,
			cancelable:Boolean = false,
			text:String = ""
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