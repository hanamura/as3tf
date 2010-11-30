/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.guide {
	import flash.geom.Rectangle;
	
	import org.typefest.data.AData;
	import org.typefest.data.an;
	
	
	
	
	
	dynamic public class Guide extends AData implements IGuide {
		///// positionType
		static public const ABSOLUTE:String = "absolute";
		static public const RELATIVE:String = "relative";
		
		///// orientation
		static public const HORIZONTAL:String = "horizontal";
		static public const VERTICAL:String   = "vertical";
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Guide(init:* = null) {
			var def:* = {
				orientation  : HORIZONTAL,
				position     : 0,
				positionType : ABSOLUTE,
				color        : 0x000000,
				alpha        : 1,
				thickness    : 1,
				origin       : 0,
				filter       : null
			};
			
			if (init) {
				for (var key:String in def) {
					if (key in init) {
						def[key] = init[key];
					}
				}
			}
			
			super(def);
		}
		
		
		
		
		
		//---------------------------------------
		// interface
		//---------------------------------------
		public function getRectangle(area:Rectangle):Rectangle {
			var _:Rectangle = new Rectangle();
			var position:Number;
			
			if (an::get("orientation") === HORIZONTAL) {
				if (an::get("positionType") === ABSOLUTE) {
					position = an::get("position");
				} else if (an::get("positionType") === RELATIVE) {
					position = area.height * an::get("position");
				}
				position -= an::get("thickness") * an::get("origin");
				
				if (an::get("filter") is Function) {
					position = an::get("filter")(position);
				}
				
				_.x      = 0;
				_.y      = position;
				_.width  = area.width;
				_.height = an::get("thickness");
				
			} else if (an::get("orientation") === VERTICAL) {
				
				if (an::get("positionType") === ABSOLUTE) {
					position = an::get("position");
				} else if (an::get("positionType") === RELATIVE) {
					position = area.width * an::get("position");
				}
				position -= an::get("thickness") * an::get("origin");
				
				if (an::get("filter") is Function) {
					position = an::get("filter")(position);
				}
				
				_.x      = position;
				_.y      = 0;
				_.width  = an::get("thickness");
				_.height = area.height;
			}
			
			return _;
		}
		public function getColor():uint {
			return an::get("color");
		}
		public function getAlpha():Number {
			return an::get("alpha");
		}
	}
}