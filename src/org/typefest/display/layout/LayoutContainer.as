/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.layout {
	import org.typefest.display.containers.Container;
	import org.typefest.events.AltEvent;
	
	
	
	
	
	public class LayoutContainer extends Container implements ILayout {
		///// identity
		static public function identity(_:Number):Number { return _ }
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// layout group
		protected var _setter:LayoutSetter = null;
		
		public function get setter():LayoutSetter { return _setter }
		
		
		
		///// layout size
		protected var _layoutWidth:Number  = 0;
		protected var _layoutHeight:Number = 0;
		
		public function get layoutWidth():Number { return _layoutWidth }
		public function set layoutWidth(_:Number):void {
			if (_layoutWidth !== _) {
				_layoutWidth = _;
				_updateLayout();
			}
		}
		public function get layoutHeight():Number { return _layoutHeight }
		public function set layoutHeight(_:Number):void {
			if (_layoutHeight !== _) {
				_layoutHeight = _;
				_updateLayout();
			}
		}
		
		
		
		///// layout method
		protected var _layoutMethod:Function = null;
		
		public function get layoutMethod():Function {
			return _layoutMethod || Layout.exactFit;
		}
		public function set layoutMethod(_:Function):void {
			if (_layoutMethod !== _) {
				_layoutMethod = _;
				_updateLayout();
			}
		}
		
		
		
		///// filter position
		protected var _filterPosition:Function = null;
		
		public function get filterPosition():Function {
			return _filterPosition || identity;
		}
		public function set filterPosition(_:Function):void {
			if (_filterPosition !== _) {
				_filterPosition = _;
				_updateLayout();
			}
		}
		
		
		
		///// filter size
		protected var _filterSize:Function = null;
		
		public function get filterSize():Function {
			return _filterSize || identity;
		}
		public function set filterSize(_:Function):void {
			if (_filterSize !== _) {
				_filterSize = _;
				_updateLayout();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function LayoutContainer() {
			super();
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			_setter = new LayoutSetter();
			
			_onInit();
		}
		protected function _onInit():void {}
		
		
		
		
		
		//---------------------------------------
		// resize
		//---------------------------------------
		override protected function _resize():void {
			_setter.setSize(width, height);
			
			super._resize();
		}
		
		
		
		
		
		//---------------------------------------
		// set layout size
		//---------------------------------------
		public function setLayoutSize(width:Number, height:Number):void {
			if (_layoutWidth !== width || _layoutHeight !== height) {
				_layoutWidth  = width;
				_layoutHeight = height;
				_updateLayout();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// update layout
		//---------------------------------------
		protected function _updateLayout():void {
			_onLayout();
			dispatchEvent(new AltEvent(AltEvent.LAYOUT));
		}
		protected function _onLayout():void {}
	}
}