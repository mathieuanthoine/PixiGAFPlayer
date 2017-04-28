package com.github.haxePixiGAF.data;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * The GAF class defines global GAF library settings
 */
@:expose
class GAF
{
	/**
	 * Optimize draw calls when animation contain mixed objects with alpha &lt;1 and with alpha=1.
	 * This is done by setting alpha=0.99 for all objects that has alpha=1.
	 * In this case all objects will be rendered by one draw call.
	 * When use99alpha=false the number of draw call may be much more
	 *(the number of draw calls depends on objects order in display list)
	 */
	public static var use99alpha:Bool=false;

	/**
	 * Play sounds, triggered by the event "gafPlaySound" in a frame of the GAFMovieClip.
	 */
	public static var autoPlaySounds:Bool=true;

	/**
	 * Indicates if mipMaps will be created for PNG textures(or enabled for ATF textures).
	 */
	public static var useMipMaps:Bool=false;

	public static var useDeviceFonts:Bool=false;

	public static var maxAlpha(get_maxAlpha, null):Float;
 	private static function get_maxAlpha():Float
	{
		return GAF.use99alpha ? 0.99:1;
	}
}