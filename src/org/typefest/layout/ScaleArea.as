/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	public class ScaleArea extends MarginArea {
		public function ScaleArea(
			x:Number      = 0,
			y:Number      = 0,
			width:Number  = 0,
			height:Number = 0
		) {
			super(x, y, width, height);
		}
		
		public function setScale(
			left:Number,
			right:Number,
			top:Number,
			bottom:Number
		):void {
			setMargin(left, right, top, bottom);
		}
		
		override protected function _updateLayoutFunction():void {
			_layout = Layout.scale(_baseLayout, _left, _right, _top, _bottom);
			_updateByParent();
		}
	}
}