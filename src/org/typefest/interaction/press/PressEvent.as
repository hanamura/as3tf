/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.press {
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	import org.typefest.interaction.Interaction;
	import org.typefest.interaction.InteractionEvent;
	
	
	
	
	
	public class PressEvent extends InteractionEvent {
		static public const DOWN:String = "PressEvent.DOWN";
		static public const UP:String   = "PressEvent.UP";
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function PressEvent(
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
			return new PressEvent(
				type, bubbles, cancelable, interactionTarget, interaction
			);
		}
	}
}