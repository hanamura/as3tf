/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.proc {
	import flash.events.Event;
	
	public class ProcEvent extends Event {
		static public const START:String  = "org.typefest.proc.ProcEvent::start";
		static public const END:String    = "org.typefest.proc.ProcEvent::end";
		
		public function ProcEvent(
			type:String,
			bubbles:Boolean = false,
			cancelable:Boolean = false
		) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new ProcEvent(
				type,
				bubbles,
				cancelable
			);
		}
	}
}