/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout.tables {
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	
	public class HorizontalTable extends VerticalTable {
		override public function set lengthX(x:int):void {
			throw new IllegalOperationError("Unable to set lengthX.");
		}
		override public function set lengthY(y:int):void {
			if (y < 1) {
				throw new ArgumentError("lengthY must be larger than 1.");
			}
			if (_lengthY !== y) {
				_lengthY = y;
				_updateTable();
			}
		}
		override public function get length():int {
			return _lengthY;
		}
		override public function set length(y:int):void {
			lengthY = y;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function HorizontalTable(lengthY:int = 1) {
			super();
			
			_lengthX = 0;
			if (lengthY < 1) {
				throw new ArgumentError("lengthY must be larger than 1.");
			}
			_lengthY = lengthY;
		}
		
		override protected function _updateTable(start:int = 0):void {
			var size:Rectangle = new Rectangle();
			
			_lengthX = Math.ceil(__sequence.length / _lengthY);
			
			if (_lengthX <= 0) {
				size.width = 0;
			} else {
				size.width = 0
					+ _paddingLeft
					+ (
						  (_cellWidth * _lengthX)
						+ (_marginX * (_lengthX - 1))
					  )
					+ _paddingRight;
			}
			
			size.height = 0
				+ _paddingTop
				+ (
					  (_cellHeight * _lengthY)
					+ (_marginY * (_lengthY - 1))
				  )
				+ _paddingBottom;
			
			// update type selection
			if (width === size.width && height === size.height) {
				_updateCells(start);
			} else {
				_rect.width  = size.width;
				_rect.height = size.height;
				
				if (_parentArea) {
					_parentArea.update(this);
				} else {
					_update();
				}
			}
		}
		
		override protected function _getMemberArea(i:int):Rectangle {
			var indexX:int = Math.floor(i / _lengthY);
			var indexY:int = i % _lengthY;
			
			var area:Rectangle = new Rectangle();
			area.x      = x + _paddingLeft + ((_cellWidth + _marginX) * indexX);
			area.y      = y + _paddingTop + ((_cellHeight + _marginY) * indexY);
			area.width  = _cellWidth;
			area.height = _cellHeight;
			
			return area;
		}
	}
}