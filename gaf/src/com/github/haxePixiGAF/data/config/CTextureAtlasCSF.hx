package com.github.haxePixiGAF.data.config;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * 
 */
class CTextureAtlasCSF
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
	private var _csf:Float;

	private var _sources:Array<CTextureAtlasSource>;

	private var _elements:CTextureAtlasElements;

	private var _atlas:CTextureAtlas;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new(csf:Float, scale:Float)
	{
		_csf=csf;
		_scale = scale;

		_sources=new Array<CTextureAtlasSource>();
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

	public function dispose():Void
	{
		if (_atlas != null) {
			_atlas.dispose();
			_atlas=null;
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

	public var csf(get_csf, null):Float;
 	private function get_csf():Float
	{
		return _csf;
	}

	public var sources(get_sources, set_sources):Array<CTextureAtlasSource>;
 	private function get_sources():Array<CTextureAtlasSource>
	{
		return _sources;
	}

	private function set_sources(sources:Array<CTextureAtlasSource>):Array<CTextureAtlasSource>
	{
		return _sources=sources;
	}

	public var atlas(get_atlas, set_atlas):CTextureAtlas;
 	private function get_atlas():CTextureAtlas
	{
		return _atlas;
	}

	private function set_atlas(atlas:CTextureAtlas):CTextureAtlas
	{
		return _atlas=atlas;
	}

	public var elements(get_elements, set_elements):CTextureAtlasElements;
 	private function get_elements():CTextureAtlasElements
	{
		return _elements;
	}

	private function set_elements(elements:CTextureAtlasElements):CTextureAtlasElements
	{
		return _elements=elements;
	}
}