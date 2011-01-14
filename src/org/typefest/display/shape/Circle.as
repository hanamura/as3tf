/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.shape {
	import flash.errors.IllegalOperationError;
	
	public class Circle extends Rect {
		protected var _radius:Number = 0;
		
		public function get radius():Number {
			return _radius;
		}
		public function set radius(x:Number):void {
			if (_radius !== x) {
				_radius = x;
				_width  = _height = x * 2;
				_updateForm();
			}
		}
		
		protected var _outerRadius:Number = 0;
		protected var _innerRadius:Number = 0;
		
		override public function get width():Number {
			return _radius * 2;
		}
		override public function set width(x:Number):void {
			throw new IllegalOperationError('"width" cannot be set.');
		}
		
		override public function get height():Number {
			return _radius * 2;
		}
		override public function set height(x:Number):void {
			throw new IllegalOperationError('"height" cannot be set.');
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Circle() {
			super();
		}
		
		override public function setSize(width:Number, height:Number):void {
			throw new IllegalOperationError('"setSize()" is not permitted.');
		}
		
		override protected function _updateForm():void {
			_updateRectangles();
			_updateRadii();
			_drawRectangles();
		}
		
		protected function _updateRadii():void {
			if (_lineSide === LineSide.OUTSIDE) {
				_outerRadius = _radius + _lineWidth;
				_innerRadius = _radius;
			} else if (_lineSide === LineSide.CENTER) {
				_outerRadius = _radius + (_lineWidth * 0.5);
				_innerRadius = _radius - (_lineWidth * 0.5);
			} else { ///// default: LineSide.INSIDE
				_outerRadius = _radius;
				_innerRadius = _radius - _lineWidth;
			}
		}
		
		override protected function _drawOuterShape():void {
			_graphics.drawCircle(
				_outer.x + _outerRadius,
				_outer.y + _outerRadius,
				_outerRadius
			);
		}
		
		override protected function _drawInnerShape():void {
			_graphics.drawCircle(
				_inner.x + _innerRadius,
				_inner.y + _innerRadius,
				_innerRadius
			);
		}
	}
}