/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.gui.wrappers {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.typefest.core.Arr;
	import org.typefest.gui.Checkbox;
	import org.typefest.interaction.over.OverEvent;
	import org.typefest.interaction.press.PressEvent;
	
	
	
	
	
	public class CheckboxWrapper extends Checkbox {
		///// props
		protected var _target:DisplayObject = null;
		protected var _pretend:Boolean      = false;
		protected var _mc:MovieClip         = null;
		
		public function get target():DisplayObject { return _target }
		
		///// label
		protected var _label:* = null;
		
		public function get label():* { return _label }
		public function set label(_:*):void {
			if (_label !== _) {
				_label = _;
				_onLabel();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function CheckboxWrapper(target:DisplayObject, pretend:Boolean = true) {
			_target  = target;
			_pretend = pretend;
			
			super();
		}
		
		
		
		
		
		//---------------------------------------
		// on init
		//---------------------------------------
		override protected function _onInit():void {
			_mc = _target as MovieClip;
			
			addChild(_target);
			
			if (_pretend) {
				x = _target.x;
				y = _target.y;
				_target.x = 0;
				_target.y = 0;
				
				setSize(_target.width, _target.height);
			}
			
			_over.addEventListener(OverEvent.OVER, _stateChange);
			_over.addEventListener(OverEvent.OUT, _stateChange);
			_press.addEventListener(PressEvent.DOWN, _stateChange);
			_press.addEventListener(PressEvent.UP, _stateChange);
			
			_updateLabel();
		}
		
		
		
		
		
		//---------------------------------------
		// on mouse enabled
		//---------------------------------------
		override protected function _onInteraction():void {
			_updateLabel();
		}
		
		
		
		
		
		//---------------------------------------
		// on selected
		//---------------------------------------
		override protected function _onSelected():void {
			_updateLabel();
		}
		
		
		
		
		
		//---------------------------------------
		// state change
		//---------------------------------------
		protected function _stateChange(e:Event):void {
			_updateLabel();
		}
		
		
		
		
		
		//---------------------------------------
		// update label
		//---------------------------------------
		protected function _updateLabel():void {
			if (_mc) {
				label = selectLabel(
					Arr.select(_mc.currentLabels, "name"),
					_over.over,
					_press.pressed,
					mouseEnabled,
					_selected
				);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// on label
		//---------------------------------------
		protected function _onLabel():void {
			if (_mc) {
				_mc.gotoAndPlay(_label);
			}
		}
	}
}