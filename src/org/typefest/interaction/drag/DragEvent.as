/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.drag {
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.typefest.interaction.Interaction;
	import org.typefest.interaction.InteractionEvent;
	
	
	
	
	
	public class DragEvent extends InteractionEvent {
		///// types
		static public const START:String = "DragEvent.START";
		static public const DRAG:String  = "DragEvent.DRAG";
		static public const END:String   = "DragEvent.END";
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// point
		protected var _targetPoint:Point = null;
		
		public function get targetPoint():Point {
			return _targetPoint.clone();
		}
		
		
		
		///// mouse points
		protected var _targetMouse:Point = null;
		protected var _parentMouse:Point = null;
		protected var _stageMouse:Point  = null;
		
		public function get targetMouse():Point {
			return _targetMouse.clone();
		}
		public function get parentMouse():Point {
			return _parentMouse && _parentMouse.clone();
		}
		public function get stageMouse():Point {
			return _stageMouse.clone();
		}
		
		
		
		///// last mouse points
		protected var _lastTargetMouse:Point = null;
		protected var _lastParentMouse:Point = null;
		protected var _lastStageMouse:Point  = null;
		
		public function get lastTargetMouse():Point {
			return _lastTargetMouse.clone();
		}
		public function get lastParentMouse():Point {
			return _lastParentMouse && _lastParentMouse.clone();
		}
		public function get lastStageMouse():Point {
			return _lastStageMouse.clone();
		}
		
		
		
		///// offsets
		public function get targetOffset():Point {
			return _lastTargetMouse.subtract(_targetMouse);
		}
		public function get parentOffset():Point {
			return _parentMouse && _lastParentMouse.subtract(_parentMouse);
		}
		public function get stageOffset():Point {
			return _lastStageMouse.subtract(_stageMouse);
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function DragEvent(
			type:String,
			bubbles:Boolean                     = false,
			cancelable:Boolean                  = false,
			interactionTarget:InteractiveObject = null,
			interaction:Interaction             = null,
			
			targetPoint:Point = null,
			targetMouse:Point = null,
			parentMouse:Point = null,
			stageMouse:Point  = null,
			
			lastTargetMouse:Point = null,
			lastParentMouse:Point = null,
			lastStageMouse:Point  = null
		) {
			super(type, bubbles, cancelable, interactionTarget, interaction);
			
			
			
			///// point
			_targetPoint = targetPoint.clone();
			
			///// mouse points
			_targetMouse = targetMouse.clone();
			_parentMouse = parentMouse && parentMouse.clone();
			_stageMouse  = stageMouse.clone();
			
			///// last mouse points
			_lastTargetMouse = lastTargetMouse.clone();
			_lastParentMouse = lastParentMouse && lastParentMouse.clone();
			_lastStageMouse  = lastStageMouse.clone();
		}
		
		
		
		
		
		//---------------------------------------
		// clone
		//---------------------------------------
		override public function clone():Event {
			return new DragEvent(
				type,
				bubbles,
				cancelable,
				interactionTarget,
				interaction,
				_targetPoint,
				_targetMouse,
				_parentMouse,
				_stageMouse,
				_lastTargetMouse,
				_lastParentMouse,
				_lastStageMouse
			);
		}
	}
}