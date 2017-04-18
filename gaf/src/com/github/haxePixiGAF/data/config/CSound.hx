package com.github.haxePixiGAF.data.config;

/**
 * TODO
 * @author Mathieu Anthoine
 * @private
 */
class CSound
{
	public static inline var GAF_PLAY_SOUND:String="gafPlaySound";
	public static inline var WAV:Int=0;
	public static inline var MP3:Int=1;

	public var soundID:Int;
	public var linkageName:String;
	public var source:String;
	public var format:Int;
	public var rate:Int;
	public var sampleSize:Int;
	public var sampleCount:Int;
	public var stereo:Bool=false;
	//public var sound:Sound;
}