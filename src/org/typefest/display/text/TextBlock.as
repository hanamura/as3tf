/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.text {
	import flash.geom.Rectangle;
	
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.DamageEvent;
	import flashx.textLayout.factory.TextFlowTextLineFactory;
	
	import org.typefest.core.Arr;
	import org.typefest.data.AEvent;
	import org.typefest.data.AList;
	import org.typefest.data.AListChange;
	
	
	
	
	
	public class TextBlock extends TextBound {
		///// textflow
		protected var _textFlow:TextFlow = null;
		
		public function get textFlow():TextFlow { return _textFlow }
		public function set textFlow(_:TextFlow):void {
			if (_textFlow !== _) {
				if (_textFlow) {
					_textFlow.removeEventListener(
						DamageEvent.DAMAGE, _damage, false
					);
				}
				
				_textFlow = _;
				
				if (_textFlow) {
					_textFlow.addEventListener(
						DamageEvent.DAMAGE, _damage, false, 0, true
					);
				}
				
				_recompose();
			}
		}
		
		
		
		///// my lines
		protected var _myLines:AList = null;
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function TextBlock(
			textFlow:TextFlow = null,
			width:Number      = 0,
			height:Number     = 0
		) {
			_textFlow = textFlow;
			
			if (_textFlow) {
				_textFlow.addEventListener(
					DamageEvent.DAMAGE, _damage, false, 0, true
				);
			}
			
			super(width, height);
		}
		
		
		
		
		
		//---------------------------------------
		// on init
		//---------------------------------------
		override protected function _onInit():void {
			_myLines = new AList();
			_myLines.addEventListener(AEvent.CHANGE, _myLinesChange);
			
			_recompose();
		}
		
		
		
		
		
		//---------------------------------------
		// composition resize
		//---------------------------------------
		override protected function _onResizeComposition():void {
			_recompose();
		}
		
		
		
		
		
		//---------------------------------------
		// damage
		//---------------------------------------
		protected function _damage(e:DamageEvent):void {
			_recompose();
		}
		
		
		
		
		
		//---------------------------------------
		// recompose
		//---------------------------------------
		protected function _recompose():void {
			if (_textFlow) {
				_textFlow.removeEventListener(DamageEvent.DAMAGE, _damage, false);
				
				var lines:Array                     = [];
				var factory:TextFlowTextLineFactory = new TextFlowTextLineFactory();
				factory.compositionBounds = new Rectangle(
					0, 0, _compositionWidth, _compositionHeight
				);
				factory.createTextLines(lines.push, _textFlow);
				
				_textFlow.addEventListener(DamageEvent.DAMAGE, _damage, false, 0, true);
				
				_myLines.splice.apply(null, [0, _myLines.length].concat(lines));
			} else {
				_myLines.clear();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// my lines change
		//---------------------------------------
		protected function _myLinesChange(e:AEvent):void {
			var change:AListChange = e.change as AListChange;
			
			Arr.each(container.addChild, Arr.subtract(change.curr, change.prev));
			Arr.each(container.removeChild, Arr.subtract(change.prev, change.curr));
		}
	}
}