/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.layout {
	public class ComplexBridge extends Bridge {
		///// range
		public function get rangeX():Number { return _b.x - _a.x }
		public function get rangeY():Number { return _b.y - _a.y }
		
		///// offset
		protected var _offsetX:Number = NaN;
		protected var _offsetY:Number = NaN;
		
		public function get offsetX():Number { return _offsetX }
		public function set offsetX(_:Number):void {
			if (_offsetX !== _) {
				_offsetX = _;
				_update();
			}
		}
		public function get offsetY():Number { return _offsetY }
		public function set offsetY(_:Number):void {
			if (_offsetY !== _) {
				_offsetY = _;
				_update();
			}
		}
		
		///// ratio
		override public function get ratio():Number { return 0 }
		override public function set ratio(_:Number):void {}
		
		///// ratio
		protected var _ratioX:Number = 0;
		protected var _ratioY:Number = 0;
		
		public function get ratioX():Number { return _ratioX }
		public function set ratioX(_:Number):void {
			if (_ratioX !== _) {
				_ratioX = _;
				_update();
			}
		}
		public function get ratioY():Number { return _ratioY }
		public function set ratioY(_:Number):void {
			if (_ratioY !== _) {
				_ratioY = _;
				_update();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function ComplexBridge() {
			super();
		}
		
		
		
		
		
		//---------------------------------------
		// set offset
		//---------------------------------------
		public function setOffset(x:Number, y:Number):void {
			if (_offsetX !== x || _offsetY !== y) {
				_offsetX = x;
				_offsetY = y;
				_update();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// set ratio
		//---------------------------------------
		public function setRatio(x:Number, y:Number):void {
			if (_ratioX !== x || _ratioY !== y) {
				_ratioX = x;
				_ratioY = y;
				_update();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// update
		//---------------------------------------
		override protected function _update():void {
			var x:Number;
			var y:Number;
			
			if (isNaN(_offsetX)) {
				x = _a.x + (_b.x - _a.x) * _ratioX;
			} else {
				x = _a.x + _offsetX;
			}
			
			if (isNaN(_offsetY)) {
				y = _a.y + (_b.y - _a.y) * _ratioY;
			} else {
				y = _a.y + _offsetY;
			}
			
			if (_x !== x || _y !== y) {
				_x = x;
				_y = y;
				_reposition();
			}
		}
	}
}