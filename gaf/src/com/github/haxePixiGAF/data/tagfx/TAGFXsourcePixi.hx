package com.github.haxePixiGAF.data.tagfx;
import pixi.core.textures.Texture;

/**
 * ...
 * @author Mathieu Anthoine
 */
class TAGFXsourcePixi extends TAGFXBase
{

	public function new(source:String) 
	{
		super();
		_source=source;
	}
	
	override private function get_sourceType(): String {
		return "Texture_Pixi";
	}

	override private function get_texture(): Texture
	{
		return Texture.fromImage(_source);
	}
	
}