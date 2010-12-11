/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.containers {
	import flash.events.IEventDispatcher;
	
	public interface IRepresent extends IEventDispatcher {
		function get x():Number;
		function get y():Number;
		function get width():Number;
		function get height():Number;
		function setPosition(x:Number, y:Number):void;
		function setSize(width:Number, height:Number):void;
	}
}