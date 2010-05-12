/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	public class BaseRect extends EventDispatcher {
		protected var _rect:Rectangle = null;
		
		public function get rect():Rectangle {
			return _rect.clone();
		}
		
		//---------------------------------------
		// x y width height
		//---------------------------------------
		public function get x():Number {
			return _rect.x;
		}
		public function set x(x:Number):void {
			if (_rect.x !== x) {
				_rect.x = x;
				_update();
			}
		}
		public function get y():Number {
			return _rect.y;
		}
		public function set y(y:Number):void {
			if (_rect.y !== y) {
				_rect.y = y;
				_update();
			}
		}
		public function get width():Number {
			return _rect.width;
		}
		public function set width(width:Number):void {
			if (_rect.width !== width) {
				_rect.width = width;
				_update();
			}
		}
		public function get height():Number {
			return _rect.height;
		}
		public function set height(height:Number):void {
			if (_rect.height !== height) {
				_rect.height = height;
				_update();
			}
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function BaseRect(
			x:Number      = 0,
			y:Number      = 0,
			width:Number  = 0,
			height:Number = 0
		) {
			super();
			
			_rect = new Rectangle(x, y, width, height);
		}
		
		public function set(x:Number, y:Number, width:Number, height:Number):void {
			var some:Boolean = false;
			
			if (_rect.x !== x) {
				_rect.x = x;
				some = true;
			}
			if (_rect.y !== y) {
				_rect.y = y;
				some = true;
			}
			if (_rect.width !== width) {
				_rect.width = width;
				some = true;
			}
			if (_rect.height !== height) {
				_rect.height = height;
				some = true;
			}
			
			if (some) {
				_update();
			}
		}
		
		protected function _update():void {}
	}
}