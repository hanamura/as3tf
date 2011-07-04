/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.over {
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import org.typefest.interaction.Interaction;
	
	
	
	
	
	public class Over extends Interaction {
		///// over
		protected var _over:Boolean = false;
		
		public function get over():Boolean { return _over }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Over(
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
			_target.addEventListener(MouseEvent.ROLL_OVER, _rollOver, false, 0, true);
		}
		
		
		
		
		
		//---------------------------------------
		// over
		//---------------------------------------
		protected function _rollOver(e:MouseEvent):void {
			_target.removeEventListener(MouseEvent.ROLL_OVER, _rollOver, false);
			
			_over = true;
			
			_target.addEventListener(MouseEvent.ROLL_OUT, _rollOut, false, 0, true);
			
			_dispatch(OverEvent.OVER);
		}
		
		
		
		
		
		//---------------------------------------
		// out
		//---------------------------------------
		protected function _rollOut(e:MouseEvent):void {
			_target.removeEventListener(MouseEvent.ROLL_OUT, _rollOut, false);
			
			_over = false;
			
			_target.addEventListener(MouseEvent.ROLL_OVER, _rollOver, false, 0, true);
			
			_dispatch(OverEvent.OUT);
		}
		
		
		
		
		
		//---------------------------------------
		// dispose
		//---------------------------------------
		override protected function _onDispose():void {
			_target.removeEventListener(MouseEvent.ROLL_OVER, _rollOver, false);
			_target.removeEventListener(MouseEvent.ROLL_OUT, _rollOut, false);
		}
		
		
		
		
		
		//---------------------------------------
		// dispatch
		//---------------------------------------
		protected function _dispatch(type:String):void {
			(_dispatcher ? _dispatcher : this).dispatchEvent(new OverEvent(
				type, false, false, _target, this
			));
		}
	}
}