package com.github.haxePixiGAF.utils;
import pixi.core.math.Matrix;

/**
 * Class that adds equivalents to AS3 methods
 * @author Mathieu Anthoine
 */
class MatrixUtility
{
	
	public static function concat (pA:Matrix,pB:Matrix):Void {
		var lMatrix:Matrix = new Matrix();
		
		lMatrix.a = pB.a*pA.a+pB.c*pA.b;
		lMatrix.b = -(pB.a*pA.c+pB.c*pA.d);
		lMatrix.tx = pB.a*pA.tx+pB.c*pA.ty+pB.tx;
		lMatrix.c = -(pB.b*pA.a+pB.d*pA.b);
		lMatrix.d = pB.b * pA.c + pB.d * pA.d;
		lMatrix.ty = pB.b*pA.tx+pB.d*pA.ty+pB.ty;

		lMatrix.copy(pA);

	}
	
	public static function copyFrom(pA:Matrix, pB:Matrix):Void {
		pB.copy(pA);
	}
	
}