package com.github.haxePixiGAF.data.tagfx;
import com.github.haxePixiGAF.data.textures.TextureWrapper;
import pixi.core.textures.BaseTexture;

/**
 * @author Mathieu Anthoine
 */
class TAGFXsourcePixi extends TAGFXBase
{

	private var bob:String;
	
	public function new(source:String) 
	{
		super();
		_source = source;
		bob = source;
	}
	
	override private function get_sourceType(): String {
		return "Texture_Pixi";
	}

	override private function get_texture(): TextureWrapper
	{
		return new TextureWrapper(BaseTexture.fromImage(_source));
	}
	
}