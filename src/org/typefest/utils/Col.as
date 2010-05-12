/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.utils {
	public class Col {
		
		// public static function hexToRGB(hex:String):int {
		// 	var ext:RegExp = /^#?([0-9a-f]{6})$/i;
		// 	
		// 	var $:* = ext.exec(hex);
		// 	
		// 	if($) {
		// 		return parseInt("0x" + $[1]);
		// 	} else {
		// 		return 0x000000;
		// 	}
		// }
		
		public static function splitRGB(color:uint):Array {
			return [color >> 16, (color >> 8) % 256, color % 256];
		}
		
		public static function joinRGB(red:int, green:int, blue:int):int {
			return (red << 16) | (green << 8) | (blue << 0);
		}
		
		/*
		*	via http://d.hatena.ne.jp/flashrod/20060930/1159622027
		*	
		*	int: 0 to 255
		*	*/
		public static function rgbToHSB(red:int, green:int, blue:int):Array {
			var cmax:Number = Math.max(red, green, blue);
			var cmin:Number = Math.min(red, green, blue);
			var brightness:Number = cmax / 255;
			var hue:Number        = 0;
			var saturation:Number = (cmax != 0) ? ((cmax - cmin) / cmax) : 0;
			if(saturation != 0) {
				var redc:Number   = (cmax - red) / (cmax - cmin);
				var greenc:Number = (cmax - green) / (cmax - cmin);
				var bluec:Number  = (cmax - blue) / (cmax - cmin);
				if(red == cmax) {
					hue = bluec - greenc;
				} else if(green == cmax) {
					hue = 2 + redc - bluec;
				} else {
					hue = 4 + greenc - redc;
				}
				hue = hue / 6;
				if(hue < 0) {
					hue = hue + 1;
				}
			}
			return [hue, saturation, brightness];
		}
		
		/*
		*	via http://d.hatena.ne.jp/flashrod/20060930/1159622027
		*	
		*	Number: 0 to 1
		*	*/
		public static function hsbToRGB(
			hue:Number, saturation:Number, brightness:Number
		):Array {
			var red:int   = 0;
			var green:int = 0;
			var blue:int  = 0;
			if(saturation == 0) {
				red = green = blue = brightness * 255 + 0.5;
			} else {
				var h:Number = (hue - Math.floor(hue)) * 6;
				var f:Number = h - Math.floor(h);
				var p:Number = brightness * (1 - saturation);
				var q:Number = brightness * (1 - (saturation * f));
				var t:Number = brightness * (1 - (saturation * (1 - f)));
				switch(int(h)) {
					case 0:
						red   = brightness * 255 + 0.5;
						green = t * 255 + 0.5;
						blue  = p * 255 + 0.5;
						break;
					case 1:
						red   = q * 255 + 0.5;
						green = brightness * 255 + 0.5;
						blue  = p * 255 + 0.5;
						break;
					case 2:
						red   = p * 255 + 0.5;
						green = brightness * 255 + 0.5;
						blue  = t * 255 + 0.5;
						break;
					case 3:
						red   = p * 255 + 0.5;
						green = q * 255 + 0.5;
						blue  = brightness * 255 + 0.5;
						break;
					case 4:
						red   = t * 255 + 0.5;
						green = p * 255 + 0.5;
						blue  = brightness * 255 + 0.5;
						break;
					case 5:
						red   = brightness * 255 + 0.5;
						green = p * 255 + 0.5;
						blue  = q * 255 + 0.5;
						break;
				}
			}
			return [red, green, blue];
		}
	}
}