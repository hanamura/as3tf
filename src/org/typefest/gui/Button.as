/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.gui {
	import org.typefest.display.containers.Container;
	import org.typefest.interaction.over.Over;
	import org.typefest.interaction.press.Press;
	
	
	
	
	
	public class Button extends Container {
		///// data
		protected var _data:* = null;
		
		public function get data():* { return _data }
		public function set data(_:*):void { _data = _ }
		
		
		
		///// over
		protected var _over:Over   = null;
		protected var _press:Press = null;
		
		public function get over():Over { return _over }
		public function get press():Press { return _press }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Button() {
			super();
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			buttonMode    = true;
			useHandCursor = true;
			mouseEnabled  = true;
			mouseChildren = false;
			
			_over  = new Over(this);
			_press = new Press(this);
			
			_onInit();
		}
		protected function _onInit():void {}
	}
}