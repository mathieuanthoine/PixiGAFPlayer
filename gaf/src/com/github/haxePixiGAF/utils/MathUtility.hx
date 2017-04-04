package com.github.haxePixiGAF.utils;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * @private
 */
class MathUtility
{
	public static inline var epsilon:Float=0.00001;

	public static var PI_Q:Float=Math.PI / 4.0;

	public static inline function equals(a:Float, b:Float):Bool
	{
		if(Math.isNaN(a)|| Math.isNaN(b))
		{
			return false;
		}
		return Math.abs(a - b)<epsilon;
	}

	public static function getItemIndex(source:Array<Float>, target:Float):Int
	{
		for(i in 0...source.length)
		{
			if(equals(source[i], target))
			{
				return i;
			}
		}
		return -1;
	}
}