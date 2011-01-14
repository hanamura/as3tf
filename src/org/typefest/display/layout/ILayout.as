/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.layout {
	import org.typefest.display.containers.IRepresent;
	
	public interface ILayout extends IRepresent {
		function get layoutWidth():Number;
		function set layoutWidth(_:Number):void;
		function get layoutHeight():Number;
		function set layoutHeight(_:Number):void;
		function get layoutMethod():Function;
		function set layoutMethod(_:Function):void;
		function get filterPosition():Function;
		function set filterPosition(_:Function):void;
		function get filterSize():Function;
		function set filterSize(_:Function):void;
		function setLayoutSize(width:Number, height:Number):void;
	}
}