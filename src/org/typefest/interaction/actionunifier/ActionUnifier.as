/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.actionunifier {
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	
	import org.typefest.data.AEvent;
	import org.typefest.data.ASetChange;
	import org.typefest.display.DocumentScanner;
	
	
	
	
	
	public class ActionUnifier extends DocumentScanner {
		///// mode
		protected var _mode:String         = null;
		protected var _internalMode:String = null;
		
		public function get mode():String { return _mode }
		public function set mode(str:String):void {
			if ([ActionMode.AUTO, ActionMode.TOUCH, ActionMode.MOUSE].indexOf(str) < 0) {
				throw new ArgumentError();
			}
			
			if (_mode !== str) {
				_mode = str;
				_modeChange();
			}
		}
		public function get internalMode():String { return _internalMode }
		
		
		
		///// types
		protected var _downType:String  = null;
		protected var _upType:String    = null;
		protected var _overType:String  = null;
		protected var _outType:String   = null;
		protected var _clickType:String = null;
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function ActionUnifier(target:InteractiveObject, mode:String = "auto") {
			this.mode = mode;
			
			super(target);
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		override protected function _init():void {
			addEventListener(AEvent.CHANGE, _change);
			
			super._init();
		}
		
		
		
		
		
		//---------------------------------------
		// mode change
		//---------------------------------------
		protected function _modeChange():void {
			var mode:String;
			
			if (_mode === ActionMode.AUTO) {
				if (Multitouch.supportsTouchEvents) {
					mode = ActionMode.TOUCH;
				} else {
					mode = ActionMode.MOUSE;
				}
			} else {
				mode = _mode;
			}
			
			if (_internalMode !== mode) {
				_internalMode = mode;
				
				///// o
				var o:DisplayObject;
				var io:InteractiveObject;
				
				///// remove
				for each (o in this) {
					io = o as InteractiveObject;
					
					if (io) {
						io.removeEventListener(_downType,  _dispatchDown,  false);
						io.removeEventListener(_upType,    _dispatchUp,    false);
						io.removeEventListener(_overType,  _dispatchOver,  false);
						io.removeEventListener(_outType,   _dispatchOut,   false);
						io.removeEventListener(_clickType, _dispatchClick, false);
					}
				}
				
				///// types
				if (mode === ActionMode.TOUCH) {
					_downType  = TouchEvent.TOUCH_BEGIN;
					_upType    = TouchEvent.TOUCH_END;
					_overType  = TouchEvent.TOUCH_ROLL_OVER;
					_outType   = TouchEvent.TOUCH_ROLL_OUT;
					_clickType = TouchEvent.TOUCH_TAP;
				} else if (mode === ActionMode.MOUSE) {
					_downType  = MouseEvent.MOUSE_DOWN;
					_upType    = MouseEvent.MOUSE_UP;
					_overType  = MouseEvent.ROLL_OVER;
					_outType   = MouseEvent.ROLL_OUT;
					_clickType = MouseEvent.CLICK;
				}
				
				///// add
				for each (o in this) {
					io = o as InteractiveObject;
					
					if (io) {
						io.addEventListener(_downType,  _dispatchDown,  false, 0, true);
						io.addEventListener(_upType,    _dispatchUp,    false, 0, true);
						io.addEventListener(_overType,  _dispatchOver,  false, 0, true);
						io.addEventListener(_outType,   _dispatchOut,   false, 0, true);
						io.addEventListener(_clickType, _dispatchClick, false, 0, true);
					}
				}
			}
		}
		
		
		
		
		
		//---------------------------------------
		// change
		//---------------------------------------
		protected function _change(e:AEvent):void {
			var change:ASetChange = e.change as ASetChange;
			var o:DisplayObject;
			var io:InteractiveObject;
			
			for each (o in change.adds) {
				io = o as InteractiveObject;
				
				if (io) {
					io.addEventListener(_downType,  _dispatchDown,  false, 0, true);
					io.addEventListener(_upType,    _dispatchUp,    false, 0, true);
					io.addEventListener(_overType,  _dispatchOver,  false, 0, true);
					io.addEventListener(_outType,   _dispatchOut,   false, 0, true);
					io.addEventListener(_clickType, _dispatchClick, false, 0, true);
				}
			}
			for each (o in change.removes) {
				io = o as InteractiveObject;
				
				if (io) {
					io.removeEventListener(_downType,  _dispatchDown,  false);
					io.removeEventListener(_upType,    _dispatchUp,    false);
					io.removeEventListener(_overType,  _dispatchOver,  false);
					io.removeEventListener(_outType,   _dispatchOut,   false);
					io.removeEventListener(_clickType, _dispatchClick, false);
				}
			}
		}
		
		
		
		
		
		//---------------------------------------
		// listeners
		//---------------------------------------
		protected function _dispatchDown(e:Event):void { _fire(e, ActionEvent.DOWN) }
		protected function _dispatchUp(e:Event):void { _fire(e, ActionEvent.UP) }
		protected function _dispatchOver(e:Event):void { _fire(e, ActionEvent.OVER) }
		protected function _dispatchOut(e:Event):void { _fire(e, ActionEvent.OUT) }
		protected function _dispatchClick(e:Event):void { _fire(e, ActionEvent.CLICK) }
		
		
		
		
		
		//---------------------------------------
		// dispatch
		//---------------------------------------
		protected function _fire(e:Event, type:String):void {
			var t:TouchEvent = e as TouchEvent;
			
			if (t && !t.isPrimaryTouchPoint) { return }
			if (e.bubbles && e.currentTarget !== e.target) { return }
			
			e.currentTarget.dispatchEvent(
				new ActionEvent(
					type,
					e.bubbles,
					e.cancelable,
					e["localX"],
					e["localY"],
					e["relatedObject"],
					e["ctrlKey"],
					e["altKey"],
					e["shiftKey"]
				)
			);
		}
	}
}