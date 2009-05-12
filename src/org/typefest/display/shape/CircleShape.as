/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.shape {
	public class CircleShape extends RectShape {
		public static const TOP_LEFT:String      = "topLeft";
		public static const MIDDLE_CENTER:String = "middleCenter";
		
		protected var _radius:Number = 0;
		protected var _origin:String = TOP_LEFT;

		public function get radius():Number {
			return this._radius;
		}
		public function set radius(num:Number):void {
			if(this._radius !== num) {
				this._radius = num;
				this._update();
			}
		}
		
		public function get origin():String {
			return this._origin;
		}
		public function set origin(str:String):void {
			if(this._origin !== str) {
				this._origin = str;
				this._update();
			}
		}

		public override function get width():Number {
			return this._radius * 2;
		}
		public override function set width(num:Number):void {
			// do nothing
		}
		
		public override function get height():Number {
			return this._radius * 2;
		}
		public override function set height(num:Number):void {
			// do nothing
		}
		
		public function CircleShape() {}
		
		protected override function _update():void {
			this.graphics.clear();
			
			if(this._radius <= 0) {
				return;
			}
			
			var outerRadius:Number;
			var innerRadius:Number;
			
			switch(this._side) {
				case INSIDE:
					outerRadius = this._radius;
					innerRadius = Math.max(this._radius - this._lineWidth, 0);
					break;
				case CENTER:
					outerRadius = this._radius + (this._lineWidth / 2);
					innerRadius = Math.max(this._radius - (this._lineWidth / 2));
					break;
				case OUTSIDE:
					outerRadius = this._radius + this._lineWidth;
					innerRadius = this._radius;
					break;
			}
			
			var x:Number;
			var y:Number;
			
			switch(this._origin) {
				case TOP_LEFT:
					x = this._radius;
					y = this._radius;
					break;
				case MIDDLE_CENTER:
					x = 0;
					y = 0;
					break;
			}
			
			if(this._line === this._fill && this._lineA === this._fillA) {
				this.graphics.beginFill(this._line, this._lineA);
				this.graphics.drawCircle(x, y, outerRadius);
				this.graphics.endFill();
			} else {
				if(this._lineWidth > 0) {
					this.graphics.beginFill(this._line, this._lineA);
					this.graphics.drawCircle(x, y, outerRadius);
					if(this._fillA < 1) {
						this.graphics.drawCircle(x, y, innerRadius);
					}
					this.graphics.endFill();
				}
				
				this.graphics.beginFill(this._fill, this._fillA);
				this.graphics.drawCircle(x, y, innerRadius);
				this.graphics.endFill();
			}
		}
	}
}