package com.github.haxePixiGAF.data.tagfx;
import com.github.haxePixiGAF.data.textures.SubTexture;
import com.github.haxePixiGAF.data.textures.TextureWrapper;
import pixi.core.textures.BaseTexture;
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

	override private function get_texture(): TextureWrapper
	{
		return new TextureWrapper(BaseTexture.fromImage(_source));
	}
	
}