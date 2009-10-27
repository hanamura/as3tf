package org.typefest.layout.tables {
	import flash.events.Event;
	
	public class TableEvent extends Event {
		static public const MEMBER_CHANGE:String = "TableEvent.MEMBER_CHANGE";
		
		public function TableEvent(
			type:String,
			bubbles:Boolean    = false,
			cancelable:Boolean = false
		) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new TableEvent(type, bubbles, cancelable);
		}
	}
}