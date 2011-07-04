/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.over {
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	import org.typefest.interaction.Interaction;
	import org.typefest.interaction.InteractionEvent;
	
	
	
	
	
	public class OverEvent extends InteractionEvent {
		static public const OVER:String = "OverEvent.OVER";
		static public const OUT:String  = "OverEvent.OUT";
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function OverEvent(
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
			return new OverEvent(
				type, bubbles, cancelable, interactionTarget, interaction
			);
		}
	}
}