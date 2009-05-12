/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import org.typefest.core.Arr;
	
	public class Clock extends EventDispatcher {
		protected static const _ALL_EVENT_TYPES:Array = [
			ClockEvent.FULL_YEAR,
			ClockEvent.MONTH,
			ClockEvent.DATE,
			ClockEvent.HOURS,
			ClockEvent.MINUTES,
			ClockEvent.SECONDS
		];
		protected static const _CHANGE_COUNT:Dictionary = new Dictionary();
		_CHANGE_COUNT[ClockEvent.FULL_YEAR] = function(later:Date, earlier:Date):int {
			return later.fullYear - earlier.fullYear;
		}
		_CHANGE_COUNT[ClockEvent.MONTH] = function(later:Date, earlier:Date):int {
			return ((later.fullYear - earlier.fullYear) * 12) + (later.month - earlier.month);
		}
		_CHANGE_COUNT[ClockEvent.DATE] = function(later:Date, earlier:Date):int {
			return Math.floor(later.time / 86400000) - Math.floor(earlier.time / 86400000);
		}
		_CHANGE_COUNT[ClockEvent.HOURS] = function(later:Date, earlier:Date):int {
			return Math.floor(later.time / 3600000) - Math.floor(earlier.time / 3600000);
		}
		_CHANGE_COUNT[ClockEvent.MINUTES] = function(later:Date, earlier:Date):int {
			return Math.floor(later.time / 60000) - Math.floor(earlier.time / 60000);
		}
		_CHANGE_COUNT[ClockEvent.SECONDS] = function(later:Date, earlier:Date):int {
			return Math.floor(later.time / 1000) - Math.floor(earlier.time / 1000);
		}
		
		protected static var _clock:Clock = null;
		public static function get clock():Clock {
			if(_clock === null) {
				_clock = new Clock();
			}
			return _clock;
		}
		
		/* ============ */
		/* = Instance = */
		/* ============ */
		protected var _sharedEngine:SharedEngine = null;
		
		protected var _referenceChecker:Timer = null;
		
		protected var _lastDate:Date = null;
		
		public function get sharedEngine():SharedEngine {
			return this._sharedEngine;
		}
		
		public function get date():Date {
			return this._sharedEngine.date;
		}
		
		public function Clock(sharedEngine:SharedEngine = null) {
			if(sharedEngine === null) {
				this._sharedEngine = SharedEngine.sharedEngine;
			} else {
				this._sharedEngine = sharedEngine;
			}
			
			this._referenceChecker = new Timer(2713, 0);
			this._referenceChecker.addEventListener(
				TimerEvent.TIMER, this._referenceCheckerTimer
			);
		}
		
		/* ========= */
		/* = Check = */
		/* ========= */
		protected function _check():void {
			var date:Date         = this._sharedEngine.date;
			var counts:Dictionary = new Dictionary();
			var index:int         = -1;
			var eventType:String;
			var count:int;
			var i:int;
			
			for(i = _ALL_EVENT_TYPES.length - 1; i >= 0; i--) {
				eventType = _ALL_EVENT_TYPES[i];
				
				counts[eventType + "ChangeCount"] =
					count =
						_CHANGE_COUNT[eventType](date, this._lastDate);
				
				if(count > 0) {
					index = i;
				}
			}
			
			this._lastDate = date;
			
			if(index >= 0) {
				var targetTypes:Array = _ALL_EVENT_TYPES.slice(index);
				var event:ClockEvent;
				var changedType:String;
				var key:String;
				
				for(i = 0; i < targetTypes.length; i++) {
					event = new ClockEvent(targetTypes[i]);
					for(key in counts) {
						event[key] = counts[key];
					}
					event.date = new Date(date.time);
					
					this.dispatchEvent(event);
				}
			}
		}
		
		/* ========================= */
		/* = sharedEngine Listener = */
		/* ========================= */
		protected function _sharedEngineEnterFrame(e:Event):void {
			this._check();
		}
		
		protected function _referenceCheckerTimer(e:TimerEvent):void {
			this._sleep();
		}
		
		/* ================ */
		/* = Wake / Sleep = */
		/* ================ */
		protected function _wake():void {
			if(
				!this._referenceChecker.running &&
				Arr.some(this.willTrigger, _ALL_EVENT_TYPES)
			) {
				this._sharedEngine.addEventListener(
					Event.ENTER_FRAME, this._sharedEngineEnterFrame
				);
				this._referenceChecker.reset();
				this._referenceChecker.start();
				
				this._lastDate = this._sharedEngine.date;
			}
		}
		
		protected function _sleep():void {
			if(
				this._referenceChecker.running &&
				!Arr.some(this.willTrigger, _ALL_EVENT_TYPES)
			) {
				this._sharedEngine.removeEventListener(
					Event.ENTER_FRAME, this._sharedEngineEnterFrame
				);
				this._referenceChecker.stop();
				
				this._lastDate = null;
			}
		}
		
		/* =================== */
		/* = EventDispatcher = */
		/* =================== */
		public override function addEventListener(
			t:String, l:Function, uc:Boolean = false, p:int = 0, uw:Boolean = false
		):void {
			super.addEventListener(t, l, uc, p, uw);
			this._wake();
		}
		
		public override function removeEventListener(
			t:String, l:Function, uc:Boolean = false
		):void {
			super.removeEventListener(t, l, uc);
			this._sleep();
		}
	}
}