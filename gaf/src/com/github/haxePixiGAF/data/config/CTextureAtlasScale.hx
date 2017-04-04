package com.github.haxePixiGAF.data.config;
import com.github.haxePixiGAF.utils.MathUtility;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * @private
 */
class CTextureAtlasScale
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

	private var _scale:Float;

	private var _allContentScaleFactors:Array<CTextureAtlasCSF>;
	private var _contentScaleFactor:CTextureAtlasCSF;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new()
	{
		_allContentScaleFactors=new Array<CTextureAtlasCSF>();
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

	public function dispose():Void
	{
		for(cTextureAtlasCSF in _allContentScaleFactors)
		{
			cTextureAtlasCSF.dispose();
		}
	}

	public function getTextureAtlasForCSF(csf:Float):CTextureAtlasCSF
	{
		for(textureAtlas in _allContentScaleFactors)
		{
			if(MathUtility.equals(textureAtlas.csf, csf))
			{
				return textureAtlas;
			}
		}

		return null;
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

	private function set_scale(scale:Float):Float
	{
		return _scale=scale;
	}

	public var scale(get_scale, set_scale):Float;
 	private function get_scale():Float
	{
		return _scale;
	}

	public var allContentScaleFactors(get_allContentScaleFactors, set_allContentScaleFactors):Array<CTextureAtlasCSF>;
 	private function get_allContentScaleFactors():Array<CTextureAtlasCSF>
	{
		return _allContentScaleFactors;
	}

	private function set_allContentScaleFactors(value:Array<CTextureAtlasCSF>):Array<CTextureAtlasCSF>
	{
		return _allContentScaleFactors=value;
	}

	public var contentScaleFactor(get_contentScaleFactor, set_contentScaleFactor):CTextureAtlasCSF;
 	private function get_contentScaleFactor():CTextureAtlasCSF
	{
		return _contentScaleFactor;
	}

	private function set_contentScaleFactor(value:CTextureAtlasCSF):CTextureAtlasCSF
	{
		return _contentScaleFactor=value;
	}
}