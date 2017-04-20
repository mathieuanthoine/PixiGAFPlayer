package com.github.haxePixiGAF.utils;
import pixi.core.math.shapes.Rectangle;

/**
 * Class that adds equivalents to AS3 methods
 * @author Mathieu Anthoine
 */
class RectangleUtility
{
	public static function copyFrom(pA:Rectangle, pB:Rectangle):Void {
		pA.x = pB.x;
		pA.y = pB.y;
		pA.width = pB.width;
		pA.height = pB.height;
	}
	
	public static function union(pA:Rectangle, pB:Rectangle):Rectangle {
		var lX:Float = Math.min(pA.x, pB.x);
		var lY:Float = Math.min(pA.y, pB.y);
		var lRight:Float = Math.max(pA.x + pA.width, pB.x + pB.width);
		var lBottom:Float = Math.max(pA.y + pA.height, pB.y + pB.height);

		return new Rectangle(lX, lY, lRight - lX, lBottom - lY);

	}
}