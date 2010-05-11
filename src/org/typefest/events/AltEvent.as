/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.events {
	import flash.events.Event;
	
	public class AltEvent extends Event {
		///// Event class alternates
		static public const ACTIVATE:String            = "AltEvent.ACTIVATE";
		static public const ADDED:String               = "AltEvent.ADDED";
		static public const ADDED_TO_STAGE:String      = "AltEvent.ADDED_TO_STAGE";
		static public const CANCEL:String              = "AltEvent.CANCEL";
		static public const CHANGE:String              = "AltEvent.CHANGE";
		static public const CLEAR:String               = "AltEvent.CLEAR";
		static public const CLOSE:String               = "AltEvent.CLOSE";
		static public const CLOSING:String             = "AltEvent.CLOSING";
		static public const COMPLETE:String            = "AltEvent.COMPLETE";
		static public const CONNECT:String             = "AltEvent.CONNECT";
		static public const COPY:String                = "AltEvent.COPY";
		static public const CUT:String                 = "AltEvent.CUT";
		static public const DEACTIVATE:String          = "AltEvent.DEACTIVATE";
		static public const DISPLAYING:String          = "AltEvent.DISPLAYING";
		static public const ENTER_FRAME:String         = "AltEvent.ENTER_FRAME";
		static public const EXIT_FRAME:String          = "AltEvent.EXIT_FRAME";
		static public const EXITING:String             = "AltEvent.EXITING";
		static public const FRAME_CONSTRUCTED:String   = "AltEvent.FRAME_CONSTRUCTED";
		static public const FULLSCREEN:String          = "AltEvent.FULLSCREEN";
		static public const HTML_BOUNDS_CHANGE:String  = "AltEvent.HTML_BOUNDS_CHANGE";
		static public const HTML_DOM_INITIALIZE:String = "AltEvent.HTML_DOM_INITIALIZE";
		static public const HTML_RENDER:String         = "AltEvent.HTML_RENDER";
		static public const ID3:String                 = "AltEvent.ID3";
		static public const INIT:String                = "AltEvent.INIT";
		static public const LOCATION_CHANGE:String     = "AltEvent.LOCATION_CHANGE";
		static public const MOUSE_LEAVE:String         = "AltEvent.MOUSE_LEAVE";
		static public const NETWORK_CHANGE:String      = "AltEvent.NETWORK_CHANGE";
		static public const OPEN:String                = "AltEvent.OPEN";
		static public const PASTE:String               = "AltEvent.PASTE";
		static public const REMOVED:String             = "AltEvent.REMOVED";
		static public const REMOVED_FROM_STAGE:String  = "AltEvent.REMOVED_FROM_STAGE";
		static public const RENDER:String              = "AltEvent.RENDER";
		static public const RESIZE:String              = "AltEvent.RESIZE";
		static public const SCROLL:String              = "AltEvent.SCROLL";
		static public const SELECT:String              = "AltEvent.SELECT";
		static public const SELECT_ALL:String          = "AltEvent.SELECT_ALL";
		static public const SOUND_COMPLETE:String      = "AltEvent.SOUND_COMPLETE";
		static public const TAB_CHILDREN_CHANGE:String = "AltEvent.TAB_CHILDREN_CHANGE";
		static public const TAB_ENABLED_CHANGE:String  = "AltEvent.TAB_ENABLED_CHANGE";
		static public const TAB_INDEX_CHANGE:String    = "AltEvent.TAB_INDEX_CHANGE";
		static public const UNLOAD:String              = "AltEvent.UNLOAD";
		static public const USER_IDLE:String           = "AltEvent.USER_IDLE";
		static public const USER_PRESENT:String        = "AltEvent.USER_PRESENT";
		
		///// AltEvent original types
		static public const UPDATE:String     = "AltEvent.UPDATE";
		
		static public const START:String      = "AltEvent.START";
		static public const END:String        = "AltEvent.END";
		
		static public const PLAY:String       = "AltEvent.PLAY";
		static public const PAUSE:String      = "AltEvent.PAUSE";
		static public const RESUME:String     = "AltEvent.RESUME";
		static public const STOP:String       = "AltEvent.STOP";
		static public const REWIND:String     = "AltEvent.REWIND";
		static public const REPLAY:String     = "AltEvent.REPLAY";
		
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
		
		static public const ENTER:String      = "AltEvent.ENTER";
		static public const EXIT:String       = "AltEvent.EXIT";
		
		static public const FOCUS:String      = "AltEvent.FOCUS";
		static public const UNFOCUS:String    = "AltEvent.UNFOCUS";
		
		static public const BACKWARD:String   = "AltEvent.BACKWARD";
		static public const FORWARD:String    = "AltEvent.FORWARD";
		
		static public const IN:String         = "AltEvent.IN";
		static public const OUT:String        = "AltEvent.OUT";
		
		static public const INPUT:String      = "AltEvent.INPUT";
		static public const OUTPUT:String     = "AltEvent.OUTPUT";
		
		static public const PREVIEW:String    = "AltEvent.PREVIEW";
		
		static public const NEXT:String = "AltEvent.NEXT";
		static public const PREV:String = "AltEvent.PREV";
		
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