/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.typefest.layout.*;
	
	public class BottomupTunnel extends OffsetTunnel {
		
		override public function set x(x:Number):void {}
		override public function set y(y:Number):void {}
		
		override public function set width(width:Number):void {
			if (_rect.width !== width) {
				_rect.width = width;
				_updateSize();
			}
		}
		override public function set height(height:Number):void {
			if (_rect.height !== height) {
				_rect.height = height;
				_updateSize();
			}
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function BottomupTunnel() {
			super();
			
			_from.layout = Layout.noScale;
			_to.layout   = Layout.noScale;
		}
		
		override public function set(
			x:Number,
			y:Number,
			width:Number,
			height:Number
		):void {
			var some:Boolean = false;
			
			if (_rect.width !== width) {
				_rect.width = width;
				some = true;
			}
			if (_rect.height !== height) {
				_rect.height = height;
				some = true;
			}
			
			if (some) {
				_updateSize();
			}
		}
		
		protected function _updateSize():void {
			_from.original = new Rectangle(0, 0, width, height);
			_to.original   = new Rectangle(0, 0, width, height);
			
			_update();
		}
		
		override protected function _updateArea():void {
			_rangeX = _to.x - _from.x;
			_rangeY = _to.y - _from.y;
			
			var position:Point = new Point();
			
			position.x = _from.x + _offsetX;
			position.y = _from.y + _offsetY;
			
			_ratioX = (_rangeX === 0) ? 0 : (_offsetX / _rangeX);
			_ratioY = (_rangeY === 0) ? 0 : (_offsetY / _rangeY);
			
			var some:Boolean = false;
			
			if (_rect.x !== position.x) {
				_rect.x = position.x;
				some = true;
			}
			if (_rect.y !== position.y) {
				_rect.y = position.y;
				some = true;
			}
			
			if (some) {
				_update();
			}
		}
	}
}