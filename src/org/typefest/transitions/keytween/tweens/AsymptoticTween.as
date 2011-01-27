/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.transitions.keytween.tweens {
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.typefest.transitions.keytween.KeyTween;
	import org.typefest.transitions.keytween.KeyTweenEvent;
	
	
	
	
	
	public class AsymptoticTween extends KeyTween {
		///// common engine
		static protected var _commonEngine:EventDispatcher = null;
		static protected function get commonEngine():EventDispatcher {
			return _commonEngine ||= new Bitmap();
		}
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// engine
		protected var _engine:EventDispatcher = null;
		
		///// properties
		protected var _rate:Number = 0.1;
		protected var _drop:Number = 0.001;
		
		public function get rate():Number { return _rate }
		public function set rate(_:Number):void { _rate = _ }
		public function get drop():Number { return _drop }
		public function set drop(_:Number):void { _drop = _ }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function AsymptoticTween(
			target:*, key:*, rate:Number = 0.1, drop:Number = 0.001, filter:Function = null
		) {
			_rate = rate;
			_drop = drop;
			
			super(target, key, filter);
		}
		
		
		
		
		
		//---------------------------------------
		// check
		//---------------------------------------
		override protected function _check():void {
			if (_value !== _dest && !_engine) {
				_engine = commonEngine;
				_engine.addEventListener(Event.ENTER_FRAME, _loop, false, 0, true);
				dispatchEvent(new KeyTweenEvent(KeyTweenEvent.START));
			} else if (_value === _dest && _engine) {
				_engine.removeEventListener(Event.ENTER_FRAME, _loop, false);
				_engine = null;
				_update();
				dispatchEvent(new KeyTweenEvent(KeyTweenEvent.END));
			}
		}
		///// update
		protected function _update():void {
			var gap:Number = _dest - _value;
			var value:Number;
			
			if (Math.abs(gap) <= _drop) {
				value = _dest;
			} else {
				value = _value + gap * _rate;
			}
			
			if (_value !== value) {
				_value        = value;
				_target[_key] = _filter is Function ? _filter(_value) : _value;
				dispatchEvent(new KeyTweenEvent(KeyTweenEvent.UPDATE));
			}
		}
		///// loop
		protected function _loop(e:Event):void {
			_update();
			_check();
		}
	}
}