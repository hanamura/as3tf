/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.containers {
	import flash.display.Sprite;
	
	import org.typefest.events.AltEvent;
	
	
	
	
	
	public class Container extends Sprite implements IRepresent {
		///// size
		protected var _width:Number  = 0;
		protected var _height:Number = 0;
		
		override public function get width():Number { return _width }
		override public function set width(_:Number):void {
			if (_width !== _) {
				_width = _;
				_resize();
			}
		}
		override public function get height():Number { return _height }
		override public function set height(_:Number):void {
			if (_height !== _) {
				_height = _;
				_resize();
			}
		}
		
		
		
		///// position
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		
		override public function get x():Number { return _x }
		override public function set x(_:Number):void {
			if (_x !== _) {
				_x = _;
				_reposition();
			}
		}
		override public function get y():Number { return _y }
		override public function set y(_:Number):void {
			if (_y !== _) {
				_y = _;
				_reposition();
			}
		}
		
		
		
		///// alpha
		protected var _alpha:Number = 1;
		
		override public function get alpha():Number { return _alpha }
		override public function set alpha(_:Number):void {
			if (_alpha !== _) {
				_alpha = _;
				_updateAlpha();
			}
		}
		
		
		
		///// visible
		override public function set visible(_:Boolean):void {
			if (super.visible !== _) {
				super.visible = _;
				_updateVisible();
			}
		}
		
		
		
		///// interaction
		override public function set mouseEnabled(_:Boolean):void {
			if (super.mouseEnabled !== _) {
				super.mouseEnabled = _;
				_updateInteraction();
			}
		}
		override public function set mouseChildren(_:Boolean):void {
			if (super.mouseChildren !== _) {
				super.mouseChildren = _;
				_updateInteraction();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Container() {
			super();
		}
		
		
		
		
		
		//---------------------------------------
		// set size
		//---------------------------------------
		public function setSize(width:Number, height:Number):void {
			if (_width !== width || _height !== height) {
				_width  = width;
				_height = height;
				_resize();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// resize
		//---------------------------------------
		protected function _resize():void {
			_onResize();
			dispatchEvent(new AltEvent(AltEvent.RESIZE));
		}
		protected function _onResize():void {}
		
		
		
		
		
		//---------------------------------------
		// set position
		//---------------------------------------
		public function setPosition(x:Number, y:Number):void {
			if (_x !== x || _y !== y) {
				_x = x;
				_y = y;
				_reposition();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// reposition
		//---------------------------------------
		protected function _reposition():void {
			super.x = _x;
			super.y = _y;
			
			_onReposition();
			dispatchEvent(new AltEvent(AltEvent.REPOSITION));
		}
		protected function _onReposition():void {}
		
		
		
		
		
		//---------------------------------------
		// update alpha
		//---------------------------------------
		protected function _updateAlpha():void {
			super.alpha = _alpha;
			
			_onAlpha();
			dispatchEvent(new AltEvent(AltEvent.ALPHA));
		}
		protected function _onAlpha():void {}
		
		
		
		
		
		//---------------------------------------
		// update visible
		//---------------------------------------
		protected function _updateVisible():void {
			_onVisible();
			dispatchEvent(new AltEvent(AltEvent.VISIBLE));
		}
		protected function _onVisible():void {}
		
		
		
		
		
		//---------------------------------------
		// update interaction
		//---------------------------------------
		protected function _updateInteraction():void {
			_onInteraction();
			dispatchEvent(new AltEvent(AltEvent.INTERACTION));
		}
		protected function _onInteraction():void {}
	}
}