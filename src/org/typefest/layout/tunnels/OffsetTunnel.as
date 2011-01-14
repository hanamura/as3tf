/*
Copyright (c) 2011 Taro Hanamura
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
				_updateByOffset();
			}
		}
		public function get offsetY():Number {
			return _offsetY;
		}
		public function set offsetY(y:Number):void {
			if (_offsetY !== y) {
				_offsetY = y;
				_updateByOffset();
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
			if (_ratioX !== x) {
				_ratioX = x;
				_updateByRatio();
			}
		}
		override public function set ratioY(y:Number):void {
			if (_ratioY !== y) {
				_ratioY = y;
				_updateByRatio();
			}
		}
		
		//---------------------------------------
		// offset enabled
		//---------------------------------------
		protected var _offsetEnabled:Boolean = true;
		
		public function get offsetEnabled():Boolean {
			return _offsetEnabled;
		}
		public function set offsetEnabled(bool:Boolean):void {
			if (_offsetEnabled !== bool) {
				_offsetEnabled = bool;
			}
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function OffsetTunnel(from:Area = null, to:Area = null) {
			super(from, to);
		}
		
		//---------------------------------------
		// updates
		//---------------------------------------
		override protected function _updateArea():void {
			_rangeX = _to.x - _from.x;
			_rangeY = _to.y - _from.y;
			
			if (_offsetEnabled) {
				_updateByOffset();
			} else {
				_updateByRatio();
			}
		}
		protected function _updateByOffset():void {
			_ratioX = (_rangeX === 0) ? 0 : (_offsetX / _rangeX);
			_ratioY = (_rangeY === 0) ? 0 : (_offsetY / _rangeY);
			
			var rect:Rectangle = new Rectangle();
			
			rect.x      = _from.x + _offsetX;
			rect.y      = _from.y + _offsetY;
			rect.width  = Num.between(_from.width, _to.width, _ratioX);
			rect.height = Num.between(_from.height, _to.height, _ratioY);
			
			_applyToUpdate(rect);
		}
		protected function _updateByRatio():void {
			_offsetX = _rangeX * _ratioX;
			_offsetY = _rangeY * _ratioY;
			
			super._updateArea();
		}
	}
}