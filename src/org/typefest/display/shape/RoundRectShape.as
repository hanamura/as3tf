/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.shape {
	public class RoundRectShape extends RectShape {
		protected var _radius:Number = 0;

		public function get radius():Number {
			return this._radius;
		}
		public function set radius(num:Number):void {
			if(this._radius !== num) {
				this._radius = num;
				this._update();
			}
		}
		
		public function RoundRectShape() {}
		
		protected override function _update():void {
			this.graphics.clear();
			
			if(this._width === 0 || this._height === 0) {
				return;
			}
			
			var outerX:Number;
			var outerY:Number;
			var outerWidth:Number;
			var outerHeight:Number;
			var innerX:Number;
			var innerY:Number;
			var innerWidth:Number;
			var innerHeight:Number;
			
			var outerDiameter:Number;
			var innerDiameter:Number;
			
			switch(this._side) {
				case INSIDE:
					outerX      = 0;
					outerY      = 0;
					outerWidth  = this._width;
					outerHeight = this._height;
					innerX      = this._lineWidth;
					innerY      = this._lineWidth;
					innerWidth  = this._width - (this._lineWidth * 2);
					innerHeight = this._height - (this._lineWidth * 2);
					
					outerDiameter = this._radius * 2;
					innerDiameter = Math.max(this._radius - this._lineWidth, 0) * 2;
					break;
				case CENTER:
					outerX      = -(this._lineWidth / 2);
					outerY      = -(this._lineWidth / 2);
					outerWidth  = this._width + this._lineWidth;
					outerHeight = this._height + this._lineWidth;
					innerX      = this._lineWidth / 2;
					innerY      = this._lineWidth / 2;
					innerWidth  = this._width - this._lineWidth;
					innerHeight = this._height - this._lineWidth;
					
					outerDiameter = (this._radius + (this._lineWidth / 2)) * 2;
					innerDiameter = Math.max(this._radius - (this._lineWidth / 2), 0) * 2;
					break;
				case OUTSIDE:
					outerX      = -this._lineWidth;
					outerY      = -this._lineWidth;
					outerWidth  = this._width + (this._lineWidth * 2);
					outerHeight = this._height + (this._lineWidth * 2);
					innerX      = 0;
					innerY      = 0;
					innerWidth  = this._width;
					innerHeight = this._height;
					
					outerDiameter = (this._radius + this._lineWidth) * 2;
					innerDiameter = this._radius * 2;
					break;
			}
			
			if(this._line === this._fill && this._lineA === this._fillA) {
				this.graphics.beginFill(this._line, this._lineA);
				this.graphics.drawRoundRect(outerX, outerY, outerWidth, outerHeight, outerDiameter, outerDiameter);
				this.graphics.endFill();
			} else {
				if(this._lineWidth !== 0) {
					this.graphics.beginFill(this._line, this._lineA);
					this.graphics.drawRoundRect(outerX, outerY, outerWidth, outerHeight, outerDiameter, outerDiameter);
					if(this._fillA < 1) {
						this.graphics.drawRoundRect(innerX, innerY, innerWidth, innerHeight, innerDiameter, innerDiameter);
					}
					this.graphics.endFill();
				}
				
				this.graphics.beginFill(this._fill, this._fillA);
				this.graphics.drawRoundRect(innerX, innerY, innerWidth, innerHeight, innerDiameter, innerDiameter);
				this.graphics.endFill();
			}
		}
	}
}