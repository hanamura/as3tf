/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.text {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.engine.TextLine;
	
	import flashx.textLayout.container.ContainerController;
	
	import org.typefest.data.AEvent;
	import org.typefest.data.AList;
	import org.typefest.display.containers.Container;
	import org.typefest.events.AltEvent;
	
	
	
	
	
	public class TextBound extends Container {
		///// controller
		protected var _controller:ContainerController = null;
		
		public function get controller():ContainerController { return _controller }
		
		
		
		///// container
		public function get container():Sprite { return this }
		
		
		
		///// composition size
		protected var _compositionWidth:Number  = 0;
		protected var _compositionHeight:Number = 0;
		
		public function get compositionWidth():Number { return _compositionWidth }
		public function set compositionWidth(_:Number):void {
			if (_compositionWidth !== _) {
				_compositionWidth = _;
				_resizeComposition();
			}
		}
		public function get compositionHeight():Number { return _compositionHeight }
		public function set compositionHeight(_:Number):void {
			if (_compositionHeight !== _) {
				_compositionHeight = _;
				_resizeComposition();
			}
		}
		
		
		
		///// lines
		protected var _lines:AList = null;
		
		public function get lines():AList { return _lines }
		
		
		
		///// size
		override public function set width(_:Number):void {}
		override public function set height(_:Number):void {}
		override public function setSize(w:Number, h:Number):void {}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function TextBound(width:Number = 0, height:Number = 0) {
			super();
			
			_compositionWidth  = width;
			_compositionHeight = height;
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			_lines = new AList();
			_lines.addEventListener(AEvent.CHANGE, _linesChange);
			
			_controller = new ContainerController(
				container,
				_compositionWidth,
				_compositionHeight
			);
			
			container.addEventListener(Event.ADDED, _added);
			container.addEventListener(Event.REMOVED, _removed);
			
			_onInit();
		}
		protected function _onInit():void {}
		
		
		
		
		
		//---------------------------------------
		// set composition size
		//---------------------------------------
		public function setCompositionSize(width:Number, height:Number):void {
			if (_compositionWidth !== width || _compositionHeight !== height) {
				_compositionWidth  = width;
				_compositionHeight = height;
				_resizeComposition();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// resize composition
		//---------------------------------------
		protected function _resizeComposition():void {
			_controller.setCompositionSize(_compositionWidth, _compositionHeight);
			_onResizeComposition();
			dispatchEvent(new TextBoundEvent(TextBoundEvent.RESIZE_COMPOSITION));
		}
		protected function _onResizeComposition():void {}
		
		
		
		
		
		//---------------------------------------
		// added / removed
		//---------------------------------------
		protected function _added(e:Event):void {
			if (e.target.parent === container && e.target is TextLine) {
				_lines.push(e.target);
			}
		}
		protected function _removed(e:Event):void {
			if (e.target.parent === container && e.target is TextLine) {
				_lines.splice(_lines.indexOf(e.target), 1);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// lines change
		//---------------------------------------
		protected function _linesChange(e:AEvent):void {
			_checkSize();
		}
		
		
		
		
		
		//---------------------------------------
		// check size
		//---------------------------------------
		protected function _checkSize():void {
			var size:Point = _getSize();
			
			if (_width !== size.x || _height !== size.y) {
				_width  = size.x;
				_height = size.y;
				_resize();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// get size
		//---------------------------------------
		protected function _getSize():Point {
			if (_lines.length) {
				var line:TextLine  = _lines[0];
				var rect:Rectangle = line.getBounds(this);
				
				for each (line in _lines.slice(1)) {
					rect = rect.union(line.getBounds(this));
				}
				
				return new Point(rect.right, rect.bottom);
			} else {
				return new Point(0, 0);
			}
		}
	}
}