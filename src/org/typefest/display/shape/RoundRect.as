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
	
	
	
	
	
	public class RoundRect extends ShapeBase {
		///// ellipse ratio
		private static const ELLIPSE_RATIO:Number = Math.SQRT2 - 1;
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		protected var _cornerRadius:Number = 0;
		protected var _outerRadius:Number  = 0;
		protected var _innerRadius:Number  = 0;
		
		public function get cornerRadius():Number { return _cornerRadius }
		public function set cornerRadius(_:Number):void {
			if (_cornerRadius !== _) {
				_cornerRadius = _;
				_updateBounds();
				_render();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// update bounds
		//---------------------------------------
		override protected function _updateBounds():void {
			super._updateBounds();
			
			var outerMax:Number = Math.min(_outer.width, _outer.height) * 0.5;
			var innerMax:Number = Math.min(_inner.width, _inner.height) * 0.5;
			
			if (_lineSide === LineSide.OUTSIDE) {
				_outerRadius = Math.min(_cornerRadius + _lineWidth, outerMax);
				_innerRadius = Math.min(_cornerRadius, innerMax);
			} else if (_lineSide === LineSide.CENTER) {
				_outerRadius = Math.min(_cornerRadius + _lineWidth * 0.5, outerMax);
				_innerRadius = Math.min(_cornerRadius - _lineWidth * 0.5, innerMax);
			} else { ///// LineSide.INSIDE
				_outerRadius = Math.min(_cornerRadius, outerMax);
				_innerRadius = Math.min(_cornerRadius - _lineWidth, innerMax);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// path
		//---------------------------------------
		override protected function _getOuterPath():GraphicsPath {
			return _getPath(_outer, _outerRadius);
		}
		override protected function _getInnerPath():GraphicsPath {
			return _getPath(_inner, _innerRadius);
		}
		protected function _getPath(rect:Rectangle, r:Number):GraphicsPath {
			var path:GraphicsPath = new GraphicsPath();
			var points:Array;
			
			path.moveTo(rect.right, rect.top + r);
			
			path.lineTo(rect.right, rect.bottom - r);
			
			points = _getPoints(rect.right - r, rect.bottom - r, r, 0);
			path.curveTo(points[0], points[1], points[2], points[3]);
			path.curveTo(points[4], points[5], points[6], points[7]);
			
			path.lineTo(rect.left + r, rect.bottom);
			
			points = _getPoints(rect.left + r, rect.bottom - r, r, 1);
			path.curveTo(points[0], points[1], points[2], points[3]);
			path.curveTo(points[4], points[5], points[6], points[7]);
			
			path.lineTo(rect.left, rect.top + r);
			
			points = _getPoints(rect.left + r, rect.top + r, r, 2);
			path.curveTo(points[0], points[1], points[2], points[3]);
			path.curveTo(points[4], points[5], points[6], points[7]);
			
			path.lineTo(rect.right - r, rect.top);
			
			points = _getPoints(rect.right - r, rect.top + r, r, 3);
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