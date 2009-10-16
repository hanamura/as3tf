/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	public class StageArea extends Area {
		protected var _stage:Stage = null;
		
		override public function set parent(x:Area):void {
			throw new IllegalOperationError("StageArea cannot be a child.");
		}
		
		public function StageArea(stage:Stage) {
			_stage = stage;
			
			_stage.addEventListener(Event.RESIZE, _resize, false, 0, true);
			_resize(null);
		}
		
		protected function _resize(e:Event):void {
			set(0, 0, _stage.stageWidth, _stage.stageHeight);
		}
	}
}