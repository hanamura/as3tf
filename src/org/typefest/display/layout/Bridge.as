/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.layout {
	import org.typefest.events.AltEvent;
	
	
	
	
	
	public class Bridge extends LayoutSetter {
		///// layout
		protected var _a:Pier = null;
		protected var _b:Pier = null;
		
		public function get a():Pier { return _a }
		public function get b():Pier { return _b }
		
		
		
		///// position
		override public function set x(_:Number):void {}
		override public function set y(_:Number):void {}
		override public function setPosition(x:Number, y:Number):void {}
		
		
		
		///// ratio
		protected var _ratio:Number = 0;
		
		public function get ratio():Number { return _ratio }
		public function set ratio(_:Number):void {
			if (_ratio !== _) {
				_ratio = _;
				_update();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Bridge() {
			super();
		}
		
		
		
		
		
		//---------------------------------------
		// on init
		//---------------------------------------
		override protected function _onInit():void {
			_a = new Pier();
			_b = new Pier();
			
			_a.addEventListener(AltEvent.REPOSITION, _nodeReposition);
			_b.addEventListener(AltEvent.REPOSITION, _nodeReposition);
		}
		
		
		
		
		
		//---------------------------------------
		// node reposition
		//---------------------------------------
		protected function _nodeReposition(e:AltEvent):void {
			_update();
		}
		
		
		
		
		
		//---------------------------------------
		// update
		//---------------------------------------
		protected function _update():void {
			var x:Number = _a.x + (_b.x - _a.x) * _ratio;
			var y:Number = _a.y + (_b.y - _a.y) * _ratio;
			
			if (_x !== x || _y !== y) {
				_x = x;
				_y = y;
				_reposition();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// on resize
		//---------------------------------------
		override protected function _onResize():void {
			_a.layout_internal::setLayoutSize(_width, _height);
			_b.layout_internal::setLayoutSize(_width, _height);
		}
	}
}