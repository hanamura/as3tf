/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.hold {
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.typefest.proc.Proc;
	
	public class Holding extends Proc {
		protected var _target:InteractiveObject = null;
		protected var _duration:*               = null;
		
		protected var _stage:Stage = null;
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Holding(target:InteractiveObject, duration:* = 1) {
			super();
			
			_target   = target;
			_duration = duration;
			
			fire();
		}
		
		override protected function _start():void {
			listen(_target, MouseEvent.MOUSE_DOWN, _down);
		}
		
		//---------------------------------------
		// down
		//---------------------------------------
		protected function _down(e:MouseEvent):void {
			_stage = _target.stage;
			
			listen(_target, MouseEvent.ROLL_OUT, _out);
			listen(_stage, MouseEvent.MOUSE_UP, _up);
			sleep(_duration, _hold);
		}
		
		protected function _out(e:MouseEvent):void {
			listen(_target, MouseEvent.ROLL_OVER, _over);
			listen(_stage, MouseEvent.MOUSE_UP, _up);
		}
		
		protected function _over(e:MouseEvent):void {
			listen(_target, MouseEvent.ROLL_OUT, _out);
			listen(_stage, MouseEvent.MOUSE_UP, _up);
			sleep(_duration, _hold);
		}
		
		protected function _up(e:MouseEvent):void {
			listen(_target, MouseEvent.MOUSE_DOWN, _down);
			
			_stage = null;
		}
		
		//---------------------------------------
		// hold
		//---------------------------------------
		protected function _hold():void {
			listen(_target, MouseEvent.ROLL_OUT, _holdOut);
			listen(_stage, MouseEvent.MOUSE_UP, _holdUp);
			
			_dispatch(HoldingEvent.HOLD);
		}
		
		protected function _holdOut(e:MouseEvent):void {
			listen(_target, MouseEvent.ROLL_OVER, _holdOver);
			listen(_stage, MouseEvent.MOUSE_UP, _holdUpOutside);
			
			_dispatch(HoldingEvent.OUT);
		}
		
		protected function _holdOver(e:MouseEvent):void {
			listen(_target, MouseEvent.ROLL_OUT, _holdOut);
			listen(_stage, MouseEvent.MOUSE_UP, _holdUp);
			
			_dispatch(HoldingEvent.OVER);
		}
		
		protected function _holdUp(e:MouseEvent):void {
			listen(_target, MouseEvent.MOUSE_DOWN, _down);
			
			_dispatch(HoldingEvent.UP);
			
			_stage = null;
		}
		
		protected function _holdUpOutside(e:MouseEvent):void {
			listen(_target, MouseEvent.MOUSE_DOWN, _down);
			
			_dispatch(HoldingEvent.UP_OUTSIDE);
			
			_stage = null;
		}
		
		//---------------------------------------
		// shortcut
		//---------------------------------------
		protected function _dispatch(type:String):void {
			var event:Event = new HoldingEvent(
				type,
				([HoldingEvent.HOLD, HoldingEvent.UP].indexOf(type) >= 0),
				false,
				new Point(_target.x, _target.y),
				new Point(_target.mouseX, _target.mouseY),
				new Point(_stage.mouseX, _stage.mouseY),
				_target,
				this
			);
			
			_target.dispatchEvent(event.clone());
			dispatchEvent(event.clone());
		}
	}
}