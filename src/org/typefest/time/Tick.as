/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	import flash.utils.Timer;
	import org.typefest.core.Sort;
	
	public class Tick extends Proxy implements IEventDispatcher {
		/*
		*	// usage
		*	
		*	var tick:Tick = new Tick(10);
		*	
		*	tick.set(0,   "zero");
		*	tick.set(1,   "one");
		*	tick.set(2,   "two");
		*	tick.set(3.6, "three point six");
		*	tick.set(6,   "six");
		*	
		*	var listener:Function = function(e:TickEvent):void {
		*		trace("latestPoint:", e.latestPoint);
		*		trace("latestValue:", e.latestValue);
		*	}
		*	
		*	tick.addEventListener(TickEvent.TICK, listener);
		*	
		*	*/
		
		protected static function _makePoint(name:*):Number {
			var point:Number = parseFloat((name is QName) ? name.localName : name);
			return isNaN(point) ? 0 : point;
		}
		protected static function _lowerIndex(arr:Array, num:Number):int {
			for(var i:int = 0; i < arr.length; i++) {
				if(arr[i] <= num) {
					break;
				}
			}
			return i;
		}
		
		/* ============ */
		/* = Instance = */
		/* ============ */
		protected var _sharedEngine:SharedEngine = null;
		
		protected var _ed:EventDispatcher = null;
		
		protected var _referenceChecker:Timer = null;
		
		protected var _interval:Number = 0;
		protected var _baseTime:Number = 0;
		
		protected var _currentBaseTime:Number = 0;
		
		protected var _items:Dictionary = null;
		protected var _points:Array     = null;
		protected var _restPoints:Array = null;
		
		protected var _latestPoint:Number = NaN;
		protected var _latestValue:*      = null;
		
		public function get sharedEngine():SharedEngine {
			return this._sharedEngine;
		}
		
		public function get interval():Number {
			return this._interval;
		}
		
		public function get baseDate():Date {
			return new Date(this._baseTime);
		}
		
		public function get date():Date {
			return this._sharedEngine.date;
		}
		
		public function get latestPoint():Number {
			if(this._points.length === 0) {
				return NaN;
			} else {
				if(isNaN(this._latestPoint)) {
					var index:int;
					
					this._pass(function(
						time:Number, baseTime:Number, duration:Number, approach:int
					):void {
						index = _lowerIndex(_points, duration);
						
						_currentBaseTime = baseTime;
					});
					
					return this._points[index % this._points.length];
				} else {
					return this._latestPoint;
				}
			}
		}
		
		public function get latestValue():* {
			if(this._points.length === 0) {
				return null;
			} else {
				if(isNaN(this._latestPoint)) {
					return this._items[this.latestPoint];
				} else {
					return this._latestValue;
				}
			}
		}
		
		/* =============== */
		/* = Constructor = */
		/* =============== */
		public function Tick(
			interval:Number, baseDate:Date = null,
			sharedEngine:SharedEngine = null
		) {
			this._ed = new EventDispatcher(this);
			
			this._referenceChecker = new Timer(2713, 0);
			this._referenceChecker.addEventListener(
				TimerEvent.TIMER, this._referenceCheckerTimer
			);
			
			this._interval = interval;
			
			if(baseDate === null) {
				baseDate = new Date();
				baseDate.milliseconds = 0;
			}
			this._baseTime = this._currentBaseTime = baseDate.time;
			
			if(sharedEngine === null) {
				this._sharedEngine = SharedEngine.sharedEngine;
			} else {
				this._sharedEngine = sharedEngine;
			}
			
			this._items  = new Dictionary();
			this._points = [];
		}
		
		/* ==================== */
		/* = Common Operation = */
		/* ==================== */
		/*
		*	this method never change object properties
		*	*/
		protected function _pass(cont:Function):void {
			var time:Number         = this._sharedEngine.time;
			var intervalTime:Number = this._interval * 1000;
			
			var approach:int = Math.floor(
				(time - this._currentBaseTime) / intervalTime
			);
			
			var baseTime:Number = this._currentBaseTime + (intervalTime * approach);
			
			var duration:Number = (time - baseTime) / 1000;
			
			cont(time, baseTime, duration, approach);
		}
		
		/* ========= */
		/* = Check = */
		/* ========= */
		protected function _check():void {
			var restPoints:Array = this._restPoints.concat();
			var index:int;
			var t:Number;
			
			this._pass(function(
				time:Number, baseTime:Number, duration:Number, approach:int
			):void {
				index = _lowerIndex(_points, duration);
				t     = time;
				
				_currentBaseTime = baseTime;
				
				if(approach > 0) {
					for(var i:int = 0; i < approach; i++) {
						restPoints.unshift.apply(null, _points);
					}
					_restPoints = restPoints;
				}
			});
			
			// when it ticks
			if(index < this._restPoints.length) {
				var tickPoints:Array = this._restPoints.splice(index);
				
				// makes event
				var event:TickEvent = new TickEvent(TickEvent.TICK);
				
				event.latestPoint =
					this._latestPoint =
						this._points[index % this._points.length];
				event.latestValue =
					this._latestValue =
						this._items[this._latestPoint];
				
				var points:Array = [this._latestPoint];
				var values:Array = [this._latestValue];
				var items:Array  = [{
					point:this._latestValue,
					value:this._latestValue
				}];
				
				var point:Number;
				var value:*;
				for(var i:int = tickPoints.length - 1; i >= 1; i--) {
					point = tickPoints[i];
					value = this._items[point];
					points.push(point);
					values.push(value);
					items.push({point:point, value:value});
				}
				
				event.points = points;
				event.values = values;
				event.items  = items;
				
				event.date = new Date(t);
				
				this.dispatchEvent(event);
			}
		}
		
		/* ========================= */
		/* = sharedEngine Listener = */
		/* ========================= */
		protected function _sharedEngineEnterFrame(e:Event):void {
			this._check();
		}
		
		/* ============================= */
		/* = referenceChecker Listener = */
		/* ============================= */
		protected function _referenceCheckerTimer(e:TimerEvent):void {
			this._sleep();
		}
		
		/* ================ */
		/* = Wake / Sleep = */
		/* ================ */
		protected function _wake():void {
			if(
				this._ed.willTrigger(TickEvent.TICK) &&
				this._points.length > 0 &&
				!this._referenceChecker.running
			) {
				this._pass(function(
					time:Number, baseTime:Number, duration:Number, approach:int
				):void {
					var index:int = _lowerIndex(_points, duration);
					
					_currentBaseTime = baseTime;
					
					_restPoints  = _points.slice(0, index);
					_latestPoint = _points[index % _points.length];
					_latestValue = _items[_latestPoint];
				});
				
				// engine control
				this._sharedEngine.addEventListener(
					Event.ENTER_FRAME, this._sharedEngineEnterFrame
				);
				this._referenceChecker.reset();
				this._referenceChecker.start();
			}
		}
		
		protected function _sleep():void {
			if(
				(!this._ed.willTrigger(TickEvent.TICK) || this._points.length === 0) &&
				this._referenceChecker.running
			) {
				this._restPoints  = null;
				this._latestPoint = NaN;
				this._latestValue = null;
				
				// engine control
				this._sharedEngine.removeEventListener(
					Event.ENTER_FRAME, this._sharedEngineEnterFrame
				);
				this._referenceChecker.stop();
			}
		}
		
		/* ============= */
		/* = Set / Get = */
		/* ============= */
		public function set(point:Number, value:* = null):void {
			if(point < 0 || point > this._interval) {
				throw new ArgumentError("Tick: point must be in the range of 0 to interval");
			}
			if(point === this._interval) {
				point = 0;
			}
			
			if(this._items[point] === undefined) {
				var index:int = Sort.lookup(this._points, point, Sort.larger);
				this._points.splice(index, 0, point);
				
				this._pass(function(
					time:Number, baseTime:Number, duration:Number, approach:int
				):void {
					if(point > duration) {
						if(_restPoints !== null) {
							var restPointIndex:int =
								Sort.lookup(_restPoints, point, Sort.larger);
							_restPoints.splice(restPointIndex, 0, point);
						}
					}
				});
				
				this._latestPoint = NaN;
				this._latestValue = null;
			}
			this._items[point] = value;
			this._wake();
		}
		
		public function get(point:Number):* {
			if(point === this._interval) {
				point = 0;
			}
			
			if(this._items[point] !== undefined) {
				return this._items[point];
			} else {
				return null;
			}
		}
		
		public function remove(point:Number):Boolean {
			if(point === this._interval) {
				point = 0;
			}
			
			if(this._items[point] !== undefined) {
				var index:int = this._points.indexOf(point);
				this._points.splice(index, 1);
				
				index = this._restPoints.indexOf(point);
				if(index >= 0) {
					this._restPoints.splice(index, 1);
				}
				
				var r:Boolean = delete this._items[point];
				
				this._sleep();
				
				return r;
			} else {
				return false;
			}
		}
		
		public function has(point:Number):Boolean {
			if(point === this._interval) {
				point = 0;
			}
			
			return this._items[point] !== undefined;
		}
		
		public function clear():void {
			this._items  = new Dictionary();
			this._points = [];
			
			this._sleep();
		}
		
		/* ==================== */
		/* = IEventDispatcher = */
		/* ==================== */
		public function addEventListener(
			t:String, l:Function, uc:Boolean = false, p:int = 0, uw:Boolean = false
		):void {
			this._ed.addEventListener(t, l, uc, p, uw);
			this._wake();
		}
		
		public function removeEventListener(t:String, l:Function, uc:Boolean = false):void {
			this._ed.removeEventListener(t, l, uc);
			this._sleep();
		}
		
		public function dispatchEvent(e:Event):Boolean {
			return this._ed.dispatchEvent(e);
		}
		
		public function hasEventListener(t:String):Boolean {
			return this._ed.hasEventListener(t);
		}
		
		public function willTrigger(t:String):Boolean {
			return this._ed.willTrigger(t);
		}
		
		/* ========= */
		/* = Proxy = */
		/* ========= */
		flash_proxy override function setProperty(name:*, value:*):void {
			this.set(_makePoint(name), value);
		}
		
		flash_proxy override function getProperty(name:*):* {
			return this.get(_makePoint(name));
		}
		
		flash_proxy override function hasProperty(name:*):Boolean {
			return this.has(_makePoint(name));
		}
		
		flash_proxy override function deleteProperty(name:*):Boolean {
			return this.remove(_makePoint(name));
		}
		
		flash_proxy override function nextName(index:int):String {
			return this._points[this._points.length - index];
		}
		
		flash_proxy override function nextNameIndex(index:int):int {
			return (index < this._points.length) ? (index + 1) : 0;
		}
		
		flash_proxy override function nextValue(index:int):* {
			return this._items[this._points[this._points.length - index]];
		}
	}
}