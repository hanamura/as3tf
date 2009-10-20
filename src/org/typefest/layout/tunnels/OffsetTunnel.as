/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout.tunnels {
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	
	import org.typefest.core.Num;
	import org.typefest.layout.Area;
	
	public class OffsetTunnel extends XYTunnel {
		//---------------------------------------
		// offset
		//---------------------------------------
		protected var _offsetX:Number = 0;
		protected var _offsetY:Number = 0;

		public function get offsetX():Number {
			return _offsetX;
		}
		public function set offsetX(x:Number):void {
			if (_offsetX !== x) {
				_offsetX = x;
				_updateArea();
			}
		}
		public function get offsetY():Number {
			return _offsetY;
		}
		public function set offsetY(y:Number):void {
			if (_offsetY !== y) {
				_offsetY = y;
				_updateArea();
			}
		}
		
		//---------------------------------------
		// range
		//---------------------------------------
		protected var _rangeX:Number = 0;
		protected var _rangeY:Number = 0;
		
		public function get rangeX():Number {
			return _rangeX;
		}
		public function get rangeY():Number {
			return _rangeY;
		}
		
		//---------------------------------------
		// forbidden
		//---------------------------------------
		override public function set ratioX(x:Number):void {
			offsetX = rangeX * x;
		}
		override public function set ratioY(y:Number):void {
			offsetY = rangeY * y;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function OffsetTunnel(from:Area = null, to:Area = null) {
			super(from, to);
		}
		
		override protected function _updateArea():void {
			// when from or to change
			
			// update range
			_rangeX = _to.x - _from.x;
			_rangeY = _to.y - _from.y;
			
			// update by offset
			var rect:Rectangle = new Rectangle();
			
			rect.x = _from.x + _offsetX;
			rect.y = _from.y + _offsetY;
			
			_ratioX = (_rangeX === 0) ? 0 : (_offsetX / _rangeX);
			_ratioY = (_rangeY === 0) ? 0 : (_offsetY / _rangeY);
			
			rect.width  = Num.between(_from.width, _to.width, _ratioX);
			rect.height = Num.between(_from.height, _to.height, _ratioY);
			
			// set rectangle
			var some:Boolean = false;
			
			if (_rect.x !== rect.x) {
				_rect.x = rect.x;
				some = true;
			}
			if (_rect.y !== rect.y) {
				_rect.y = rect.y;
				some = true;
			}
			if (_rect.width !== rect.width) {
				_rect.width = rect.width;
				some = true;
			}
			if (_rect.height !== rect.height) {
				_rect.height = rect.height;
				some = true;
			}
			
			if (some) {
				_update();
			}
		}
	}
}