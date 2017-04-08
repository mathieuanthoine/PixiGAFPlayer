package com.github.haxePixiGAF.data.config;
import pixi.core.math.Matrix;

/**
 * TODO
 * @author Mathieu Anthoine
 * @private
 */
class CAnimationFrameInstance
{
	// --------------------------------------------------------------------------
	//
	// PUBLIC VARIABLES
	//
	// --------------------------------------------------------------------------
	// --------------------------------------------------------------------------
	//
	// PRIVATE VARIABLES
	//
	// --------------------------------------------------------------------------
	private var _id:String;
	private var _zIndex:Int;
	private var _matrix:Matrix;
	private var _alpha:Float;
	private var _maskID:String;
	private var _filter:CFilter;

	private static var tx:Float;
	private static var ty:Float;

	// --------------------------------------------------------------------------
	//
	// CONSTRUCTOR
	//
	// --------------------------------------------------------------------------
	public function new(id:String)
	{
		_id=id;
	}

	// --------------------------------------------------------------------------
	//
	// PUBLIC METHODS
	//
	// --------------------------------------------------------------------------
	public function clone():CAnimationFrameInstance
	{
		var result:CAnimationFrameInstance=new CAnimationFrameInstance(_id);

		var filterCopy:CFilter=null;

		if(_filter!=null)
		{
			filterCopy=_filter.clone();
		}

		result.update(_zIndex, _matrix.clone(), _alpha, _maskID, filterCopy);

		return result;
	}

	public function update(zIndex:Int, matrix:Matrix, alpha:Float, maskID:String, filter:CFilter):Void
	{
		_zIndex=zIndex;
		_matrix=matrix;
		_alpha=alpha;
		_maskID=maskID;
		_filter=filter;
	}

	public function getTransformMatrix(pivotMatrix:Matrix, scale:Float):Matrix
	{
		var result:Matrix=pivotMatrix.clone();
		tx=_matrix.tx;
		ty=_matrix.ty;
		_matrix.tx *=scale;
		_matrix.ty *=scale;
		//result.concat(_matrix);
		result.append(_matrix);
		_matrix.tx=tx;
		_matrix.ty=ty;

		return result;
	}

	public function applyTransformMatrix(transformationMatrix:Matrix, pivotMatrix:Matrix, scale:Float):Void
	{
		// TODO : a verifier
		pivotMatrix.copy(transformationMatrix); //transformationMatrix.copyFrom(pivotMatrix);
		tx=_matrix.tx;
		ty=_matrix.ty;
		_matrix.tx *=scale;
		_matrix.ty *=scale;
		//transformationMatrix.concat(_matrix);
		transformationMatrix.append(_matrix);
		_matrix.tx=tx;
		_matrix.ty=ty;
	}

	public function calculateTransformMatrix(transformationMatrix:Matrix, pivotMatrix:Matrix, scale:Float):Matrix
	{
		applyTransformMatrix(transformationMatrix, pivotMatrix, scale);
		return transformationMatrix;
	}

	// --------------------------------------------------------------------------
	//
	// PRIVATE METHODS
	//
	// --------------------------------------------------------------------------
	// --------------------------------------------------------------------------
	//
	// OVERRIDDEN METHODS
	//
	// --------------------------------------------------------------------------
	// --------------------------------------------------------------------------
	//
	// EVENT HANDLERS
	//
	// --------------------------------------------------------------------------
	// --------------------------------------------------------------------------
	//
	// GETTERS AND SETTERS
	//
	// --------------------------------------------------------------------------
	public var id(get_id, null):String;
 	private function get_id():String
	{
		return _id;
	}

	public var matrix(get_matrix, null):Matrix;
 	private function get_matrix():Matrix
	{
		return _matrix;
	}

	public var alpha(get_alpha, null):Float;
 	private function get_alpha():Float
	{
		return _alpha;
	}

	public var maskID(get_maskID, null):String;
 	private function get_maskID():String
	{
		return _maskID;
	}

	public var filter(get_filter, null):CFilter;
 	private function get_filter():CFilter
	{
		return _filter;
	}

	public var zIndex(get_zIndex, null):Int;
 	private function get_zIndex():Int
	{
		return _zIndex;
	}
}