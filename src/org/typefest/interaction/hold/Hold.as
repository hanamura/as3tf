/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.hold {
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.typefest.interaction.Interaction;
	
	
	
	
	
	public class Hold extends Interaction {
		///// duration
		protected var _duration:Number = 0;
		
		public function get duration():Number { return _duration }
		
		///// stage
		protected var _stage:Stage = null;
		
		///// timer
		protected var _timer:Timer = null;
		
		///// dispose function
		protected var _disposeFunc:Function = null;
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Hold(
			target:InteractiveObject,
			dispatcher:IEventDispatcher = null,
			duration:Number             = 1.0
		) {
			super(target, dispatcher);
			
			_duration = duration;
			
			
			
			///// listen
			_target.addEventListener(MouseEvent.MOUSE_DOWN, _down, false, 0, true);
			
			///// dispose function
			_disposeFunc = function():void {
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, _down, false);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// down
		//---------------------------------------
		protected function _down(e:MouseEvent):void {
			///// drop
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, _down, false);
			
			///// set
			_stage = _target.stage;
			
			///// timer
			_timer = new Timer(_duration * 1000, 1);
			_timer.start();
			
			///// listen
			_stage.addEventListener(MouseEvent.MOUSE_UP, _upInside, false, 0, true);
			_target.addEventListener(MouseEvent.ROLL_OUT, _rollOut, false, 0, true);
			_timer.addEventListener(TimerEvent.TIMER, _timerTimer, false, 0, true);
			
			///// dispose function
			_disposeFunc = function():void {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, _upInside, false);
				_target.removeEventListener(MouseEvent.ROLL_OUT, _rollOut, false);
				_timer.removeEventListener(TimerEvent.TIMER, _timerTimer, false);
				_timer.stop();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// rollout
		//---------------------------------------
		protected function _rollOut(e:MouseEvent):void {
			///// drop
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _upInside, false);
			_target.removeEventListener(MouseEvent.ROLL_OUT, _rollOut, false);
			_timer.removeEventListener(TimerEvent.TIMER, _timerTimer, false);
			_timer.stop();
			_timer = null;
			
			///// listen
			_stage.addEventListener(MouseEvent.MOUSE_UP, _upOutside, false, 0, true);
			_target.addEventListener(MouseEvent.ROLL_OVER, _rollOver, false, 0, true);
			
			///// dispose function
			_disposeFunc = function():void {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, _upOutside, false);
				_target.removeEventListener(MouseEvent.ROLL_OVER, _rollOver, false);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// up outside
		//---------------------------------------
		protected function _upOutside(e:MouseEvent):void {
			///// drop
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _upOutside, false);
			_target.removeEventListener(MouseEvent.ROLL_OVER, _rollOver, false);
			
			///// del
			_stage = null;
			
			///// listen
			_target.addEventListener(MouseEvent.MOUSE_DOWN, _down, false, 0, true);
			
			///// dispose function
			_disposeFunc = function():void {
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, _down, false);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// rollover
		//---------------------------------------
		protected function _rollOver(e:MouseEvent):void {
			///// drop
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _upOutside, false);
			_target.removeEventListener(MouseEvent.ROLL_OVER, _rollOver, false);
			
			///// timer
			_timer = new Timer(_duration * 1000, 1);
			_timer.start();
			
			///// listen
			_stage.addEventListener(MouseEvent.MOUSE_UP, _upInside, false, 0, true);
			_target.addEventListener(MouseEvent.ROLL_OUT, _rollOut, false, 0, true);
			_timer.addEventListener(TimerEvent.TIMER, _timerTimer, false, 0, true);
			
			///// dispose function
			_disposeFunc = function():void {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, _upInside, false);
				_target.removeEventListener(MouseEvent.ROLL_OUT, _rollOut, false);
				_timer.removeEventListener(TimerEvent.TIMER, _timerTimer, false);
				_timer.stop();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// timer
		//---------------------------------------
		protected function _timerTimer(e:TimerEvent):void {
			///// drop
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _upInside, false);
			_target.removeEventListener(MouseEvent.ROLL_OUT, _rollOut, false);
			_timer.removeEventListener(TimerEvent.TIMER, _timerTimer, false);
			_timer.stop();
			_timer = null;
			_stage = null;
			
			///// listen
			_target.addEventListener(MouseEvent.MOUSE_DOWN, _down, false, 0, true);
			
			///// dispose function
			_disposeFunc = function():void {
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, _down, false);
			}
			
			///// dispatch
			var dispatcher:IEventDispatcher = _dispatcher ? _dispatcher : this;
			
			dispatcher.dispatchEvent(new HoldEvent(
				HoldEvent.HOLD, false, false, target, this
			));
		}
		
		
		
		
		
		//---------------------------------------
		// up inside
		//---------------------------------------
		protected function _upInside(e:MouseEvent):void {
			///// drop
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _upInside, false);
			_target.removeEventListener(MouseEvent.ROLL_OUT, _rollOut, false);
			_timer.removeEventListener(TimerEvent.TIMER, _timerTimer, false);
			_timer.stop();
			_timer = null;
			_stage = null;
			
			///// target
			_target.addEventListener(MouseEvent.MOUSE_DOWN, _down, false, 0, true);
			
			///// dispose function
			_disposeFunc = function():void {
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, _down, false);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// dispose
		//---------------------------------------
		override protected function _onDispose():void {
			_disposeFunc && _disposeFunc();
		}
	}
}