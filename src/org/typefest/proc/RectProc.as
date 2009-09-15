/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.proc {
	import flash.errors.IllegalOperationError;
	
	public class RectProc extends Proc {
		private var __positionedFunc:Function = null;
		private var __sizedFunc:Function      = null;
		
		//---------------------------------------
		// position
		//---------------------------------------
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		
		public function get x():Number {
			return _x;
		}
		public function set x(x:Number):void {
			setPosition(x, _y);
		}
		public function get y():Number {
			return _y;
		}
		public function set y(y:Number):void {
			setPosition(_x, y);
		}
		
		//---------------------------------------
		// size
		//---------------------------------------
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		public function get width():Number {
			return _width;
		}
		public function set width(width:Number):void {
			setSize(width, _height);
		}
		public function get height():Number {
			return _height;
		}
		public function set height(height:Number):void {
			setSize(_width, height);
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function RectProc() {
			super();
		}
		
		//---------------------------------------
		// position
		//---------------------------------------
		protected function _defaultPositioned():void {
			// override this method
			if (state === Proc.PROCESSING) {
				throw new IllegalOperationError("Illegal timing.");
			}
		}
		public function setPosition(x:Number, y:Number):void {
			var some:Boolean = false;
			
			if (_x !== x) {
				_x = x;
				some = true;
			}
			if (_y !== y) {
				_y = y;
				some = true;
			}
			
			if (some) {
				if (__positionedFunc !== null) {
					var fn:Function = __positionedFunc;
					_drop();
					fn();
				} else {
					_drop();
					_defaultPositioned();
				}
			}
		}
		public function positioned(fn:Function):void {
			__positionedFunc = fn;
		}
		
		//---------------------------------------
		// size
		//---------------------------------------
		protected function _defaultSized():void {
			// override this method
			if (state === Proc.PROCESSING) {
				throw new IllegalOperationError("Illegal timing.");
			}
		}
		public function setSize(width:Number, height:Number):void {
			var some:Boolean = false;
			
			if (_width !== width) {
				_width = width;
				some = true;
			}
			if (_height !== height) {
				_height = height;
				some = true;
			}
			
			if (some) {
				if (__sizedFunc !== null) {
					var fn:Function = __sizedFunc;
					_drop();
					fn();
				} else {
					_drop();
					_defaultSized();
				}
			}
		}
		public function sized(fn:Function):void {
			__sizedFunc = fn;
		}
		
		//---------------------------------------
		// drop
		//---------------------------------------
		override protected function _drop():void {
			super._drop();
			
			__positionedFunc = null;
			__sizedFunc      = null;
		}
	}
}