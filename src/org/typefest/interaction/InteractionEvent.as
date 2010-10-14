/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction {
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	
	
	
	
	public class InteractionEvent extends Event {
		protected var _interactionTarget:InteractiveObject = null;
		protected var _interaction:Interaction             = null;
		
		public function get interactionTarget():InteractiveObject {
			return _interactionTarget;
		}
		public function get interaction():Interaction {
			return _interaction;
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function InteractionEvent(
			type:String,
			bubbles:Boolean                     = false,
			cancelable:Boolean                  = false,
			interactionTarget:InteractiveObject = null,
			interaction:Interaction             = null
		) {
			super(type, bubbles, cancelable);
			
			_interactionTarget = interactionTarget;
			_interaction       = interaction;
		}
		
		
		
		
		
		//---------------------------------------
		// clone
		//---------------------------------------
		override public function clone():Event {
			return new InteractionEvent(
				type, bubbles, cancelable, _interactionTarget, _interaction
			);
		}
	}
}