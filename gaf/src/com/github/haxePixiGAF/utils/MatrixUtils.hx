package com.github.haxePixiGAF.utils;
import pixi.core.math.Matrix;

/**
 * ...
 * @author Mathieu Anthoine
 */
class MatrixUtils
{

	public static function create (pA:Float = 1, pB:Float = 0, pC:Float = 0, pD:Float = 1, pTx:Float = 0, pTy:Float = 0):Matrix {
		var lMatrix:Matrix = new Matrix();
		lMatrix.a = pA;
		lMatrix.b = pB;
		lMatrix.c = pC;
		lMatrix.tx = pTx;
		lMatrix.ty = pTy;
		return lMatrix;
	}
	
}