/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.containers {
	import flash.display.DisplayObject;
	
	import org.typefest.core.Arr;
	import org.typefest.core.Num;
	
	
	
	
	
	public class HStack extends Stack {
		///// size
		override public function set width(_:Number):void {}
		override public function set height(_:Number):void {
			if (_height !== _) {
				_height = _;
				_heightResize();
			}
		}
		override public function setSize(w:Number, h:Number):void { height = h }
		
		
		
		
		
		//---------------------------------------
		// arrange
		//---------------------------------------
		override protected function _arrangeItems():void {
			var itemHeight:Number = height - _marginTop - _marginBottom;
			var currentX:Number   = _marginLeft;
			
			for each (var item:DisplayObject in _items) {
				item.height = itemHeight;
				item.x      = currentX;
				item.y      = _marginTop;
				
				currentX += item.width + _marginInside;
			}
		}
		
		
		
		
		
		//---------------------------------------
		// check size
		//---------------------------------------
		override protected function _checkStackSize():void {
			var width:Number = _getStackSize();
			
			if (_width !== width) {
				_width = width;
				_resize();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// get size
		//---------------------------------------
		override protected function _getStackSize():Number {
			if (_items.length) {
				return (
					_marginLeft +
					Num.add.apply(null, Arr.select(_items, "width")) +
					_marginInside * (_items.length - 1) +
					_marginRight
				);
			} else {
				return _marginLeft + _marginRight;
			}
		}
		
		
		
		
		
		//---------------------------------------
		// resize
		//---------------------------------------
		protected function _heightResize():void {
			_arrange();
			_width = _getStackSize();
			_resize();
		}
	}
}