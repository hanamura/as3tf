/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.guide {
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import org.typefest.core.Arr;
	import org.typefest.data.AEvent;
	import org.typefest.data.AList;
	import org.typefest.data.AListChange;
	import org.typefest.display.containers.Container;
	
	
	
	
	
	public class GuideBase extends Container {
		///// items
		protected var _items:AList = null;
		
		public function get items():AList { return _items }
		
		///// shape
		protected var _shape:Shape = null;
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function GuideBase() {
			super();
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			_items = new AList();
			_items.depth = 0;
			_items.addEventListener(AEvent.CHANGE, _itemsChange);
			
			_shape = new Shape();
			addChild(_shape);
		}
		
		
		
		
		
		//---------------------------------------
		// items change
		//---------------------------------------
		protected function _itemsChange(e:AEvent):void {
			///// both _items and elements of _items
			var change:AListChange = e.change as AListChange;
			var adds:Array         = Arr.subtract(change.curr, change.prev);
			var removes:Array      = Arr.subtract(change.prev, change.curr);
			var item:IGuide;
			
			for each (item in adds) {
				item.addEventListener(AEvent.CHANGE, _itemChange, false, 0, true);
			}
			for each (item in removes) {
				item.removeEventListener(AEvent.CHANGE, _itemChange, false);
			}
			
			_draw();
		}
		
		
		
		
		
		//---------------------------------------
		// item change
		//---------------------------------------
		protected function _itemChange(e:AEvent):void {
			_draw();
		}
		
		
		
		
		
		//---------------------------------------
		// draw
		//---------------------------------------
		protected function _draw():void {
			_shape.graphics.clear();
			
			var area:Rectangle = new Rectangle(0, 0, width, height);
			var rect:Rectangle;
			var color:uint;
			var alpha:Number;
			
			for each (var item:IGuide in _items) {
				rect  = item.getRectangle(area);
				color = item.getColor();
				alpha = item.getAlpha();
				
				_shape.graphics.beginFill(color, alpha);
				_shape.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
				_shape.graphics.endFill();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// update
		//---------------------------------------
		override protected function _onResize():void {
			_draw();
		}
	}
}