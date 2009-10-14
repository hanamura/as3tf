/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	import flash.errors.IllegalOperationError;
	
	public class MarginArea extends Area {
		//---------------------------------------
		// margins
		//---------------------------------------
		protected var _left:Number   = 0;
		protected var _right:Number  = 0;
		protected var _top:Number    = 0;
		protected var _bottom:Number = 0;

		public function get left():Number {
			return _left;
		}
		public function set left(x:Number):void {
			if (_left !== x) {
				_left = x;
				_updateLayoutFunction();
			}
		}
		public function get right():Number {
			return _right;
		}
		public function set right(x:Number):void {
			if (_right !== x) {
				_right = x;
				_updateLayoutFunction();
			}
		}
		public function get top():Number {
			return _top;
		}
		public function set top(x:Number):void {
			if (_top !== x) {
				_top = x;
				_updateLayoutFunction();
			}
		}
		public function get bottom():Number {
			return _bottom;
		}
		public function set bottom(x:Number):void {
			if (_bottom !== x) {
				_bottom = x;
				_updateLayoutFunction();
			}
		}
		
		//---------------------------------------
		// base layout function
		//---------------------------------------
		protected var _baseLayout:Function = Layout.exactFit;
		
		public function get baseLayout():Function {
			return _baseLayout;
		}
		public function set baseLayout(x:Function):void {
			if (_baseLayout !== x) {
				_baseLayout = x;
				_updateLayoutFunction();
			}
		}
		
		//---------------------------------------
		// override
		//---------------------------------------
		override public function set layout(x:Function):void {
			throw new IllegalOperationError("Cannot set layout.");
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function MarginArea(
			x:Number      = 0,
			y:Number      = 0,
			width:Number  = 0,
			height:Number = 0
		) {
			super(x, y, width, height);
			
			_updateLayoutFunction();
		}
		
		//---------------------------------------
		// shortcut
		//---------------------------------------
		public function setMargin(
			left:Number,
			right:Number,
			top:Number,
			bottom:Number
		):void {
			var some:Boolean = false;
			
			if (_left !== left) {
				_left = left;
				some = true;
			}
			if (_right !== right) {
				_right = right;
				some = true;
			}
			if (_top !== top) {
				_top = top;
				some = true;
			}
			if (_bottom !== bottom) {
				_bottom = bottom;
				some = true;
			}
			
			if (some) {
				_updateLayoutFunction();
			}
		}
		
		//---------------------------------------
		// update
		//---------------------------------------
		protected function _updateLayoutFunction():void {
			_layout = Layout.margin(_baseLayout, _left, _right, _top, _bottom);
			_updateByParent();
		}
	}
}