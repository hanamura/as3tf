/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.gui {
	public class Checkbox extends Button {
		///// selected
		protected var _selected:Boolean = false;
		
		public function get selected():Boolean { return _selected }
		public function set selected(bool:Boolean):void {
			if (_selected !== bool) {
				_selected = bool;
				_onSelected();
				dispatchEvent(new GUIEvent(GUIEvent.SELECT, false, false));
			}
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Checkbox() {
			super();
		}
		
		
		
		
		
		//---------------------------------------
		// on select
		//---------------------------------------
		protected function _onSelected():void {}
	}
}