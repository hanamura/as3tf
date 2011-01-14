/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.drag {
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.typefest.interaction.Interaction;
	
	
	
	
	
	public class Drag extends Interaction {
		///// display objects
		protected var _parent:DisplayObjectContainer = null;
		protected var _stage:Stage                   = null;
		
		
		
		///// initial target point
		protected var _targetPoint:Point = null;
		
		///// mouse points
		protected var _targetMouse:Point = null;
		protected var _parentMouse:Point = null;
		protected var _stageMouse:Point  = null;
		
		///// last mouse points
		protected var _lastTargetMouse:Point = null;
		protected var _lastParentMouse:Point = null;
		protected var _lastStageMouse:Point  = null;
		
		
		
		///// dispose function
		protected var _disposeFunc:Function = null;
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Drag(
			target:InteractiveObject,
			dispatcher:IEventDispatcher = null
		) {
			super(target, dispatcher);
			
			
			
			///// listen
			_target.addEventListener(MouseEvent.MOUSE_DOWN, _down, false, 0, true);
			
			///// dispose function
			_disposeFunc = function():void {
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, _down, false);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// down
		//---------------------------------------
		protected function _down(e:MouseEvent):void {
			///// drop
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, _down, false);
			
			
			
			///// get
			_parent = _target.parent; ///// parent may be null (stage)
			_stage  = _target.stage; ///// stage shouldn’t be null
			
			
			
			///// initial target point
			_targetPoint = new Point(_target.x, _target.y);
			
			///// mouse points
			_targetMouse = new Point(_target.mouseX, _target.mouseY);
			_parentMouse = _parent ? new Point(_parent.mouseX, _parent.mouseY) : null;
			_stageMouse  = new Point(_target.stage.mouseX, _target.stage.mouseY);
			
			///// last mouse points
			_lastTargetMouse = _targetMouse.clone();
			_lastParentMouse = _parentMouse && _parentMouse.clone();
			_lastStageMouse  = _stageMouse.clone();
			
			
			
			///// listen
			_stage.addEventListener(MouseEvent.MOUSE_UP, _up, false, 0, true);
			_target.addEventListener(Event.ENTER_FRAME, _drag, false, 0, true);
			
			
			
			///// dispose function
			_disposeFunc = function():void {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, _up, false);
				_target.removeEventListener(Event.ENTER_FRAME, _drag, false);
			}
			
			
			
			///// dispatch
			_dispatch(DragEvent.START);
		}
		
		
		
		
		
		//---------------------------------------
		// drag
		//---------------------------------------
		protected function _drag(e:Event):void {
			var targetMouse:Point = new Point(_target.mouseX, _target.mouseY);
			var parentMouse:Point = _parentMouse && new Point(_parent.mouseX, _parent.mouseY);
			var stageMouse:Point  = new Point(_stage.mouseX, _stage.mouseY);
			
			///// check
			if (
				!_lastTargetMouse.equals(targetMouse) ||
				(_parent && !_lastParentMouse.equals(parentMouse)) ||
				!_lastStageMouse.equals(stageMouse)
			) {
				_lastTargetMouse = targetMouse;
				_lastParentMouse = parentMouse;
				_lastStageMouse  = stageMouse;
				
				
				
				///// dispatch
				_dispatch(DragEvent.DRAG);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// up
		//---------------------------------------
		protected function _up(e:MouseEvent):void {
			///// drop
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _up, false);
			_target.removeEventListener(Event.ENTER_FRAME, _drag, false);
			
			
			
			///// del
			_parent = null;
			_stage  = null;
			
			
			
			///// listen
			_target.addEventListener(MouseEvent.MOUSE_DOWN, _down, false, 0, true);
			
			
			
			///// dispose function
			_disposeFunc = function():void {
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, _down, false);
			}
			
			
			
			///// dispatch
			_dispatch(DragEvent.END);
		}
		
		
		
		
		
		//---------------------------------------
		// dispatch
		//---------------------------------------
		protected function _dispatch(type:String):void {
			(_dispatcher ? _dispatcher : this).dispatchEvent(new DragEvent(
				type,
				false,
				false,
				_target,
				this,
				
				///// points
				_targetPoint,
				_targetMouse,
				_parentMouse,
				_stageMouse,
				_lastTargetMouse,
				_lastParentMouse,
				_lastStageMouse
			));
		}
		
		
		
		
		
		//---------------------------------------
		// dispose
		//---------------------------------------
		override protected function _onDispose():void {
			_disposeFunc && _disposeFunc();
		}
	}
}