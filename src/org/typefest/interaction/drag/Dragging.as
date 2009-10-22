/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.drag {
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.typefest.interaction.drag.DraggingEvent;
	import org.typefest.proc.Proc;
	
	public class Dragging extends Proc {
		protected var _target:InteractiveObject = null;
		protected var _immediate:Boolean        = false;
		
		protected var _stage:Stage = null;
		
		protected var _targetPoint:Point     = null;
		protected var _targetMouse:Point     = null;
		protected var _stageMouse:Point      = null;
		protected var _lastTargetMouse:Point = null;
		protected var _lastStageMouse:Point  = null;
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Dragging(target:InteractiveObject, immediate:Boolean = false) {
			super();
			
			_target    = target;
			_immediate = immediate;
			
			fire();
		}
		
		override protected function _defaultStopped():void {
			_end();
		}
		
		override protected function _start():void {
			if (_immediate) {
				_down();
			} else {
				listen(_target, MouseEvent.MOUSE_DOWN, _down);
			}
		}
		
		//---------------------------------------
		// down
		//---------------------------------------
		protected function _down(e:MouseEvent = null):void {
			_stage = _target.stage;
			
			_targetPoint     = new Point(_target.x, _target.y);
			_targetMouse     = new Point(_target.mouseX, _target.mouseY);
			_stageMouse      = new Point(_stage.mouseX, _stage.mouseY);
			_lastTargetMouse = new Point(_target.mouseX, _target.mouseY);
			_lastStageMouse  = new Point(_stage.mouseX, _stage.mouseY);
			
			_dispatch(DraggingEvent.CATCH);
			
			_check();
		}
		
		protected function _check():void {
			_lastTargetMouse = new Point(_target.mouseX, _target.mouseY);
			_lastStageMouse  = new Point(_stage.mouseX, _stage.mouseY);
			
			if (_test()) {
				_startDrag();
			} else {
				sleep("1", _check);
				listen(_stage, MouseEvent.MOUSE_UP, _upIgnore);
			}
		}
		
		//---------------------------------------
		// escape
		//---------------------------------------
		protected function _upIgnore(e:MouseEvent):void {
			listen(_target, MouseEvent.MOUSE_DOWN, _down);
			
			_dispatch(DraggingEvent.RELEASE);
			
			_targetMouse = null;
			_stageMouse  = null;
			_stage       = null;
		}
		
		//---------------------------------------
		// dragging
		//---------------------------------------
		protected function _startDrag():void {
			_targetPoint     = new Point(_target.x, _target.y);
			_targetMouse     = new Point(_target.mouseX, _target.mouseY);
			_stageMouse      = new Point(_stage.mouseX, _stage.mouseY);
			_lastTargetMouse = _targetMouse.clone();
			_lastStageMouse  = _stageMouse.clone();
			
			listen(_stage, MouseEvent.MOUSE_UP, _up);
			
			_dispatch(DraggingEvent.START);
			
			_drag();
		}
		
		protected function _drag():void {
			sleep("1", _drag);
			listen(_stage, MouseEvent.MOUSE_UP, _up);
			
			var targetMouse:Point = new Point(_target.mouseX, _target.mouseY);
			var stageMouse:Point  = new Point(_stage.mouseX, _stage.mouseY);
			
			if (
				   !_lastTargetMouse.equals(targetMouse)
				|| !_lastStageMouse.equals(stageMouse)
			) {
				_lastTargetMouse = targetMouse;
				_lastStageMouse  = stageMouse;
				
				_dispatch(DraggingEvent.DRAG);
			}
		}
		
		protected function _up(e:MouseEvent):void {
			_stage = null;
			
			listen(_target, MouseEvent.MOUSE_DOWN, _down);
			
			_dispatch(DraggingEvent.END);
		}
		
		
		//---------------------------------------
		// shortcut
		//---------------------------------------
		protected function _dispatch(type:String):void {
			var event:Event = new DraggingEvent(
				type,
				false,
				false,
				_targetPoint,
				_targetMouse,
				_stageMouse,
				_lastTargetMouse,
				_lastStageMouse,
				_target,
				this
			);
			
			_target.dispatchEvent(event.clone());
			dispatchEvent(event.clone());
		}
		
		//---------------------------------------
		// test
		//---------------------------------------
		protected function _test():Boolean {
			return true;
		}
	}
}