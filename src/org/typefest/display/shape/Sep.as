/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.shape {
	import org.typefest.data.AData;
	import org.typefest.data.an;
	
	dynamic public class Sep extends AData {
		static public const ABSOLUTE:String = "Sep.ABSOLUTE";
		static public const RELATIVE:String = "Sep.RELATIVE";
		
		static public const HORIZONTAL:String = "Sep.HORIZONTAL";
		static public const VERTICAL:String   = "Sep.VERTICAL";
		
		public function Sep(
			direction:String = "Sep.HORIZONTAL",
			position:Number  = 0,
			type:String      = "Sep.ABSOLUTE",
			color:uint       = 0x000000,
			alpha:Number     = 1,
			width:Number     = 1,
			origin:Number    = 0,
			hook:Function    = null
		) {
			super();
			
			an::set("direction", direction);
			an::set("position",  position);
			an::set("type",      type);
			an::set("color",     color);
			an::set("alpha",     alpha);
			an::set("width",     width);
			an::set("origin",    origin);
			an::set("hook",      hook);
		}
	}
}