/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

/*
using BetweenAS3:
http://www.libspark.org/wiki/BetweenAS3/en
*/

package org.typefest.transitions.keytween.tweens {
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.core.easing.IEasing;
	import org.libspark.betweenas3.easing.Linear;
	import org.libspark.betweenas3.tweens.IObjectTween;
	import org.libspark.betweenas3.tweens.ITween;
	
	import org.typefest.transitions.keytween.KeyTween;
	import org.typefest.transitions.keytween.KeyTweenEvent;
	
	
	
	
	
	public class BetweenAS3Tween extends KeyTween {
		///// tween
		protected var _tween:IObjectTween = null;
		
		///// properties
		protected var _time:Number    = 1;
		protected var _easing:IEasing = Linear.easeNone;
		
		public function get time():Number { return _time }
		public function set time(_:Number):void { _time = _ }
		public function get easing():IEasing { return _easing }
		public function set easing(_:IEasing):void { _easing = _ }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function BetweenAS3Tween(
			target:*,
			key:*,
			time:Number     = 1,
			easing:IEasing  = null,
			filter:Function = null
		) {
			_time   = time;
			_easing = easing || Linear.easeNone;
			
			super(target, key, filter);
		}
		
		
		
		
		
		//---------------------------------------
		// check
		//---------------------------------------
		override protected function _check():void {
			if (_value === _dest) {
				if (_tween) {
					_tween.stop();
					_tween = null;
					dispatchEvent(new KeyTweenEvent(KeyTweenEvent.END));
				}
			} else {
				var _:ITween = _tween;
				
				_tween = BetweenAS3.to({_:_value}, {_:_dest}, _time, _easing);
				_tween.onUpdate   = _tweenUpdate;
				_tween.onComplete = _tweenComplete;
				_tween.play();
				
				if (_) {
					_.stop();
				} else {
					dispatchEvent(new KeyTweenEvent(KeyTweenEvent.START));
				}
			}
		}
		///// tween update
		protected function _tweenUpdate():void {
			_value        = _tween.target["_"];
			_target[_key] = _filter is Function ? _filter(_value) : _value;
			dispatchEvent(new KeyTweenEvent(KeyTweenEvent.UPDATE));
		}
		///// tween complete
		protected function _tweenComplete():void {
			_tween = null;
			dispatchEvent(new KeyTweenEvent(KeyTweenEvent.END));
		}
	}
}