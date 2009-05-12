/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import org.typefest.core.Arr;
	import org.typefest.core.Sort;
	
	public class Alarm extends EventDispatcher {
		protected var _sharedEngine:SharedEngine = null;
		
		protected var _dict:Dictionary = null;
		protected var _pasts:Array     = null;
		protected var _futures:Array   = null;
		
		protected var _latestDate:Date = null;
		protected var _latestValue:*   = null;
		
		public function get sharedEngine():SharedEngine {
			return this._sharedEngine;
		}
		
		public function get date():Date {
			return this._sharedEngine.date;
		}
		
		public function get latestDate():Date {
			if(this._pasts.length > 0) {
				return new Date(this._pasts[0]);
			} else {
				return null;
			}
		}
		
		public function get latestValue():* {
			if(this._pasts.length > 0) {
				return this._dict[this._pasts[0]];
			} else {
				return null;
			}
		}
		
		public function get pasts():Array {
			return Arr.map(function(time:Number):Date {
				return new Date(time);
			}, this._pasts);
		}
		
		public function get futures():Array {
			return Arr.map(function(time:Number):Date {
				return new Date(time);
			}, this._futures);
		}
		
		/* =============== */
		/* = Constructor = */
		/* =============== */
		public function Alarm(sharedEngine:SharedEngine = null) {
			if(sharedEngine === null) {
				this._sharedEngine = SharedEngine.sharedEngine;
			} else {
				this._sharedEngine = sharedEngine;
			}
			
			this._dict    = new Dictionary();
			this._pasts   = [];
			this._futures = [];
		}
		
		/* ========= */
		/* = Check = */
		/* ========= */
		protected function _check():void {
			var time:Number = this._sharedEngine.time;
			
			var index:int = -1;
			for(var i:int = 0; i < this._futures.length; i++) {
				if(this._futures[i] <= time) {
					index = i;
					break;
				}
			}
			
			if(index >= 0) {
				var alarms:Array = this._futures.splice(index);
				this._pasts.unshift.apply(null, alarms);
				
				var event:AlarmEvent = new AlarmEvent(AlarmEvent.ALARM);
				event.latestDate  = new Date(alarms[0]);
				event.latestValue = this._dict[alarms[0]];
				
				alarms.reverse();
				
				var dates:Array  = [];
				var values:Array = [];
				var items:Array  = [];
				
				Arr.each(function(t:Number):void {
					dates.push(new Date(t));
					values.push(_dict[t]);
					items.push({date:new Date(t), value:_dict[t]});
				}, alarms);
				
				event.dates  = dates;
				event.values = values;
				event.items  = items;
				
				event.date = new Date(time);
				
				if(this._futures.length === 0) {
					this._sleep();
				}
				
				this.dispatchEvent(event);
			}
		}
		
		/* ========================= */
		/* = sharedEngine listener = */
		/* ========================= */
		protected function _sharedEngineEnterFrame(e:Event):void {
			this._check();
		}
		
		/* ================ */
		/* = Wake / Sleep = */
		/* ================ */
		protected function _wake():void {
			this._sharedEngine.addEventListener(
				Event.ENTER_FRAME, this._sharedEngineEnterFrame
			);
		}
		
		protected function _sleep():void {
			this._sharedEngine.removeEventListener(
				Event.ENTER_FRAME, this._sharedEngineEnterFrame
			);
		}
		
		/* ============= */
		/* = Set / Get = */
		/* ============= */
		public function set(date:Date, value:* = null):void {
			var time:Number = date.time;
			
			if(this._dict[time] === undefined) {
				var list:Array =
					(time <= this._sharedEngine.time) ? this._pasts : this._futures;
				var index = Sort.lookup(list, time, Sort.larger);
				
				list.splice(index, 0, time);
				
				if(list === this._futures && this._futures.length === 1) {
					this._wake();
				}
			}
			
			this._dict[time] = value;
		}
		
		public function get(date:Date):* {
			var time:Number = date.time;
			
			if(this._dict[time] !== undefined) {
				return this._dict[time];
			} else {
				return null;
			}
		}
		
		public function remove(date:Date):Boolean {
			var time:Number = date.time;
			
			if(this._dict[time] !== undefined) {
				
				var index:int = this._pasts.indexOf(time);
				if(index >= 0) {
					this._pasts.splice(index, 1);
				} else {
					index = this._futures.indexOf(time);
					this._futures.splice(index, 1);
					
					if(this._futures.length === 0) {
						this._sleep();
					}
				}
				
				return delete this._dict[time];
			} else {
				return false;
			}
		}
		
		public function has(date:Date):Boolean {
			return this._dict[date.time] !== undefined;
		}
		
		public function past(date:Date):Boolean {
			var time:Number = date.time;
			
			if(this._dict[time] !== undefined) {
				return time <= this._sharedEngine.time;
			} else {
				return false;
			}
		}
		
		public function future(date:Date):Boolean {
			var time:Number = date.time;
			
			if(this._dict[time] !== undefined) {
				return time > this._sharedEngine.time;
			} else {
				return false;
			}
		}
		
		public function clear():void {
			this._dict  = new Dictionary();
			this._pasts = [];
			
			if(this._futures.length > 0) {
				this._sleep();
			}
			this._futures = [];
		}
	}
}