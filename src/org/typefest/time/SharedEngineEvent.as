/*
as3tf
http://code.google.com/p/as3tf/

Licensed under the MIT License

Copyright (c) 2008 Taro Hanamura

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
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