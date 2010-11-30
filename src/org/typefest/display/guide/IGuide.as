/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.guide {
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	public interface IGuide extends IEventDispatcher {
		function getRectangle(area:Rectangle):Rectangle;
		function getColor():uint;
		function getAlpha():Number;
	}
}