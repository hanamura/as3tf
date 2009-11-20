/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class PositionableContainer extends Sprite implements IPositionable {
		protected var _area:Area = new Area();
		
		public function get area():Area {
			return _area;
		}
		
		//---------------------------------------
		// size
		//---------------------------------------
		protected var _width:Number  = 0;
		protected var _height:Number = 0;
		
		override public function get width():Number {
			return _width;
		}
		override public function set width(w:Number):void {
			if (_width !== w) {
				_width = w;
				_update();
			}
		}
		override public function get height():Number {
			return _height;
		}
		override public function set height(h:Number):void {
			if (_height !== h) {
				_height = h;
				_update();
			}
		}
		
		//---------------------------------------
		// main implementations
		//---------------------------------------
		protected var _layout:Function       = Layout.exactFit;
		protected var _original:Rectangle    = new Rectangle();
		protected var _positionX:Number      = 0;
		protected var _positionY:Number      = 0;
		protected var _getPositionX:Function = null;
		protected var _getPositionY:Function = null;
		protected var _apply:Function        = Layout.apply;
		
		public function get layout():Function {
			return _layout;
		}
		public function set layout(x:Function):void {
			if (_layout !== x) {
				_layout = x;
				_updateByParent();
			}
		}
		public function get original():Rectangle {
			return _original;
		}
		public function set original(x:Rectangle):void {
			if (_original !== x) {
				_original = x;
				_updateByParent();
			}
		}
		public function get positionX():Number {
			return _positionX;
		}
		public function set positionX(x:Number):void {
			if (_positionX !== x) {
				_positionX = x;
				_updateByParent();
			}
		}
		public function get positionY():Number {
			return _positionY;
		}
		public function set positionY(y:Number):void {
			if (_positionY !== y) {
				_positionY = y;
				_updateByParent();
			}
		}
		public function get getPositionX():Function {
			return _getPositionX;
		}
		public function set getPositionX(x:Function):void {
			if (_getPositionX !== x) {
				_getPositionX = x;
				_updateByParent();
			}
		}
		public function get getPositionY():Function {
			return _getPositionY;
		}
		public function set getPositionY(y:Function):void {
			if (_getPositionY !== y) {
				_getPositionY = y;
				_updateByParent();
			}
		}
		public function get apply():Function {
			return _apply;
		}
		public function set apply(x:Function):void {
			if (_apply !== x) {
				_apply = x;
				_updateByParent();
			}
		}
		
		//---------------------------------------
		// parentArea
		//---------------------------------------
		protected var _parentArea:Area = null;

		public function get parentArea():Area {
			return _parentArea;
		}
		public function set parentArea(x:Area):void {
			if (_parentArea !== x) {
				_parentArea = x;
			}
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function PositionableContainer() {
			super();
		}
		
		protected function _updateByParent():void {
			if (_parentArea) {
				_parentArea.update(this);
			}
		}
		
		protected function _update():void {
			_area.set(0, 0, _width, _height);
		}
	}
}