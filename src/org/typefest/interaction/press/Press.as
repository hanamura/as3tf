/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.press {
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import org.typefest.interaction.Interaction;
	
	
	
	
	
	public class Press extends Interaction {
		///// stage
		protected var _stage:Stage = null;
		
		///// pressed
		protected var _pressed:Boolean = false;
		
		public function get pressed():Boolean { return _pressed }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Press(
			target:InteractiveObject,
			dispatcher:IEventDispatcher = null
		) {
			super(target, dispatcher);
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			_target.addEventListener(MouseEvent.MOUSE_DOWN, _down, false, 0, true);
		}
		
		
		
		
		
		//---------------------------------------
		// down
		//---------------------------------------
		protected function _down(e:MouseEvent):void {
			///// drop
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, _down, false);
			
			///// flag
			_pressed = true;
			
			///// set
			_stage = _target.stage;
			
			///// listen
			_stage.addEventListener(MouseEvent.MOUSE_UP, _up, false, 0, true);
			
			///// dispatch
			_dispatch(PressEvent.DOWN);
		}
		
		
		
		
		
		//---------------------------------------
		// up
		//---------------------------------------
		protected function _up(e:MouseEvent):void {
			///// drop
			_target.stage.removeEventListener(MouseEvent.MOUSE_UP, _up, false);
			
			///// flag
			_pressed = false;
			
			///// del
			_stage = null;
			
			///// listen
			_target.addEventListener(MouseEvent.MOUSE_DOWN, _down, false, 0, true);
			
			///// dispatch
			_dispatch(PressEvent.UP);
		}
		
		
		
		
		
		//---------------------------------------
		// dispose
		//---------------------------------------
		override protected function _onDispose():void {
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, _down, false);
			_target.removeEventListener(MouseEvent.MOUSE_UP, _up, false);
		}
		
		
		
		
		
		//---------------------------------------
		// dispatch
		//---------------------------------------
		protected function _dispatch(type:String):void {
			(_dispatcher ? _dispatcher : this).dispatchEvent(new PressEvent(
				type, false, false, _target, this
			));
		}
	}
}