/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.drag {
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.typefest.interaction.drag.Dragging;
	
	public class DraggingEvent extends Event {
		static public const START:String = "DraggingEvent.START";
		static public const DRAG:String  = "DraggingEvent.DRAG";
		static public const END:String   = "DraggingEvent.END";
		
		//---------------------------------------
		// instance
		//---------------------------------------
		protected var _targetPoint:Point        = null;
		protected var _targetMouse:Point        = null;
		protected var _stageMouse:Point         = null;
		protected var _currentTargetMouse:Point = null;
		protected var _currentStageMouse:Point  = null;
		
		public function get targetPoint():Point {
			return _targetPoint.clone();
		}
		
		public function get targetMouse():Point {
			return _targetMouse.clone();
		}
		public function get stageMouse():Point {
			return _stageMouse.clone();
		}
		public function get currentTargetMouse():Point {
			return _currentTargetMouse.clone();
		}
		public function get currentStageMouse():Point {
			return _currentStageMouse.clone();
		}
		
		public function get targetOffset():Point {
			return _currentTargetMouse.subtract(_targetMouse);
		}
		public function get stageOffset():Point {
			return _currentStageMouse.subtract(_stageMouse);
		}
		
		//---------------------------------------
		// controller
		//---------------------------------------
		protected var _targetObject:InteractiveObject = null;
		protected var _controller:Dragging            = null;
		
		public function get targetObject():InteractiveObject {
			return _targetObject;
		}
		public function get controller():Dragging {
			return _controller;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function DraggingEvent(
			type:String,
			bubbles:Boolean                = false,
			cancelable:Boolean             = false,
			targetPoint:Point              = null,
			targetMouse:Point              = null,
			stageMouse:Point               = null,
			currentTargetMouse:Point       = null,
			currentStageMouse:Point        = null,
			targetObject:InteractiveObject = null,
			controller:Dragging            = null
		) {
			super(type, bubbles, cancelable);
			
			_targetPoint        = targetPoint.clone();
			_targetMouse        = targetMouse.clone();
			_stageMouse         = stageMouse.clone();
			_currentTargetMouse = currentTargetMouse.clone();
			_currentStageMouse  = currentStageMouse.clone();
			
			_targetObject = targetObject;
			_controller   = controller;
		}
		
		override public function clone():Event {
			return new DraggingEvent(
				type,
				bubbles,
				cancelable,
				_targetPoint,
				_targetMouse,
				_stageMouse,
				_currentTargetMouse,
				_currentStageMouse,
				_targetObject,
				_controller
			);
		}
	}
}