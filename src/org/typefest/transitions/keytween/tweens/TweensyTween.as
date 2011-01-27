/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

/*
using Tweensy:
http://code.google.com/p/tweensy/
*/

package org.typefest.transitions.keytween.tweens {
	import fl.motion.easing.Linear;
	
	import com.flashdynamix.motion.Tweensy;
	import com.flashdynamix.motion.TweensyTimeline;
	
	import org.typefest.transitions.keytween.KeyTween;
	import org.typefest.transitions.keytween.KeyTweenEvent;
	
	
	
	
	
	public class TweensyTween extends KeyTween {
		///// tween
		protected var _tween:TweensyTimeline = null;
		
		///// properties
		protected var _time:Number     = 1;
		protected var _easing:Function = Linear.easeNone;
		
		public function get time():Number { return _time }
		public function set time(_:Number):void { _time = _ }
		public function get easing():Function { return _easing }
		public function set easing(_:Function):void { _easing = _ }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function TweensyTween(
			target:*,
			key:*,
			time:Number     = 1,
			easing:Function = null,
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
					_tween.dispose();
					_tween = null;
					dispatchEvent(new KeyTweenEvent(KeyTweenEvent.END));
				}
			} else {
				var _:TweensyTimeline = _tween;
				
				var proxy:* = {_:_value};
				
				_tween = Tweensy.to(proxy, {_:_dest}, _time, _easing);
				_tween.onUpdate       = _tweenUpdate;
				_tween.onUpdateParams = [proxy];
				_tween.onComplete     = _tweenComplete;
				
				if (_) {
					_.dispose();
				} else {
					dispatchEvent(new KeyTweenEvent(KeyTweenEvent.START));
				}
			}
		}
		///// tween update
		protected function _tweenUpdate(proxy:*):void {
			_value        = proxy["_"];
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