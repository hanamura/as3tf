/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.layout {
	import flash.geom.Rectangle;
	
	import org.typefest.core.Arr;
	import org.typefest.data.AEvent;
	import org.typefest.data.ASet;
	import org.typefest.data.ASetChange;
	import org.typefest.display.containers.IRepresent;
	import org.typefest.events.AltEvent;
	
	
	
	
	
	public class LayoutSetter extends ASet implements IRepresent {
		///// size
		protected var _width:Number  = 0;
		protected var _height:Number = 0;
		
		public function get width():Number { return _width }
		public function set width(_:Number):void {
			if (_width !== _) {
				_width = _;
				_resize();
			}
		}
		public function get height():Number { return _height }
		public function set height(_:Number):void {
			if (_height !== _) {
				_height = _;
				_resize();
			}
		}
		
		
		
		///// position
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		
		public function get x():Number { return _x }
		public function set x(_:Number):void {
			if (_x !== _) {
				_x = _;
				_reposition();
			}
		}
		public function get y():Number { return _y }
		public function set y(_:Number):void {
			if (_y !== _) {
				_y = _;
				_reposition();
			}
		}
		
		
		
		///// followers
		protected var _followers:ASet = null;
		
		public function get followers():ASet { return _followers }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function LayoutSetter() {
			super();
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			_followers = new ASet();
			_followers.addEventListener(AEvent.CHANGE, _followersChange);
			
			addEventListener(AEvent.CHANGE, _itemsChange);
			
			_onInit();
		}
		protected function _onInit():void {}
		
		
		
		
		
		//---------------------------------------
		// items change
		//---------------------------------------
		protected function _itemsChange(e:AEvent):void {
			var change:ASetChange = e.change as ASetChange;
			var item:ILayout;
			
			for each (item in change.adds) {
				item.addEventListener(AltEvent.LAYOUT, _itemLayout, false, 0, true);
				_updateItem(item);
			}
			for each (item in change.removes) {
				item.removeEventListener(AltEvent.LAYOUT, _itemLayout, false);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// item layout
		//---------------------------------------
		protected function _itemLayout(e:AltEvent):void {
			_updateItem(e.currentTarget as ILayout);
		}
		
		
		
		
		
		//---------------------------------------
		// update item
		//---------------------------------------
		protected function _updateItem(item:ILayout):void {
			var rect:Rectangle = item.layoutMethod(
				new Rectangle(x, y, width, height),
				new Rectangle(0, 0, item.layoutWidth, item.layoutHeight)
			);
			
			item.setPosition(
				item.filterPosition(rect.x),
				item.filterPosition(rect.y)
			);
			item.setSize(
				item.filterSize(rect.width),
				item.filterSize(rect.height)
			);
		}
		
		
		
		
		
		//---------------------------------------
		// followers change
		//---------------------------------------
		protected function _followersChange(e:AEvent):void {
			var change:ASetChange = e.change as ASetChange;
			
			for each (var follower:* in change.adds) {
				_updateFollower(follower);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// update follower
		//---------------------------------------
		protected function _updateFollower(follower:*):void {
			if (follower is IRepresent) {
				follower.setPosition(x, y);
				follower.setSize(width, height);
			} else {
				follower.x      = x;
				follower.y      = y;
				follower.width  = width;
				follower.height = height;
			}
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
			for each (var item:ILayout in this) {
				_updateItem(item);
			}
			for each (var follower:* in _followers) {
				_updateFollower(follower);
			}
			
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
			for each (var item:ILayout in this) {
				_updateItem(item);
			}
			for each (var follower:* in _followers) {
				_updateFollower(follower);
			}
			
			_onReposition();
			dispatchEvent(new AltEvent(AltEvent.REPOSITION));
		}
		protected function _onReposition():void {}
	}
}