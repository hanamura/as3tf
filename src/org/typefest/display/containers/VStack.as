/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.containers {
	import flash.display.DisplayObject;
	
	import org.typefest.core.Arr;
	import org.typefest.core.Num;
	
	
	
	
	
	public class VStack extends Stack {
		///// size
		override public function set width(_:Number):void {
			if (_width !== _) {
				_width = _;
				_widthResize();
			}
		}
		override public function set height(_:Number):void {}
		override public function setSize(w:Number, h:Number):void { width = w }
		
		
		
		
		
		//---------------------------------------
		// arrange
		//---------------------------------------
		override protected function _arrangeItems():void {
			var itemWidth:Number = width - _marginLeft - _marginRight;
			var currentY:Number  = _marginTop;
			
			for each (var item:DisplayObject in _items) {
				item.width = itemWidth;
				item.x     = _marginLeft;
				item.y     = currentY;
				
				currentY += item.height + _marginInside;
			}
		}
		
		
		
		
		
		//---------------------------------------
		// check size
		//---------------------------------------
		override protected function _checkStackSize():void {
			var height:Number = _getStackSize();
			
			if (_height !== height) {
				_height = height;
				_resize();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// get size
		//---------------------------------------
		override protected function _getStackSize():Number {
			if (_items.length) {
				return (
					_marginTop +
					Num.add.apply(null, Arr.select(_items, "height")) +
					_marginInside * (_items.length - 1) +
					_marginBottom
				);
			} else {
				return _marginTop + _marginBottom;
			}
		}
		
		
		
		
		
		//---------------------------------------
		// resize
		//---------------------------------------
		protected function _widthResize():void {
			_arrange();
			_height = _getStackSize();
			_resize();
		}
	}
}