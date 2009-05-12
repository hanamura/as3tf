/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
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