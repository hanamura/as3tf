/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.actionunifier {
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	
	
	public class ActionEvent extends MouseEvent {
		///// types
		static public const DOWN:String      = "ActionEvent.DOWN";
		static public const UP:String        = "ActionEvent.UP";
		static public const OVER:String      = "ActionEvent.OVER";
		static public const OUT:String       = "ActionEvent.OUT";
		static public const ROLL_OVER:String = "ActionEvent.ROLL_OVER";
		static public const ROLL_OUT:String  = "ActionEvent.ROLL_OUT";
		static public const MOVE:String      = "ActionEvent.MOVE";
		static public const CLICK:String     = "ActionEvent.CLICK";
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function ActionEvent(
			type:String,
			bubbles:Boolean                 = true,
			cancelable:Boolean              = false,
			localX:Number                   = NaN,
			localY:Number                   = NaN,
			relatedObject:InteractiveObject = null,
			ctrlKey:Boolean                 = false,
			altKey:Boolean                  = false,
			shiftKey:Boolean                = false
		) {
			super(
				type,
				bubbles,
				cancelable,
				localX,
				localY,
				relatedObject,
				ctrlKey,
				altKey,
				shiftKey
			);
		}
		
		
		
		
		
		//---------------------------------------
		// clone
		//---------------------------------------
		override public function clone():Event {
			return new ActionEvent(
				type,
				bubbles,
				cancelable,
				localX,
				localY,
				relatedObject,
				ctrlKey,
				altKey,
				shiftKey
			);
		}
	}
}