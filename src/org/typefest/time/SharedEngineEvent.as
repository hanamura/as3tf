/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time {
	import flash.events.Event;
	
	public class SharedEngineEvent extends Event {
		public static const ENTER_FRAME:String = "sharedEngineEnterFrame";
		
		protected var _time:Number = NaN;
		protected var _frameID:*   = null;
		
		public function get time():Number {
			return this._time;
		}
		
		public function get date():Date {
			return new Date(this._time);
		}
		
		public function get frameID():* {
			return this._frameID;
		}
		
		public function SharedEngineEvent(
			type:String, time:Number, frameID:*,
			bubbles:Boolean = false, cancelable:Boolean = false
		) {
			super(type, bubbles, cancelable);
			
			this._time    = time;
			this._frameID = frameID;
		}
		
		public override function clone():Event {
			return new SharedEngineEvent(
				this.type, this._time, this._frameID,
				this.bubbles, this.cancelable
			);
		}
	}
}