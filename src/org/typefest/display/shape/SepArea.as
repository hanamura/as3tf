/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.shape {
	import org.typefest.data.AEvent;
	import org.typefest.data.AList;
	import org.typefest.display.Container;
	
	public class SepArea extends Container {
		protected var _seps:AList = null;

		public function get seps():AList {
			return _seps;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function SepArea() {
			super();
			
			_seps = new AList();
			_seps.addEventListener(AEvent.CHANGE, _sepsChange);
		}
		
		protected function _sepsChange(e:AEvent):void {
			_update();
		}
		
		override protected function _update():void {
			graphics.clear();
			
			if (width > 0 && height > 0) {
				var sx:Number, sy:Number, swidth:Number, sheight:Number;
				
				for each (var sep:Sep in seps) {
					if (sep.direction === Sep.VERTICAL) {
						sy      = 0;
						swidth  = sep.width;
						sheight = height;
						
						if (sep.type === Sep.ABSOLUTE) {
							sx = sep.position;
						} else {
							sx = sep.position * width
						}
						sx -= swidth * sep.origin;
						
						if (sep.hook) {
							sx = sep.hook(sx);
						}
					} else {
						sx      = 0;
						swidth  = width;
						sheight = sep.width;
						
						if (sep.type === Sep.ABSOLUTE) {
							sy = sep.position;
						} else {
							sy = sep.position * height;
						}
						sy -= sheight * sep.origin;
						
						if (sep.hook) {
							sy = sep.hook(sy);
						}
					}
					
					graphics.beginFill(sep.color, sep.alpha);
					graphics.drawRect(sx, sy, swidth, sheight);
					graphics.endFill();
				}
			}
		}
	}
}