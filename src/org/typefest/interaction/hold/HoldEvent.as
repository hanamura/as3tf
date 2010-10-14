/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.hold {
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	import org.typefest.interaction.Interaction;
	import org.typefest.interaction.InteractionEvent;
	
	
	
	
	
	public class HoldEvent extends InteractionEvent {
		///// type
		static public const HOLD:String = "HoldEvent.HOLD";
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function HoldEvent(
			type:String,
			bubbles:Boolean                     = false,
			cancelable:Boolean                  = false,
			interactionTarget:InteractiveObject = null,
			interaction:Interaction             = null
		) {
			super(type, bubbles, cancelable, interactionTarget, interaction);
		}
		
		
		
		
		
		//---------------------------------------
		// clone
		//---------------------------------------
		override public function clone():Event {
			return new HoldEvent(
				type, bubbles, cancelable, interactionTarget, interaction
			);
		}
	}
}