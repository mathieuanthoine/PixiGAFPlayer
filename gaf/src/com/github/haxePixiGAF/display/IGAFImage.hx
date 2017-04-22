package com.github.haxePixiGAF.display;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * 
 */
interface IGAFImage extends IGAFDisplayObject
{
	public var assetTexture(get_assetTexture,null):IGAFTexture;
	private function get_assetTexture():IGAFTexture;
	
	public var textureSmoothing(get_textureSmoothing,set_textureSmoothing):String;
	private function get_textureSmoothing():String;
	private function set_textureSmoothing(value:String):String;
}