/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.shape {
	import flash.display.GraphicsPath;
	import flash.geom.Rectangle;
	
	
	
	
	
	public class Rect extends ShapeBase {
		override protected function _getOuterPath():GraphicsPath {
			return _getPath(_outer);
		}
		override protected function _getInnerPath():GraphicsPath {
			return _getPath(_inner);
		}
		protected function _getPath(rect:Rectangle):GraphicsPath {
			var path:GraphicsPath = new GraphicsPath();
			path.moveTo(rect.left,  rect.top);
			path.lineTo(rect.right, rect.top);
			path.lineTo(rect.right, rect.bottom);
			path.lineTo(rect.left,  rect.bottom);
			path.lineTo(rect.left,  rect.top);
			return path;
		}
	}
}