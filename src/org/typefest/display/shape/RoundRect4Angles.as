/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

/*
referred to http://wonderfl.net/c/74QW
*/

package org.typefest.display.shape {
	import flash.display.GraphicsPath;
	import flash.geom.Rectangle;
	
	
	
	
	
	public class RoundRect4Angles extends ShapeBase {
		///// ellipse ratio
		private static const ELLIPSE_RATIO:Number = Math.SQRT2 - 1;
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// internal
		protected var _cornerRadii:Array = [0, 0, 0, 0];
		protected var _outerRadii:Array  = null;
		protected var _innerRadii:Array  = null;
		
		
		
		///// radii
		public function get bottomRightRadius():Number { return _cornerRadii[0] }
		public function set bottomRightRadius(_:Number):void {
			if (_cornerRadii[0] !== _) {
				_cornerRadii[0] = _;
				_updateBounds();
				_render();
			}
		}
		public function get bottomLeftRadius():Number { return _cornerRadii[1] }
		public function set bottomLeftRadius(_:Number):void {
			if (_cornerRadii[1] !== _) {
				_cornerRadii[1] = _;
				_updateBounds();
				_render();
			}
		}
		public function get topRightRadius():Number { return _cornerRadii[2] }
		public function set topRightRadius(_:Number):void {
			if (_cornerRadii[2] !== _) {
				_cornerRadii[2] = _;
				_updateBounds();
				_render();
			}
		}
		public function get topLeftRadius():Number { return _cornerRadii[3] }
		public function set topLeftRadius(_:Number):void {
			if (_cornerRadii[3] !== _) {
				_cornerRadii[3] = _;
				_updateBounds();
				_render();
			}
		}
		
		
		
		
		
		
		//---------------------------------------
		// set corner radii
		//---------------------------------------
		public function setCornerRadii(
			bottomRight:Number,
			bottomLeft:Number,
			topRight:Number,
			topLeft:Number
		):void {
			if (
				_cornerRadii[0] !== bottomRight ||
				_cornerRadii[1] !== bottomLeft ||
				_cornerRadii[2] !== topRight ||
				_cornerRadii[3] !== topLeft
			) {
				_cornerRadii = [bottomRight, bottomLeft, topRight, topLeft];
				_updateBounds();
				_render();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// update bounds
		//---------------------------------------
		override protected function _updateBounds():void {
			super._updateBounds();
			
			var radius:Number;
			
			_outerRadii = [];
			_innerRadii = [];
			
			if (_lineSide === LineSide.OUTSIDE) {
				for each (radius in _cornerRadii) {
					_outerRadii.push(radius + _lineWidth);
					_innerRadii.push(radius);
				}
			} else if (_lineSide === LineSide.CENTER) {
				for each (radius in _cornerRadii) {
					_outerRadii.push(radius + _lineWidth * 0.5);
					_innerRadii.push(radius - _lineWidth * 0.5);
				}
			} else {
				for each (radius in _cornerRadii) {
					_outerRadii.push(radius);
					_innerRadii.push(radius - _lineWidth);
				}
			}
		}
		
		
		
		
		
		//---------------------------------------
		// path
		//---------------------------------------
		override protected function _getOuterPath():GraphicsPath {
			return _getPath(_outer, _outerRadii);
		}
		override protected function _getInnerPath():GraphicsPath {
			return _getPath(_inner, _innerRadii);
		}
		protected function _getPath(rect:Rectangle, radii:Array):GraphicsPath {
			var path:GraphicsPath = new GraphicsPath();
			var points:Array;
			
			path.moveTo(rect.right, rect.top + radii[3]);
			
			path.lineTo(rect.right, rect.bottom - radii[0]);
			
			points = _getPoints(
				rect.right - radii[0], rect.bottom - radii[0], radii[0], 0
			);
			path.curveTo(points[0], points[1], points[2], points[3]);
			path.curveTo(points[4], points[5], points[6], points[7]);
			
			path.lineTo(rect.left + radii[1], rect.bottom);
			
			points = _getPoints(
				rect.left + radii[1], rect.bottom - radii[1], radii[1], 1
			);
			path.curveTo(points[0], points[1], points[2], points[3]);
			path.curveTo(points[4], points[5], points[6], points[7]);
			
			path.lineTo(rect.left, rect.top + radii[2]);
			
			points = _getPoints(
				rect.left + radii[2], rect.top + radii[2], radii[2], 2
			);
			path.curveTo(points[0], points[1], points[2], points[3]);
			path.curveTo(points[4], points[5], points[6], points[7]);
			
			path.lineTo(rect.right - radii[3], rect.top);
			
			points = _getPoints(
				rect.right - radii[3], rect.top + radii[3], radii[3], 3
			);
			path.curveTo(points[0], points[1], points[2], points[3]);
			path.curveTo(points[4], points[5], points[6], points[7]);
			
			return path;
		}
		protected function _getPoints(x:Number, y:Number, r:Number, i:int):Array {
			var sx:int = (i === 0 || i === 3) ? 1 : -1;
			var sy:int = (i === 0 || i === 1) ? 1 : -1;
			
			var points:Array = [
				[x + r * sx,                 y                         ],
				[x + r * sx,                 y + r * ELLIPSE_RATIO * sy],
				[x + r * Math.SQRT1_2 * sx,  y + r * Math.SQRT1_2 * sy ],
				[x + r * ELLIPSE_RATIO * sx, y + r * sy                ],
				[x,                          y + r * sy                ]
			];
			
			if (i % 2 !== 0) {
				points.reverse();
			}
			points.shift();
			
			return [].concat.apply(null, points);
		}
	}
}