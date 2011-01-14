/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.text {
	import flashx.textLayout.elements.TextFlow;
	
	
	
	
	
	public class TextBox extends TextBound {
		///// list
		protected var _list:TextList = null;
		
		public function get list():TextList { return _list }
		public function get textFlow():TextFlow { return _list.textFlow }
		public function set textFlow(_:TextFlow):void { _list.textFlow = _ }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function TextBox(
			textFlow:TextFlow = null,
			width:Number      = 0,
			height:Number     = 0
		) {
			_list = new TextList(textFlow);
			
			super(width, height);
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		override protected function _onInit():void {
			_list.push(this);
		}
	}
}