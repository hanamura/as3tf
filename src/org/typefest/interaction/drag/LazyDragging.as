/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.drag {
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	
	public class LazyDragging extends Dragging {
		static public const X:String  = "x";
		static public const Y:String  = "y";
		static public const XY:String = "xy";
		
		//---------------------------------------
		// instance
		//---------------------------------------
		protected var _threshold:Number = 0;
		protected var _direction:String = XY;

		public function get threshold():Number {
			return _threshold;
		}
		public function set threshold(x:Number):void {
			_threshold = x;
		}
		
		public function get direction():String {
			return _direction;
		}
		public function set direction(x:String):void {
			if (_direction !== x) {
				
				if ([X, Y, XY].indexOf(x) < 0) {
					throw new ArgumentError("Invalid direction.");
				}
				
				_direction = x;
			}
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function LazyDragging(
			target:InteractiveObject,
			threshold:Number,
			direction:String = XY
		) {
			super(target);
			
			_threshold = threshold;
			
			this.direction = direction;
		}
		
		override protected function _test():Boolean {
			if (direction === X) {
				return Math.abs(_lastTargetMouse.x - _targetMouse.x) >= _threshold;
			} else if (direction === Y) {
				return Math.abs(_lastTargetMouse.y - _targetMouse.y) >= _threshold;
			} else {
				return Point.distance(_targetMouse, _lastTargetMouse) >= _threshold;
			}
		}
	}
}