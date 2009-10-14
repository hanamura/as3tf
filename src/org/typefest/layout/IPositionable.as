/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	import flash.geom.Rectangle;
	
	public interface IPositionable {
		//---------------------------------------
		// basic position and size info
		//---------------------------------------
		function get x():Number;
		function set x(x:Number):void;
		function get y():Number;
		function set y(y:Number):void;
		function get width():Number;
		function set width(width:Number):void;
		function get height():Number;
		function set height(height:Number):void;
		
		//---------------------------------------
		// area related properties
		//---------------------------------------
		function get layout():Function;
		function get original():Rectangle;
		function get positionX():Number;
		function get positionY():Number;
		function get getPositionX():Function;
		function get getPositionY():Function;
		function get apply():Function;
		
		//---------------------------------------
		// parent area
		//---------------------------------------
		function get parent():Area;
		function set parent(area:Area):void;
	}
}