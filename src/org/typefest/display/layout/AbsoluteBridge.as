/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.layout {
	public class AbsoluteBridge extends Bridge {
		///// range
		public function get rangeX():Number { return _b.x - _a.x }
		public function get rangeY():Number { return _b.y - _a.y }
		
		///// offset
		protected var _offsetX:Number = 0;
		protected var _offsetY:Number = 0;
		
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
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function AbsoluteBridge() {
			super();
		}
		
		
		
		
		
		//---------------------------------------
		// update
		//---------------------------------------
		override protected function _update():void {
			var x:Number = _a.x + _offsetX;
			var y:Number = _a.y + _offsetY;
			
			if (_x !== x || _y !== y) {
				_x = x;
				_y = y;
				_reposition();
			}
		}
	}
}