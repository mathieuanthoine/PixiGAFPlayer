package com.github.haxePixiGAF.display;

import com.github.haxePixiGAF.data.textures.TextureWrapper;
import pixi.core.math.Matrix;

/**
 * TODO: passer de Starling à Pixi
 * @author Mathieu Anthoine
 * An Interface describes objects that contain all data used to initialize static GAF display objects such as<code>GAFImage</code>.
 */
interface IGAFTexture
{
	/**
	 * Returns Starling Texture object.
	 * @return a Starling Texture object
	 */
	public var texture(get_texture, null):TextureWrapper;
 	private function get_texture():TextureWrapper;

	/**
	 * Returns pivot matrix of the static GAF display object.
	 * @return a Matrix object
	 */
	public var pivotMatrix(get_pivotMatrix, null):Matrix;
 	private function get_pivotMatrix():Matrix;

	/**
	 * An Internal identifier of the region in a texture atlas.
	 * @return a String identifier
	 */
	public var id(get_id, null):String;
 	private function get_id():String;

	/**
	 * Returns a new object that is a clone of this object.
	 * @return object with Interface<code>IGAFTexture</code>
	 */
	public function clone():IGAFTexture;
	

	/**
	 * Copies all of the data from the source object Into the calling<code>IGAFTexture</code>object
	 * @param newTexture the<code>IGAFTexture</code>object from which to copy the data
	 */
	public function copyFrom(newTexture:IGAFTexture):Void;
}