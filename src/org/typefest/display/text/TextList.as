/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.text {
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.DamageEvent;
	import flashx.textLayout.events.FlowOperationEvent;
	
	import org.typefest.core.Arr;
	import org.typefest.data.AEvent;
	import org.typefest.data.AList;
	import org.typefest.data.AListChange;
	
	
	
	
	
	public class TextList extends AList {
		///// textflow
		protected var _textFlow:TextFlow = null;
		
		public function get textFlow():TextFlow { return _textFlow }
		public function set textFlow(_:TextFlow):void {
			if (_textFlow !== _) {
				if (_textFlow) {
					_textFlow.removeEventListener(
						FlowOperationEvent.FLOW_OPERATION_BEGIN,
						_flowOperationBegin,
						false
					);
					_textFlow.removeEventListener(
						FlowOperationEvent.FLOW_OPERATION_COMPLETE,
						_flowOperationComplete,
						false
					);
					_textFlow.removeEventListener(
						DamageEvent.DAMAGE, _damage, false
					);
					_textFlow.flowComposer.removeAllControllers();
				}
				
				_textFlow = _;
				
				if (_textFlow) {
					_textFlow.addEventListener(
						FlowOperationEvent.FLOW_OPERATION_BEGIN,
						_flowOperationBegin,
						false,
						0,
						true
					);
					_textFlow.addEventListener(
						DamageEvent.DAMAGE, _damage, false, 0, true
					);
				}
				
				_recompose();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function TextList(textFlow:TextFlow = null) {
			super();
			
			_textFlow = textFlow;
			
			if (_textFlow) {
				_textFlow.addEventListener(
					FlowOperationEvent.FLOW_OPERATION_BEGIN,
					_flowOperationBegin,
					false,
					0,
					true
				);
				_textFlow.addEventListener(
					DamageEvent.DAMAGE, _damage, false, 0, true
				);
			}
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			addEventListener(AEvent.CHANGE, _boundsChange);
		}
		
		
		
		
		
		//---------------------------------------
		// drop during flow operation
		//---------------------------------------
		protected function _flowOperationBegin(e:FlowOperationEvent):void {
			///// drop
			_textFlow.removeEventListener(
				FlowOperationEvent.FLOW_OPERATION_BEGIN, _flowOperationBegin, false
			);
			_textFlow.removeEventListener(
				DamageEvent.DAMAGE, _damage, false
			);
			
			///// listen
			_textFlow.addEventListener(
				FlowOperationEvent.FLOW_OPERATION_COMPLETE,
				_flowOperationComplete,
				false,
				0,
				true
			);
		}
		protected function _flowOperationComplete(e:FlowOperationEvent):void {
			///// drop
			_textFlow.removeEventListener(
				FlowOperationEvent.FLOW_OPERATION_COMPLETE, _flowOperationComplete, false
			);
			
			///// listen
			_textFlow.addEventListener(
				FlowOperationEvent.FLOW_OPERATION_BEGIN,
				_flowOperationBegin,
				false,
				0,
				true
			);
			_textFlow.addEventListener(
				DamageEvent.DAMAGE, _damage, false, 0, true
			);
			
			///// recompose
			_recompose();
		}
		
		
		
		
		
		//---------------------------------------
		// damage
		//---------------------------------------
		protected function _damage(e:DamageEvent):void {
			_recompose();
		}
		
		
		
		
		
		//---------------------------------------
		// update lines
		//---------------------------------------
		protected function _boundsChange(e:AEvent):void {
			var change:AListChange = e.change as AListChange;
			var adds:Array         = Arr.subtract(change.curr, change.prev);
			var removes:Array      = Arr.subtract(change.prev, change.curr);
			var bound:TextBound;
			
			for each (bound in adds) {
				bound.addEventListener(
					TextBoundEvent.RESIZE_COMPOSITION,
					_boundResizeComposition,
					false,
					0,
					true
				);
			}
			for each (bound in removes) {
				bound.removeEventListener(
					TextBoundEvent.RESIZE_COMPOSITION,
					_boundResizeComposition,
					false
				);
			}
			
			_recompose();
		}
		
		
		
		
		
		//---------------------------------------
		// bound resize composition
		//---------------------------------------
		protected function _boundResizeComposition(e:TextBoundEvent):void {
			if (_textFlow) {
				_textFlow.flowComposer.updateAllControllers();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// recompose
		//---------------------------------------
		protected function _recompose():void {
			if (_textFlow) {
				_textFlow.removeEventListener(DamageEvent.DAMAGE, _damage, false);
				
				_textFlow.flowComposer.removeAllControllers();
				
				for each (var bound:TextBound in this) {
					_textFlow.flowComposer.addController(bound.controller);
				}
				
				_textFlow.flowComposer.updateAllControllers();
				
				_textFlow.addEventListener(DamageEvent.DAMAGE, _damage, false, 0, true);
			}
		}
	}
}