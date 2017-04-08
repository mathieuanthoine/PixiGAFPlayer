package com.github.haxePixiGAF.data.tagfx;

import com.github.haxePixiGAF.data.textures.SubTexture;
import com.github.haxePixiGAF.events.IEventEmitter;
import eventemitter3.EventEmitter;
import pixi.core.math.Point;
import pixi.core.textures.Texture;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * @private
 */
interface ITAGFX extends IEventEmitter
{
	public var texture(get_texture, null):SubTexture;
 	private function get_texture():SubTexture;
	
	public var textureSize(get_textureSize, null):Point;
 	private function get_textureSize():Point;
	
	public var textureScale(get_textureScale, null):Float;
 	private function get_textureScale():Float;
	
	public var textureFormat(get_textureFormat, null):String;
 	private function get_textureFormat():String;
	
	public var sourceType(get_sourceType, null):String;
 	private function get_sourceType():String;
	
	public var source(get_source, null):Dynamic;
 	private function get_source():Dynamic;
	
	public var ready(get_ready, null):Bool;
 	private function get_ready():Bool;
}