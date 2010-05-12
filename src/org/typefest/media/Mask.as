/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.media {
	import org.typefest.display.Container;
	
	public class Mask extends Container {
		override protected function _update():void {
			graphics.clear();
			
			if (_width > 0 && _height > 0) {
				graphics.beginFill(0x000000);
				graphics.drawRect(0, 0, _width, _height);
				graphics.endFill();
			}
		}
	}
}