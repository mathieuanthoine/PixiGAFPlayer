package com.github.haxePixiGAF.display;

import com.github.haxePixiGAF.data.textures.TextureWrapper;
import pixi.core.math.Matrix;

/**
 * TODO
 * @author Mathieu Anthoine
 * @private
 */
class GAFTexture implements IGAFTexture
{
	//--------------------------------------------------------------------------
	//
	//  PUBLIC VARIABLES
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//
	//  PRIVATE VARIABLES
	//
	//--------------------------------------------------------------------------

	private var _id:String;
	private var _texture:TextureWrapper;
	private var _pivotMatrix:Matrix;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new(id:String, texture:TextureWrapper, pivotMatrix:Matrix)
	{
		_id=id;
		_texture=texture;
		_pivotMatrix=pivotMatrix;
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------
	public function copyFrom(newTexture:IGAFTexture):Void
	{
		if(Std.is(newTexture, GAFTexture))
		{
			_id=newTexture.id;
			_texture=newTexture.texture;
			//_pivotMatrix.copyFrom(newTexture.pivotMatrix);
			newTexture.pivotMatrix.copy(_pivotMatrix);
		}
		else
		{
			throw "Incompatiable types GAFexture and "+Type.getClassName(Type.getClass(newTexture));
		}
	}
	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//
	// OVERRIDDEN METHODS
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//
	//  EVENT HANDLERS
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//
	//  GETTERS AND SETTERS
	//
	//--------------------------------------------------------------------------

	public var texture(get_texture, null):TextureWrapper;
 	private function get_texture():TextureWrapper
	{
		return _texture;
	}

	public var pivotMatrix(get_pivotMatrix, null):Matrix;
 	private function get_pivotMatrix():Matrix
	{
		return _pivotMatrix;
	}

	public var id(get_id, null):String;
 	private function get_id():String
	{
		return _id;
	}

	public function clone():IGAFTexture
	{
		return new GAFTexture(_id, _texture, _pivotMatrix.clone());
	}
}