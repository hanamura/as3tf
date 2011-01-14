/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.layout {
	import flash.geom.Rectangle;
	
	
	
	
	
	public class Pier extends LayoutNode {
		///// layout method
		override public function get layoutMethod():Function { return _layout }
		override public function set layoutMethod(_:Function):void {}
		override public function set layoutWidth(_:Number):void {}
		override public function set layoutHeight(_:Number):void {}
		override public function setLayoutSize(w:Number, h:Number):void {}
		
		
		
		///// position ratio
		protected var _positionX:Number = 0;
		protected var _positionY:Number = 0;
		
		public function get positionX():Number { return _positionX }
		public function set positionX(_:Number):void {
			if (_positionX !== _) {
				_positionX = _;
				_updateLayout();
			}
		}
		public function get positionY():Number { return _positionY }
		public function set positionY(_:Number):void {
			if (_positionY !== _) {
				_positionY = _;
				_updateLayout();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Pier() {
			super();
		}
		
		
		
		
		
		//---------------------------------------
		// layout update
		//---------------------------------------
		layout_internal function setLayoutSize(width:Number, height:Number):void {
			if (_layoutWidth !== width || _layoutHeight !== height) {
				_layoutWidth  = width;
				_layoutHeight = height;
				_updateLayout();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// set position ratio
		//---------------------------------------
		public function setPositionRatio(x:Number, y:Number):void {
			if (_positionX !== x || _positionY !== y) {
				_positionX = x;
				_positionY = y;
				_updateLayout();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// internal layout method
		//---------------------------------------
		protected function _layout(area:Rectangle, target:Rectangle):Rectangle {
			return Layout.noScale(area, target, _positionX, _positionY);
		}
	}
}