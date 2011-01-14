/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.actionunifier {
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import org.typefest.data.AEvent;
	import org.typefest.data.ASet;
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
		protected var _downType:String     = null;
		protected var _upType:String       = null;
		protected var _overType:String     = null;
		protected var _outType:String      = null;
		protected var _rollOverType:String = null;
		protected var _rollOutType:String  = null;
		protected var _moveType:String     = null;
		protected var _clickType:String    = null;
		
		
		
		///// types
		protected var _types:ASet = null;
		
		public function get types():ASet { return _types }
		
		
		
		
		
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
			
			_types = new ASet([
				ActionEvent.DOWN,
				ActionEvent.UP,
				ActionEvent.OVER,
				ActionEvent.OUT,
				ActionEvent.ROLL_OVER,
				ActionEvent.ROLL_OUT,
				ActionEvent.MOVE,
				ActionEvent.CLICK
			]);
			_types.addEventListener(Event.CHANGE, _typesChange);
			
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
					io && _unlistenIO(io);
				}
				
				///// types
				if (mode === ActionMode.TOUCH) {
					_downType     = TouchEvent.TOUCH_BEGIN;
					_upType       = TouchEvent.TOUCH_END;
					_overType     = TouchEvent.TOUCH_OVER;
					_outType      = TouchEvent.TOUCH_OUT;
					_rollOverType = TouchEvent.TOUCH_ROLL_OVER;
					_rollOutType  = TouchEvent.TOUCH_ROLL_OUT;
					_moveType     = TouchEvent.TOUCH_MOVE;
					_clickType    = TouchEvent.TOUCH_TAP;
				} else if (mode === ActionMode.MOUSE) {
					_downType     = MouseEvent.MOUSE_DOWN;
					_upType       = MouseEvent.MOUSE_UP;
					_overType     = MouseEvent.MOUSE_OVER;
					_outType      = MouseEvent.MOUSE_OUT;
					_rollOverType = MouseEvent.ROLL_OVER;
					_rollOutType  = MouseEvent.ROLL_OUT;
					_moveType     = MouseEvent.MOUSE_MOVE;
					_clickType    = MouseEvent.CLICK;
				}
				
				///// add
				for each (o in this) {
					io = o as InteractiveObject;
					io && _listenIO(io);
				}
				
				///// Multitouch.inputMode
				if (mode === ActionMode.TOUCH) {
					Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				} else if (mode === ActionMode.MOUSE) {
					Multitouch.inputMode = MultitouchInputMode.NONE;
				}
			}
		}
		
		
		
		
		
		//---------------------------------------
		// update availability
		//---------------------------------------
		protected function _typesChange(e:AEvent):void {
			var io:InteractiveObject;
			
			for each (var o:DisplayObject in this) {
				io = o as InteractiveObject;
				io && _unlistenIO(io);
				io && _listenIO(io);
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
				io && _listenIO(io);
			}
			for each (o in change.removes) {
				io = o as InteractiveObject;
				io && _unlistenIO(io);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// listen / unlisten
		//---------------------------------------
		protected function _listenIO(io:InteractiveObject):void {
			_types.has(ActionEvent.DOWN)      && io.addEventListener(_downType,     _fireDown,     false, 0, true);
			_types.has(ActionEvent.UP)        && io.addEventListener(_upType,       _fireUp,       false, 0, true);
			_types.has(ActionEvent.OVER)      && io.addEventListener(_overType,     _fireOver,     false, 0, true);
			_types.has(ActionEvent.OUT)       && io.addEventListener(_outType,      _fireOut,      false, 0, true);
			_types.has(ActionEvent.ROLL_OVER) && io.addEventListener(_rollOverType, _fireRollOver, false, 0, true);
			_types.has(ActionEvent.ROLL_OUT)  && io.addEventListener(_rollOutType,  _fireRollOut,  false, 0, true);
			_types.has(ActionEvent.MOVE)      && io.addEventListener(_moveType,     _fireMove,     false, 0, true);
			_types.has(ActionEvent.CLICK)     && io.addEventListener(_clickType,    _fireClick,    false, 0, true);
		}
		protected function _unlistenIO(io:InteractiveObject):void {
			io.removeEventListener(_downType,     _fireDown,     false);
			io.removeEventListener(_upType,       _fireUp,       false);
			io.removeEventListener(_overType,     _fireOver,     false);
			io.removeEventListener(_outType,      _fireOut,      false);
			io.removeEventListener(_rollOverType, _fireRollOver, false);
			io.removeEventListener(_rollOutType,  _fireRollOut,  false);
			io.removeEventListener(_moveType,     _fireMove,     false);
			io.removeEventListener(_clickType,    _fireClick,    false);
		}
		
		
		
		
		
		//---------------------------------------
		// listeners
		//---------------------------------------
		protected function _fireDown(e:Event):void     { _fire(e, ActionEvent.DOWN) }
		protected function _fireUp(e:Event):void       { _fire(e, ActionEvent.UP) }
		protected function _fireOver(e:Event):void     { _fire(e, ActionEvent.OVER) }
		protected function _fireOut(e:Event):void      { _fire(e, ActionEvent.OUT) }
		protected function _fireRollOver(e:Event):void { _fire(e, ActionEvent.ROLL_OVER) }
		protected function _fireRollOut(e:Event):void  { _fire(e, ActionEvent.ROLL_OUT) }
		protected function _fireMove(e:Event):void     { _fire(e, ActionEvent.MOVE) }
		protected function _fireClick(e:Event):void    { _fire(e, ActionEvent.CLICK) }
		
		
		
		
		
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