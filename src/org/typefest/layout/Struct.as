/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	import flash.geom.Rectangle;
	
	public class Struct extends BaseRect implements IPositionable {
		protected var _layout:Function = null;
		public function get layout():Function { return _layout; }
		public function set layout(x:Function):void { _layout = x; }

		protected var _original:Rectangle = null;
		public function get original():Rectangle { return _original; }
		public function set original(x:Rectangle):void { _original = x; }

		protected var _positionX:Number = 0;
		public function get positionX():Number { return _positionX; }
		public function set positionX(x:Number):void { _positionX = x; }

		protected var _positionY:Number = 0;
		public function get positionY():Number { return _positionY; }
		public function set positionY(x:Number):void { _positionY = x; }

		protected var _getPositionX:Function = null;
		public function get getPositionX():Function { return _getPositionX; }
		public function set getPositionX(x:Function):void { _getPositionX = x; }

		protected var _getPositionY:Function = null;
		public function get getPositionY():Function { return _getPositionY; }
		public function set getPositionY(x:Function):void { _getPositionY = x; }

		protected var _apply:Function = null;
		public function get apply():Function { return _apply; }
		public function set apply(x:Function):void { _apply = x; }

		public function get parentArea():Area { return null; }
		public function set parentArea(x:Area):void {}

		public function Struct(
			target:*,
			layout:*,
			original:Rectangle,
			positionX:*,
			positionY:*,
			apply:Function
		) {
			super();
			
			if (layout is Function) {
				_layout = layout;
			} else if (layout is String) {
				_layout = Layout[layout];
			} else {
				_layout = Layout.exactFit;
			}

			if (original) {
				_original = original.clone();
			} else {
				_original = Layout.toRectangle(target);
			}

			if (positionX is Number) {
				_positionX    = positionX;
				_getPositionX = null;
			} else if (positionX is Function) {
				_positionX    = NaN;
				_getPositionX = positionX;
			} else {
				_positionX    = Number(positionX);
				_getPositionX = null;
			}

			if (positionY is Number) {
				_positionY    = positionY;
				_getPositionY = null;
			} else if (positionY is Function) {
				_positionY    = NaN;
				_getPositionY = positionY;
			} else {
				_positionY    = Number(positionY);
				_getPositionY = null;
			}

			if (apply === null) {
				_apply = Layout.apply;
			} else {
				_apply = apply;
			}
		}
	}
}