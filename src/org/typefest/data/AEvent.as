/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class AEvent extends Event {
		static public const CHANGE:String = Event.CHANGE;
		static public const PREFIX:String = "#";
		
		//---------------------------------------
		// instance
		//---------------------------------------
		protected var _source:IA      = null;
		protected var _change:AChange = null;

		public function get source():IA {
			return _source;
		}
		public function get change():AChange {
			return _change;
		}
		
		//---------------------------------------
		// count
		//---------------------------------------
		protected var _count:int = 0;
		
		public function get count():int {
			return _count;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function AEvent(
			type:String,
			bubbles:Boolean    = false,
			cancelable:Boolean = false,
			source:IA          = null,
			change:AChange     = null
		) {
			super(type, bubbles, cancelable);
			
			_source = source;
			_change = change;
		}
		
		internal function inc():AEvent {
			_count++;
			
			return this;
		}
		
		override public function clone():Event {
			var e:AEvent = new AEvent(
				type,
				bubbles,
				cancelable,
				_source,
				_change
			);
			e._count = _count;
			
			return e;
		}
	}
}