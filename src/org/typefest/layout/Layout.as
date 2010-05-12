/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	import flash.geom.Rectangle;
	
	import org.typefest.namespaces.untyped;
	
	public class Layout extends Object {
		static public function toRectangle(_:*):Rectangle {
			return new Rectangle(_.x, _.y, _.width, _.height);
		}
		
		//---------------------------------------
		// showAll
		//---------------------------------------
		static public function showAll(
			area:Rectangle,
			target:Rectangle,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			var rect:Rectangle = target.clone();
			
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
			
			return noScale(area, rect, positionX, positionY);
		}
		static untyped function showAll(
			area:*,
			target:*,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			return showAll(
				toRectangle(area),
				toRectangle(target),
				positionX,
				positionY
			);
		}
		
		//---------------------------------------
		// noBorder
		//---------------------------------------
		static public function noBorder(
			area:Rectangle,
			target:Rectangle,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			var rect:Rectangle = target.clone();
			
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
			
			return noScale(area, rect, positionX, positionY);
		}
		static untyped function noBorder(
			area:*,
			target:*,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			return noBorder(
				toRectangle(area),
				toRectangle(target),
				positionX,
				positionY
			);
		}
		
		//---------------------------------------
		// noScale
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
		static untyped function noScale(
			area:*,
			target:*,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			return noScale(
				toRectangle(area),
				toRectangle(target),
				positionX,
				positionY
			);
		}
		
		//---------------------------------------
		// exactFit
		//---------------------------------------
		static public function exactFit(
			area:Rectangle,
			target:Rectangle,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			return area.clone();
		}
		static untyped function exactFit(
			area:*,
			target:*,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			return toRectangle(area);
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
		static untyped function wallup(
			area:*,
			target:*,
			positionX:Number,
			positionY:Number
		):Rectangle {
			return wallup(
				toRectangle(area),
				toRectangle(target),
				positionX,
				positionY
			);
		}
		
		//---------------------------------------
		// scale by x/y
		//---------------------------------------
		static public function scaleByX(
			area:Rectangle,
			target:Rectangle,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			var rect:Rectangle = target.clone();
			
			rect.width  = area.width;
			rect.height = target.height * (area.width / target.width);
			
			return noScale(area, rect, positionX, positionY);
		}
		
		static public function scaleByY(
			area:Rectangle,
			target:Rectangle,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			var rect:Rectangle = target.clone();
			
			rect.width  = target.width * (area.height / target.height);
			rect.height = area.height;
			
			return noScale(area, rect, positionX, positionY);
		}
		
		//---------------------------------------
		// fit x/y
		//---------------------------------------
		static public function fitX(
			area:Rectangle,
			target:Rectangle,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			var rect:Rectangle = target.clone();
			rect.width = area.width;
			
			return noScale(area, rect, positionX, positionY);
		}
		
		static public function fitY(
			area:Rectangle,
			target:Rectangle,
			positionX:Number = 0.5,
			positionY:Number = 0.5
		):Rectangle {
			var rect:Rectangle = target.clone();
			rect.height = area.height;
			
			return noScale(area, rect, positionX, positionY);
		}
		
		//---------------------------------------
		// Margin
		//---------------------------------------
		static public function margin(
			layout:Function,
			left:Number   = 0,
			right:Number  = 0,
			top:Number    = 0,
			bottom:Number = 0
		):Function {
			var _area:Rectangle = new Rectangle();
			return function(
				area:Rectangle,
				target:Rectangle,
				positionX:Number = 0.5,
				positionY:Number = 0.5
			):Rectangle {
				_area.left   = area.left   + left;
				_area.right  = area.right  - right;
				_area.top    = area.top    + top;
				_area.bottom = area.bottom - bottom;
				return layout(_area, target, positionX, positionY);
			}
		}
		
		//---------------------------------------
		// Scale
		//---------------------------------------
		static public function scale(
			layout:Function,
			left:Number   = 0,
			right:Number  = 0,
			top:Number    = 0,
			bottom:Number = 0
		):Function {
			var _area:Rectangle = new Rectangle();
			return function(
				area:Rectangle,
				target:Rectangle,
				positionX:Number = 0.5,
				positionY:Number = 0.5
			):Rectangle {
				_area.width  = area.width * (1 - (left + right));
				_area.height = area.height * (1 - (top + bottom));
				_area.x      = area.x + (area.width * left);
				_area.y      = area.y + (area.height * top);
				return layout(_area, target, positionX, positionY);
			}
		}
		
		//---------------------------------------
		// apply
		//---------------------------------------
		static public function apply(rect:Rectangle, target:*):void {
			target.x      = rect.x;
			target.y      = rect.y;
			target.width  = rect.width;
			target.height = rect.height;
		}
		static public function applyFloored(rect:Rectangle, target:*):void {
			target.x      = Math.floor(rect.x);
			target.y      = Math.floor(rect.y);
			target.width  = Math.floor(rect.width);
			target.height = Math.floor(rect.height);
		}
		static public function applyPosition(rect:Rectangle, target:*):void {
			target.x = rect.x;
			target.y = rect.y;
		}
		static public function applySize(rect:Rectangle, target:*):void {
			target.width  = rect.width;
			target.height = rect.height;
		}
		static public function applyPositionFloored(rect:Rectangle, target:*):void {
			target.x = Math.floor(rect.x);
			target.y = Math.floor(rect.y);
		}
		static public function applySizeFloored(rect:Rectangle, target:*):void {
			target.width  = Math.floor(rect.width);
			target.height = Math.floor(rect.height);
		}
	}
}