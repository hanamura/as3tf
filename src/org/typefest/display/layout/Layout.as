/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.layout {
	import flash.geom.Rectangle;
	
	
	
	
	
	public class Layout extends Object {
		//---------------------------------------
		// show all
		//---------------------------------------
		static public function showAll(
			area:Rectangle,
			target:Rectangle,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			var rect:Rectangle = target.clone();
			
			if (rect.width > 0 && rect.height > 0) {
				var areaRatio:Number   = area.width / area.height;
				var targetRatio:Number = target.width / target.height;
				
				if (areaRatio > targetRatio) {
					rect.width  = target.width * (area.height / target.height);
					rect.height = area.height;
				} else if (areaRatio < targetRatio) {
					rect.width  = area.width;
					rect.height = target.height * (area.width / target.width);
				} else {
					rect.width  = area.width;
					rect.height = area.height;
				}
			}
			
			return noScale(area, rect, positionX, positionY);
		}
		
		
		
		
		
		//---------------------------------------
		// no border
		//---------------------------------------
		static public function noBorder(
			area:Rectangle,
			target:Rectangle,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			var rect:Rectangle = target.clone();
			
			if (rect.width > 0 && rect.height > 0) {
				var areaRatio:Number   = area.width / area.height;
				var targetRatio:Number = target.width / target.height;

				if (areaRatio > targetRatio) {
					rect.width  = area.width;
					rect.height = target.height * (area.width / target.width);
				} else if (areaRatio < targetRatio) {
					rect.width  = target.width * (area.height / target.height);
					rect.height = area.height;
				} else {
					rect.width  = area.width;
					rect.height = area.height;
				}
			}
			
			return noScale(area, rect, positionX, positionY);
		}
		
		
		
		
		
		//---------------------------------------
		// no scale
		//---------------------------------------
		static public function noScale(
			area:Rectangle,
			target:Rectangle,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			var rect:Rectangle = target.clone();
			
			rect.x = area.x + ((area.width - rect.width) * positionX);
			rect.y = area.y + ((area.height - rect.height) * positionY);
			
			return rect;
		}
		
		
		
		
		
		//---------------------------------------
		// exact fit
		//---------------------------------------
		static public function exactFit(
			area:Rectangle,
			target:Rectangle,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			return area.clone();
		}
		
		
		
		
		
		//---------------------------------------
		// wallup
		//---------------------------------------
		static public function wallup(
			area:Rectangle,
			target:Rectangle,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			if (target.width > area.width || target.height > area.height) {
				return showAll(area, target, positionX, positionY);
			} else {
				return noScale(area, target, positionX, positionY);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// margin
		//---------------------------------------
		static public function margin(
			layout:Function,
			left:Number   = 0,
			right:Number  = 0,
			top:Number    = 0,
			bottom:Number = 0
		):Function {
			var _:Rectangle = new Rectangle();
			
			return function(
				area:Rectangle,
				target:Rectangle,
				positionX:Number = 0.5,
				positionY:Number = 0.5
			):Rectangle {
				_.left   = area.left   + left;
				_.right  = area.right  - right;
				_.top    = area.top    + top;
				_.bottom = area.bottom - bottom;
				return layout(_, target, positionX, positionY);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// scale
		//---------------------------------------
		static public function scale(
			layout:Function,
			left:Number   = 0,
			right:Number  = 0,
			top:Number    = 0,
			bottom:Number = 0
		):Function {
			var _:Rectangle = new Rectangle();
			
			return function(
				area:Rectangle,
				target:Rectangle,
				positionX:Number = 0.5,
				positionY:Number = 0.5
			):Rectangle {
				_.width  = area.width * (1 - (left + right));
				_.height = area.height * (1 - (top + bottom));
				_.x      = area.x + (area.width * left);
				_.y      = area.y + (area.height * top);
				return layout(_, target, positionX, positionY);
			}
		}
	}
}