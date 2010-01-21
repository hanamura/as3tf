/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.shape {
	import flash.geom.Rectangle;
	
	public class RoundRect extends Rect {
		protected var _cornerRadius:Number = 10;
		
		public function get cornerRadius():Number {
			return _cornerRadius;
		}
		public function set cornerRadius(x:Number):void {
			if(_cornerRadius !== x) {
				_cornerRadius = x;
				_updateForm();
			}
		}
		
		protected var _outerDiameter:Number = 0;
		protected var _innerDiameter:Number = 0;
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function RoundRect() {
			super();
		}
		
		override protected function _updateForm():void {
			_updateRectangles();
			_updateDiameters();
			_drawRectangles();
		}
		
		protected function _updateDiameters():void {
			if (_lineSide === LineSide.OUTSIDE) {
				_outerDiameter = (_cornerRadius + _lineWidth) * 2;
				_innerDiameter = _cornerRadius * 2;
			} else if (_lineSide === LineSide.CENTER) {
				_outerDiameter = (_cornerRadius + (_lineWidth * 0.5)) * 2;
				_innerDiameter = (_cornerRadius - (_lineWidth * 0.5)) * 2;
			} else { ///// default: LineSide.INSIDE
				_outerDiameter = _cornerRadius * 2;
				_innerDiameter = (_cornerRadius - _lineWidth) * 2;
			}
		}
		
		override protected function _drawOuterShape():void {
			_graphics.drawRoundRect(
				_outer.x, _outer.y,
				_outer.width, _outer.height,
				_outerDiameter, _outerDiameter
			);
		}
		
		override protected function _drawInnerShape():void {
			_graphics.drawRoundRect(
				_inner.x, _inner.y,
				_inner.width, _inner.height,
				_innerDiameter, _innerDiameter
			);
		}
	}
}