/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.proc.page {
	import flash.events.Event;
	
	import org.typefest.proc.ProcEvent;
	
	
	
	
	
	public class PageEvent extends ProcEvent {
		///// types
		static public const INIT:String       = "PageEvent.INIT";
		static public const WILL_CLOSE:String = "PageEvent.WILL_CLOSE";
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// query
		protected var _query:Query = null;
		
		public function get query():Query { return _query && _query.clone() }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function PageEvent(
			type:String,
			bubbles:Boolean    = false,
			cancelable:Boolean = false,
			query:Query        = null
		) {
			super(type, bubbles, cancelable);
			
			_query = query && query.clone();
		}
		
		
		
		
		
		//---------------------------------------
		// clone
		//---------------------------------------
		override public function clone():Event {
			return new PageEvent(type, bubbles, cancelable, _query);
		}
	}
}