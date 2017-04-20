package com.github.haxePixiGAF.data.config;

import com.github.haxePixiGAF.data.textures.TextureAtlas;
import com.github.haxePixiGAF.data.textures.TextureWrapper;
import com.github.haxePixiGAF.display.GAFScale9Texture;
import com.github.haxePixiGAF.display.GAFTexture;
import com.github.haxePixiGAF.display.IGAFTexture;
import pixi.core.math.Matrix;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * @private
 */
class CTextureAtlas
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

	private var _textureAtlasesDictionary:Map<String,TextureAtlas>;
	private var _textureAtlasConfig:CTextureAtlasCSF;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new(textureAtlasesDictionary:Map<String,TextureAtlas>, textureAtlasConfig:CTextureAtlasCSF)
	{
		_textureAtlasesDictionary=textureAtlasesDictionary;
		_textureAtlasConfig=textureAtlasConfig;
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

	public static function createFromTextures(texturesDictionary:Map<String,TextureWrapper>,textureAtlasConfig:CTextureAtlasCSF):CTextureAtlas
	{
		var atlasesDictionary:Map<String,TextureAtlas>=new Map<String,TextureAtlas>();

		var atlas:TextureAtlas;

		for(element in textureAtlasConfig.elements.elementsVector)
		{
			if(atlasesDictionary[element.atlasID]==null)
			{
				
				atlasesDictionary[element.atlasID]=new TextureAtlas(texturesDictionary[element.atlasID]);
			}

			atlas=atlasesDictionary[element.atlasID];
			
			atlas.addRegion(element.id, element.region, null, element.rotated);
		}
		
		return new CTextureAtlas(atlasesDictionary, textureAtlasConfig);
	}

	public function dispose():Void
	{
		for(textureAtlas in _textureAtlasesDictionary)
		{
			textureAtlas.dispose();
		}
	}

	public function getTexture(id:String):IGAFTexture
	{
		var textureAtlasElement:CTextureAtlasElement=_textureAtlasConfig.elements.getElement(id);
		if(textureAtlasElement!=null)
		{
			var texture:TextureWrapper=getTextureByIDAndAtlasID(id, textureAtlasElement.atlasID);

			var pivotMatrix:Matrix;

			if(_textureAtlasConfig.elements.getElement(id)!=null)
			{
				pivotMatrix=_textureAtlasConfig.elements.getElement(id).pivotMatrix;
			}
			else
			{
				pivotMatrix=new Matrix();
			}

			if(textureAtlasElement.scale9Grid !=null)
			{
				return new GAFScale9Texture(id, texture, pivotMatrix, textureAtlasElement.scale9Grid);
			}
			else
			{
				return new GAFTexture(id, texture, pivotMatrix);
			}
		}

		return null;
	}

	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------

	public function getTextureByIDAndAtlasID(id:String, atlasID:String):TextureWrapper
	{
		var textureAtlas:TextureAtlas=_textureAtlasesDictionary[atlasID];

		return textureAtlas.getTexture(id);
	}

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
}