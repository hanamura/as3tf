/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.adhoc.shape {
	import flash.geom.Rectangle;
	
	public class Rect extends AbstractShape {
		protected var _outer:Rectangle = null;
		protected var _inner:Rectangle = null;
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Rect() {
			super();
			_outer = new Rectangle();
			_inner = new Rectangle();
		}
		
		//---------------------------------------
		// AbstractShape Updates
		//---------------------------------------
		override protected function _updateForm():void {
			_updateRectangles();
			_drawRectangles();
		}
		
		override protected function _updatePosition():void {
			_updateRectangles();
			_drawRectangles();
		}
		
		override protected function _updateColor():void {
			_drawRectangles();
		}
		
		//---------------------------------------
		// Update Rectangles
		//---------------------------------------
		protected function _updateRectangles():void {
			if (_lineSide === LineSide.OUTSIDE) {
				_outer.x      = -_lineWidth;
				_outer.y      = -_lineWidth;
				_outer.width  = _width + (_lineWidth * 2);
				_outer.height = _height + (_lineWidth * 2);
				_inner.x      = 0;
				_inner.y      = 0;
				_inner.width  = _width;
				_inner.height = _height;
			} else if (_lineSide === LineSide.CENTER) {
				_outer.x      = -(_lineWidth * 0.5);
				_outer.y      = -(_lineWidth * 0.5);
				_outer.width  = _width + _lineWidth;
				_outer.height = _height + _lineWidth;
				_inner.x      = _lineWidth * 0.5;
				_inner.y      = _lineWidth * 0.5;
				_inner.width  = _width - _lineWidth;
				_inner.height = _height - _lineWidth;
			} else { // default: LineSide.INSIDE
				_outer.x      = 0;
				_outer.y      = 0;
				_outer.width  = _width;
				_outer.height = _height;
				_inner.x      = _lineWidth;
				_inner.y      = _lineWidth;
				_inner.width  = _width - (_lineWidth * 2);
				_inner.height = _height - (_lineWidth * 2);
			}
			
			var offsetX:Number = -_width * _positionX;
			var offsetY:Number = -_height * _positionY;
			
			_outer.offset(offsetX, offsetY);
			_inner.offset(offsetX, offsetY);
		}
		
		//---------------------------------------
		// Draw Rectangles
		//---------------------------------------
		protected function _drawRectangles():void {
			_graphics.clear();
			
			if (_outer.isEmpty()) {
				return;
			}
			
			// select fill function and arguments
			var fillBegin:Function = _graphics.beginFill;
			var fillArgs:Array     = [_fill, _fillAlpha];
			if (_fillArgs) {
				fillBegin = AbstractShape.selectBeginFill(_fillArgs, _graphics);
				fillBegin && (fillArgs = _fillArgs);
			}
			
			// select line function and arguments
			var lineBegin:Function = _graphics.beginFill;
			var lineArgs:Array     = [_line, _lineAlpha];
			if (_lineArgs) {
				lineBegin = AbstractShape.selectBeginFill(_lineArgs, _graphics);
				lineBegin && (lineArgs = _lineArgs);
			}
			
			// draw
			if (_outer.equals(_inner)) {
				if (_fillEnabled) {
					fillBegin.apply(null, fillArgs);
					_drawInnerShape();
					_graphics.endFill();
				}
			} else {
				lineBegin.apply(null, lineArgs);
				_drawOuterShape();
				if (_fillEnabled) {
					if (_fill === _line && _fillAlpha === _lineAlpha) {
						_graphics.endFill();
					} else if (_inner.isEmpty()) {
						_graphics.endFill();
					} else {
						if (_fillAlpha < 1) {
							_drawInnerShape();
						}
						_graphics.endFill();
						fillBegin.apply(null, fillArgs);
						_drawInnerShape();
						_graphics.endFill();
					}
				} else {
					_drawInnerShape();
					_graphics.endFill();
				}
			}
		}
		
		protected function _drawOuterShape():void {
			_graphics.drawRect(
				_outer.x, _outer.y,
				_outer.width, _outer.height
			);
		}
		
		protected function _drawInnerShape():void {
			_graphics.drawRect(
				_inner.x, _inner.y,
				_inner.width, _inner.height
			);
		}
	}
}