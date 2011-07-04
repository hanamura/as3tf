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
	
	
	
	
	
	public class Ellipse extends ShapeBase {
		///// ellipse ratio
		private static const ELLIPSE_RATIO:Number = Math.SQRT2 - 1;
		
		
		
		
		
		//---------------------------------------
		// path
		//---------------------------------------
		override protected function _getOuterPath():GraphicsPath {
			return _getPath(_outer);
		}
		override protected function _getInnerPath():GraphicsPath {
			return _getPath(_inner);
		}
		protected function _getPath(rect:Rectangle):GraphicsPath {
			var x:Number = rect.x + rect.width * 0.5;
			var y:Number = rect.y + rect.height * 0.5;
			var w:Number = rect.width * 0.5;
			var h:Number = rect.height * 0.5;
			
			var path:GraphicsPath = new GraphicsPath();
			path.moveTo(x + w, y);
			
			var sx:int
			var sy:int;
			var points:Array;
			
			for (var i:int = 0; i < 4; i++) {
				sx = (i === 0 || i === 3) ? 1 : -1;
				sy = (i === 0 || i === 1) ? 1 : -1;
				
				points = [
					[x + w * sx,                 y                         ],
					[x + w * sx,                 y + h * ELLIPSE_RATIO * sy],
					[x + w * Math.SQRT1_2 * sx,  y + h * Math.SQRT1_2 * sy ],
					[x + w * ELLIPSE_RATIO * sx, y + h * sy                ],
					[x,                          y + h * sy                ]
				];
				
				if (i % 2 !== 0) {
					points.reverse();
				}
				points.shift();
				
				path.curveTo.apply(null, [].concat(points[0], points[1]));
				path.curveTo.apply(null, [].concat(points[2], points[3]));
			}

			return path;
		}
	}
}