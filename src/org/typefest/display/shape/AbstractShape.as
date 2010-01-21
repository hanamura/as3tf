/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.shape {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	
	import org.typefest.display.Container;
	
	public class AbstractShape extends Container {
		static public function selectBeginFill(
			args:Array,
			graphics:Graphics
		):Function {
			var a:* = args[0];
			if (a is BitmapData) {
				return graphics.beginBitmapFill;
			} else if (a is String) {
				return graphics.beginGradientFill;
			} else {
				return null;
			}
		}
		
		//---------------------------------------
		// Fill Color
		//---------------------------------------
		protected var _fill:uint = 0xffffff;

		public function get fill():uint {
			return _fill;
		}
		public function set fill(x:uint):void {
			if(_fill !== x) {
				_fill = x;
				_updateColor();
			}
		}
		
		public function get fillR():uint {
			return _fill >> 16;
		}
		public function set fillR(x:uint):void {
			if (x !== _fill >> 16) {
				_fill = (x << 16) | (_fill % 65536);
				_updateColor();
			}
		}
		
		public function get fillG():uint {
			return (_fill >> 8) % 256;
		}
		public function set fillG(x:uint):void {
			if (x !== (_fill >> 8) % 256) {
				_fill = ((_fill >> 16) << 16) | (x << 8) | (_fill % 256);
				_updateColor();
			}
		}
		
		public function get fillB():uint {
			return _fill % 256;
		}
		public function set fillB(x:uint):void {
			if (x !== _fill % 256) {
				_fill = ((_fill >> 8) << 8) | x;
				_updateColor();
			}
		}
		
		protected var _fillAlpha:Number = 1;

		public function get fillAlpha():Number {
			return _fillAlpha;
		}
		public function set fillAlpha(x:Number):void {
			if(_fillAlpha !== x) {
				_fillAlpha = x;
				_updateColor();
			}
		}
		
		//---------------------------------------
		// Fill Advanced Arguments (beginBitmapFill or beginGradientFill)
		//---------------------------------------
		protected var _fillArgs:Array = null;
		
		public function get fillArgs():Array {
			return _fillArgs && _fillArgs.concat();
		}
		public function set fillArgs(x:Array):void {
			if (_fillArgs || x) {
				_fillArgs = x && x.concat();
				_updateColor();
			}
		}
		
		//---------------------------------------
		// Fill Option
		//---------------------------------------
		protected var _fillEnabled:Boolean = true;

		public function get fillEnabled():Boolean {
			return _fillEnabled;
		}
		public function set fillEnabled(x:Boolean):void {
			if(_fillEnabled !== x) {
				_fillEnabled = x;
				_updateForm();
			}
		}
		
		//---------------------------------------
		// Line Color
		//---------------------------------------
		protected var _line:uint = 0x000000;

		public function get line():uint {
			return _line;
		}
		public function set line(x:uint):void {
			if(_line !== x) {
				_line = x;
				_updateColor();
			}
		}
		
		public function get lineR():uint {
			return _line >> 16;
		}
		public function set lineR(x:uint):void {
			if (x !== _line >> 16) {
				_line = (x << 16) | (_line % 65536);
				_updateColor();
			}
		}
		
		public function get lineG():uint {
			return (_line >> 8) % 256;
		}
		public function set lineG(x:uint):void {
			if (x !== (_line >> 8) % 256) {
				_line = ((_line >> 16) << 16) | (x << 8) | (_line % 256);
				_updateColor();
			}
		}
		
		public function get lineB():uint {
			return _line % 256;
		}
		public function set lineB(x:uint):void {
			if (x !== _line % 256) {
				_line = ((_line >> 8) << 8) | x;
				_updateColor();
			}
		}
		
		protected var _lineAlpha:Number = 1;

		public function get lineAlpha():Number {
			return _lineAlpha;
		}
		public function set lineAlpha(x:Number):void {
			if(_lineAlpha !== x) {
				_lineAlpha = x;
				_updateColor();
			}
		}
		
		//---------------------------------------
		// Line Advanced Arguments (beginBitmapFill or beginGradientFill)
		//---------------------------------------
		protected var _lineArgs:Array = null;
		
		public function get lineArgs():Array {
			return _lineArgs && _lineArgs.concat();
		}
		public function set lineArgs(x:Array):void {
			if (_lineArgs || x) {
				_lineArgs = x && x.concat();
				_updateColor();
			}
		}
		
		//---------------------------------------
		// Line Option
		//---------------------------------------
		protected var _lineWidth:Number = 0;

		public function get lineWidth():Number {
			return _lineWidth;
		}
		public function set lineWidth(x:Number):void {
			if(_lineWidth !== x) {
				_lineWidth = x;
				_updateForm();
			}
		}
		
		protected var _lineSide:String = LineSide.INSIDE;

		public function get lineSide():String {
			return _lineSide;
		}
		public function set lineSide(x:String):void {
			if(_lineSide !== x) {
				_lineSide = x;
				_updateForm();
			}
		}
		
		//---------------------------------------
		// Position
		//---------------------------------------
		protected var _positionX:Number = 0;
		
		public function get positionX():Number {
			return _positionX;
		}
		public function set positionX(x:Number):void {
			if (_positionX !== x) {
				_positionX = x;
				_updatePosition();
			}
		}
		
		protected var _positionY:Number = 0;
		
		public function get positionY():Number {
			return _positionY;
		}
		public function set positionY(x:Number):void {
			if (_positionY !== x) {
				_positionY = x;
				_updatePosition();
			}
		}
		
		//---------------------------------------
		// Graphics
		//---------------------------------------
		protected var _graphics:Graphics = null;
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function AbstractShape() {
			super();
			_graphics = graphics;
		}
		
		//---------------------------------------
		// Update
		//---------------------------------------
		protected function _updateForm():void {}
		
		protected function _updatePosition():void {}
		
		protected function _updateColor():void {}
		
		override protected function _update():void {
			_updateForm();
		}
	}
}