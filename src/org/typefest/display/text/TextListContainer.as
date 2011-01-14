/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.text {
	import flash.display.DisplayObjectContainer;
	
	import flashx.textLayout.elements.TextFlow;
	
	import org.typefest.core.Arr;
	import org.typefest.data.AEvent;
	import org.typefest.data.AListChange;
	import org.typefest.display.containers.Container;
	
	
	
	
	
	public class TextListContainer extends Container {
		///// text flow
		protected var _list:TextList = null;
		
		public function get list():TextList { return _list }
		public function get textFlow():TextFlow { return _list.textFlow }
		public function set textFlow(_:TextFlow):void { _list.textFlow = _ }
		
		///// container
		public function get container():DisplayObjectContainer { return this }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function TextListContainer(textFlow:TextFlow = null) {
			super();
			
			_list = new TextList(textFlow);
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			_list.addEventListener(AEvent.CHANGE, _listChange);
			
			_onInit();
		}
		protected function _onInit():void {}
		
		
		
		
		
		//---------------------------------------
		// list change
		//---------------------------------------
		protected function _listChange(e:AEvent):void {
			var change:AListChange = e.change as AListChange;
			
			Arr.each(container.addChild, Arr.subtract(change.curr, change.prev));
			Arr.each(container.removeChild, Arr.subtract(change.prev, change.curr));
		}
	}
}