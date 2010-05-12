/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.adhoc {
	import flash.display.Sprite;
	
	public class Container extends Sprite {
		protected var _width:Number = 0;

		override public function get width():Number {
			return _width;
		}
		override public function set width(x:Number):void {
			if(_width !== x) {
				_width = x;
				_update();
			}
		}
		
		protected var _height:Number = 0;

		override public function get height():Number {
			return _height;
		}
		override public function set height(x:Number):void {
			if(_height !== x) {
				_height = x;
				_update();
			}
		}
		
		public function Container() {
			super();
		}
		
		public function setSize(width:Number, height:Number):void {
			var some:Boolean = false;
			
			if (width !== _width) {
				_width = width;
				some = true;
			}
			
			if (height !== _height) {
				_height = height;
				some = true;
			}
			
			if (some) {
				_update();
			}
		}
		
		protected function _update():void {}
	}
}