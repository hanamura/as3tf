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
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class SharedEngine extends EventDispatcher {
		/*
		*	// provides a unique time and a unique id per each frame
		*	
		*	*/
		protected static var _engine:IEventDispatcher = null;
		protected static function _getDate():Date {
			return new Date();
		}
		
		protected static var _sharedEngine:SharedEngine = null;
		public static function get sharedEngine():SharedEngine {
			if(_sharedEngine === null) {
				_sharedEngine = new SharedEngine();
			}
			return _sharedEngine;
		}
		
		/* ============ */
		/* = Instance = */
		/* ============ */
		protected var _getDate:Function        = null;
		protected var _engine:IEventDispatcher = null;
		
		protected var _time:Number = NaN;
		
		/*
		*	// this is currently int but it may change
		*	// because it is not strictly identical
		*	*/
		protected var _frameID:* = null;
		
		public function get time():Number {
			return this._time;
		}
		
		public function get date():Date {
			return new Date(this._time);
		}
		
		public function get frameID():* {
			return this._frameID;
		}
		
		/* =============== */
		/* = Constructor = */
		/* =============== */
		public function SharedEngine(
			getDate:Function = null, engine:IEventDispatcher = null
		) {
			super();
			
			if(getDate === null) {
				this._getDate = SharedEngine._getDate;
			} else {
				this._getDate = getDate;
			}
			
			if(engine === null) {
				if(SharedEngine._engine === null) {
					SharedEngine._engine = new Bitmap();
				}
				this._engine = SharedEngine._engine;
			} else {
				this._engine = engine;
			}
			
			this._time    = this._getDate().time;
			this._frameID = int.MIN_VALUE;
			
			this._engine.addEventListener(
				Event.ENTER_FRAME, this._engineEnterFrame, false, 0, true
			);
		}
		
		protected function _engineEnterFrame(e:Event):void {
			this._time = this._getDate().time;
			
			if(this._frameID === int.MAX_VALUE) {
				this._frameID = int.MIN_VALUE;
			} else {
				this._frameID++;
			}
			
			this.dispatchEvent(e);
			this.dispatchEvent(new SharedEngineEvent(
				SharedEngineEvent.ENTER_FRAME, this._time, this._frameID
			));
		}
	}
}