package com.github.haxePixiGAF.data;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * 
 */
class GAFDebugInformation
{
	public static inline var TYPE_POINT:Int=0;
	public static inline var TYPE_RECT:Int=1;

	public var type:Int=0;
	public var point:Point;
	public var rect:Rectangle;
	public var color:Int=0;
	public var alpha:Float;
}