package com.github.haxePixiGAF.utils;
import pixi.core.math.Matrix;

/**
 * ...
 * @author Mathieu Anthoine
 */
class MatrixUtils
{
	
	public static function concat (pA:Matrix,pB:Matrix):Matrix {
		var lMatrix:Matrix = new Matrix();
		
		lMatrix.a = pB.a*pA.a+pB.c*pA.b;
		lMatrix.b = -(pB.a*pA.c+pB.c*pA.d);
		lMatrix.tx = pB.a*pA.tx+pB.c*pA.ty+pB.tx;
		lMatrix.c = -(pB.b*pA.a+pB.d*pA.b);
		lMatrix.d = pB.b * pA.c + pB.d * pA.d;
		lMatrix.ty = pB.b*pA.tx+pB.d*pA.ty+pB.ty;

		return lMatrix;
	}
	
}