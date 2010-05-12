/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.adhoc.shape {
	import flash.geom.Rectangle;
	
	public class Ellipse extends Rect {
		public function Ellipse() {
			super();
		}
		
		override protected function _drawOuterShape():void {
			_graphics.drawEllipse(
				_outer.x,
				_outer.y,
				_outer.width,
				_outer.height
			);
		}
		
		override protected function _drawInnerShape():void {
			_graphics.drawEllipse(
				_inner.x,
				_inner.y,
				_inner.width,
				_inner.height
			);
		}
	}
}