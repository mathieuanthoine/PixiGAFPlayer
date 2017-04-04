package com.github.haxePixiGAF.utils;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * @private
 */
class VectorUtility
{

	public static inline function fillMatrix(v:Array<Float>,
			a00:Float, a01:Float, a02:Float, a03:Float, a04:Float,
			a10:Float, a11:Float, a12:Float, a13:Float, a14:Float,
			a20:Float, a21:Float, a22:Float, a23:Float, a24:Float,
			a30:Float, a31:Float, a32:Float, a33:Float, a34:Float):Void
	{
		v[0]=a00;v[1]=a01;v[2]=a02;v[3]=a03;v[4]=a04;
		v[5]=a10;v[6]=a11;v[7]=a12;v[8]=a13;v[9]=a14;
		v[10]=a20;v[11]=a21;v[12]=a22;v[13]=a23;v[14]=a24;
		v[15]=a30;v[16]=a31;v[17]=a32;v[18]=a33;v[19]=a34;
	}

	public static inline function copyMatrix(source:Array<Float>, dest:Array<Float>):Void
	{
		var l:Int=dest.length;
		for(i in 0...l)
		{
			source[i]=dest[i];
		}
	}
}