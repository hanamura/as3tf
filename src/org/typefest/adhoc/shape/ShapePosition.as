/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.adhoc.shape {
	public class ShapePosition extends Object {
		static public const LEFT:uint   = 0;
		static public const CENTER:uint = 1;
		static public const RIGHT:uint  = 2;
		
		static public const TOP:uint    = 4;
		static public const MIDDLE:uint = 8;
		static public const BOTTOM:uint = 12;
		
		static public const TOP_LEFT:uint      = TOP    | LEFT;
		static public const TOP_CENTER:uint    = TOP    | CENTER;
		static public const TOP_RIGHT:uint     = TOP    | RIGHT;
		static public const MIDDLE_LEFT:uint   = MIDDLE | LEFT;
		static public const MIDDLE_CENTER:uint = MIDDLE | CENTER;
		static public const MIDDLE_RIGHT:uint  = MIDDLE | RIGHT;
		static public const BOTTOM_LEFT:uint   = BOTTOM | LEFT;
		static public const BOTTOM_CENTER:uint = BOTTOM | CENTER;
		static public const BOTTOM_RIGHT:uint  = BOTTOM | RIGHT;
		
		static public function posX(pos:uint):uint {
			return pos % 4;
		}
		
		static public function posY(pos:uint):uint {
			return (pos >> 2) << 2;
		}
		
		static public function toString(pos:uint):String {
			var posX:uint = pos % 4;
			var posY:uint = (pos >> 2) << 2;
			
			var r:String = "";
			
			if (posY === TOP) {
				r += "TOP";
			} else if (posY === MIDDLE) {
				r += "MIDDLE";
			} else if (posY === BOTTOM) {
				r += "BOTTOM";
			} else {
				r += "INVALIDPOSY";
			}
			
			r += "_";
			
			if (posX === LEFT) {
				r += "LEFT";
			} else if (posX === CENTER) {
				r += "CENTER";
			} else if (posX === RIGHT) {
				r += "RIGHT";
			} else {
				r += "INVALIDPOSX";
			}
			
			return r;
		}
	}
}