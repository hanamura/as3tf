/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.hold {
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class HoldingEvent extends Event {
		static public const HOLD:String       = "HoldingEvent.HOLD";
		static public const OUT:String        = "HoldingEvent.OUT";
		static public const OVER:String       = "HoldingEvent.OVER";
		static public const UP:String         = "HoldingEvent.UP";
		static public const UP_OUTSIDE:String = "HoldingEvent.UP_OUTSIDE";
		
		//---------------------------------------
		// instance
		//---------------------------------------
		protected var _targetPoint:Point        = null;
		protected var _currentTargetMouse:Point = null;
		protected var _currentStageMouse:Point  = null;
		
		public function get targetPoint():Point {
			return _targetPoint.clone();
		}
		public function get currentTargetMouse():Point {
			return _currentTargetMouse.clone();
		}
		public function get currentStageMouse():Point {
			return _currentStageMouse.clone();
		}
		
		//---------------------------------------
		// objects
		//---------------------------------------
		protected var _targetObject:InteractiveObject = null;
		protected var _controller:Holding             = null;
		
		public function get targetObject():InteractiveObject {
			return _targetObject;
		}
		public function get controller():Holding {
			return _controller;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function HoldingEvent(
			type:String,
			bubbles:Boolean                = false,
			cancelable:Boolean             = false,
			targetPoint:Point              = null,
			currentTargetMouse:Point       = null,
			currentStageMouse:Point        = null,
			targetObject:InteractiveObject = null,
			controller:Holding             = null
		) {
			super(type, bubbles, cancelable);
			
			_targetObject = targetObject;
			_controller   = controller;
			
			_targetPoint        = targetPoint.clone();
			_currentTargetMouse = currentTargetMouse.clone();
			_currentStageMouse  = currentStageMouse.clone();
		}
		
		override public function clone():Event {
			return new HoldingEvent(
				type,
				bubbles,
				cancelable,
				_targetPoint,
				_currentTargetMouse,
				_currentStageMouse,
				_targetObject,
				_controller
			);
		}
	}
}