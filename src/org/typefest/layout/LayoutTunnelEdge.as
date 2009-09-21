/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	public class LayoutTunnelEdge extends LayoutArea {
		protected var _tunnel:LayoutTunnel = null;
		
		internal function set tunnel(x:LayoutTunnel):void {
			_tunnel = x;
		}
		
		public function LayoutTunnelEdge(
			x:Number = 0,
			y:Number = 0,
			width:Number = 0,
			height:Number = 0
		) {
			super(x, y, width, height);
		}
		
		override protected function _update():void {
			super._update();
			if (_tunnel) {
				_tunnel.updateTunnel();
			}
		}
	}
}