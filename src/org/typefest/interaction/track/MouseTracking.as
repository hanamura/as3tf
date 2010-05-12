/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction.track {
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.typefest.proc.Proc;
	
	[Event(name="change", type="flash.events.Event.CHANGE")]
	public class MouseTracking extends Proc {
		protected var _target:InteractiveObject = null;
		protected var _length:int               = -1;
		
		protected var _points:Array     = null;
		protected var _velocities:Array = null;
		
		public function get points():Array {
			var _:Array = [];
			for (var i:int = 0; i < _points.length; i++) {
				_.push(_points[i].clone());
			}
			return _;
		}
		
		public function get velocities():Array {
			var _:Array = [];
			for (var i:int = 0; i < _velocities.length; i++) {
				_.push(_velocities[i].clone());
			}
			return _;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function MouseTracking(target:InteractiveObject, length:int = -1) {
			super();
			
			_target = target;
			_length = length;
			
			fire();
		}
		
		//---------------------------------------
		// start / stop
		//---------------------------------------
		override protected function _defaultStopped():void {
			_end();
		}
		
		override protected function _start():void {
			_points     = [new Point(_target.mouseX, _target.mouseY)];
			_velocities = [];
			
			_track();
		}
		
		//---------------------------------------
		// track
		//---------------------------------------
		protected function _track():void {
			var point:Point     = new Point(_target.mouseX, _target.mouseY);
			var lastPoint:Point = _points[_points.length - 1];
			var velocity:Point  = point.subtract(lastPoint);
			
			_points.push(point);
			_velocities.push(velocity);
			
			if (_length >= 0 && _points.length > _length) {
				_points.shift();
			}
			if (_length >= 0 && _velocities.length > _length) {
				_velocities.shift();
			}
			
			sleep("1", _track);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}