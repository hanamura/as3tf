/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.containers {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import org.typefest.core.Arr;
	import org.typefest.data.AEvent;
	import org.typefest.data.AList;
	import org.typefest.data.AListChange;
	import org.typefest.events.AltEvent;
	
	
	
	
	
	internal class Stack extends Container {
		///// items
		protected var _items:AList = null;
		
		public function get items():AList { return _items }
		
		
		
		///// container
		protected var _container:Sprite = null;
		
		
		
		///// margin
		protected var _marginLeft:Number   = 0;
		protected var _marginRight:Number  = 0;
		protected var _marginTop:Number    = 0;
		protected var _marginBottom:Number = 0;
		protected var _marginInside:Number = 0;
		
		public function get marginLeft():Number { return _marginLeft }
		public function set marginLeft(_:Number):void {
			if (_marginLeft !== _) {
				_marginLeft = _;
				_arrange();
				_checkStackSize();
			}
		}
		public function get marginRight():Number { return _marginRight }
		public function set marginRight(_:Number):void {
			if (_marginRight !== _) {
				_marginRight = _;
				_arrange();
				_checkStackSize();
			}
		}
		public function get marginTop():Number { return _marginTop }
		public function set marginTop(_:Number):void {
			if (_marginTop !== _) {
				_marginTop = _;
				_arrange();
				_checkStackSize();
			}
		}
		public function get marginBottom():Number { return _marginBottom }
		public function set marginBottom(_:Number):void {
			if (_marginBottom !== _) {
				_marginBottom = _;
				_arrange();
				_checkStackSize();
			}
		}
		public function get marginInside():Number { return _marginInside }
		public function set marginInside(_:Number):void {
			if (_marginInside !== _) {
				_marginInside = _;
				_arrange();
				_checkStackSize();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Stack() {
			super();
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			_items = new AList();
			_items.addEventListener(AEvent.CHANGE, _itemsChange);
			
			_container = new Sprite();
			addChild(_container);
			
			_onInit();
		}
		protected function _onInit():void {}
		
		
		
		
		
		//---------------------------------------
		// items change
		//---------------------------------------
		protected function _itemsChange(e:AEvent):void {
			var change:AListChange = e.change as AListChange;
			var adds:Array         = Arr.subtract(change.curr, change.prev);
			var removes:Array      = Arr.subtract(change.prev, change.curr);
			var item:DisplayObject;
			
			for each (item in adds) {
				_container.addChild(item);
				item.addEventListener(AltEvent.RESIZE, _itemResize, false, 0, true);
			}
			for each (item in removes) {
				_container.removeChild(item);
				item.removeEventListener(AltEvent.RESIZE, _itemResize, false);
			}
			
			_arrange();
			_checkStackSize();
		}
		
		
		
		
		
		//---------------------------------------
		// item resize
		//---------------------------------------
		protected function _itemResize(e:AltEvent):void {
			_arrange();
			_checkStackSize();
		}
		
		
		
		
		
		//---------------------------------------
		// arrange
		//---------------------------------------
		protected function _arrange():void {
			var item:DisplayObject;
			
			///// unlisten
			for each (item in _items) {
				item.removeEventListener(AltEvent.RESIZE, _itemResize, false);
			}
			
			_arrangeItems();
			
			///// listen
			for each (item in _items) {
				item.addEventListener(AltEvent.RESIZE, _itemResize, false);
			}
		}
		protected function _arrangeItems():void {
			///// override
		}
		
		
		
		
		
		
		//---------------------------------------
		// check height
		//---------------------------------------
		protected function _checkStackSize():void {
			///// override
		}
		
		
		
		
		
		//---------------------------------------
		// get height
		//---------------------------------------
		protected function _getStackSize():Number {
			///// override
			
			return 0;
		}
	}
}