package org.typefest.layout.tunnels {
	import flash.events.Event;
	
	import org.typefest.layout.Area;
	
	public class BottomupTunnelBridge extends BottomupTunnel {
		protected var _target:Area = null;
		
		public function get target():Area {
			return _target;
		}
		public function set target(t:Area):void {
			if (_target !== t) {
				_target.removeEventListener(Event.CHANGE, _targetChange, false);
				_target = t;
				_target.addEventListener(Event.CHANGE, _targetChange, false, 0, true);
				_targetChange(null);
			}
		}
		
		public function BottomupTunnelBridge(target:Area) {
			super();
			
			_target = target;
			_target.addEventListener(Event.CHANGE, _targetChange, false, 0, true);
			_targetChange(null);
		}
		
		protected function _targetChange(e:Event):void {
			var some:Boolean = false;
			
			if (_rect.width !== _target.width) {
				_rect.width = _target.width;
				some = true;
			}
			if (_rect.height !== _target.height) {
				_rect.height = _target.height;
				some = true;
			}
			
			if (some) {
				_updateSize();
			}
		}
		
		override protected function _update():void {
			_position(_target, _target, _rect);
			
			super._update();
		}
	}
}