package com.github.mathieuanthoine.gaf;

import com.github.haxePixiGAF.core.GAFLoader;
import com.github.haxePixiGAF.core.ZipToGAFAssetConverter;
import com.github.haxePixiGAF.data.GAFBundle;
import com.github.haxePixiGAF.data.GAFGFXData;
import com.github.haxePixiGAF.data.GAFTimeline;
import com.github.haxePixiGAF.display.GAFImage;
import com.github.haxePixiGAF.display.GAFMovieClip;
import com.github.haxePixiGAF.display.GAFTextField;
import com.github.haxePixiGAF.display.GAFTexture;
import com.github.haxePixiGAF.display.IGAFTexture;
import com.github.haxePixiGAF.events.GAFEvent;
import haxe.Timer;
import haxe.ds.ObjectMap;
import js.Browser;
import js.Lib;
import js.html.CanvasElement;
import js.html.MouseEvent;
import pixi.core.display.Container;
import pixi.core.math.Matrix;
import pixi.core.renderers.Detector;
import pixi.core.renderers.webgl.WebGLRenderer;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.InteractionEvent;
import pixi.loaders.LoaderOptions;

/**
 * @author Mathieu Anthoine
 */

class Main
{

	private var renderer:WebGLRenderer;
	private var stage:Container;
	
	private static var subtitles: Array<String> = 
		[
			"- Our game is on fire!",
			"- GAF Team, there is a job for us!",
			"- Go and do your best!"
		];
	
	private var gafMovieClip: GAFMovieClip;

	private static function main ():Void
	{
		new Main();
	}

	/**
	 * création du jeu
	*/
	private function new ()
	{
		renderer = Detector.autoDetectRenderer(700, 400, {backgroundColor : 0xFFFFFF});
		Browser.document.body.appendChild(renderer.view);

		stage = new Container();
		
		new Perf("TL");
		
		var converter: ZipToGAFAssetConverter = new ZipToGAFAssetConverter();
		converter.once(GAFEvent.COMPLETE, onConverted);		
		converter.convert("fireman/fireman.gaf");
		
	}
	
	private function onConverted (pEvent:Dynamic):Void {

		var bundle:GAFBundle = cast(pEvent.target, ZipToGAFAssetConverter).gafBundle;

		gafMovieClip = new GAFMovieClip(bundle.getGAFTimeline("fireman"));
		gafMovieClip.on("showSubtitles", onShow);
		gafMovieClip.on("hideSubtitles", onHide);
		gafMovieClip.play(true);

		stage.addChild(gafMovieClip);
		
		Browser.window.requestAnimationFrame(gameLoop);
		
	}
	
	private function onHide(pEvent:Dynamic): Void
	{
		cast(gafMovieClip.getChildByName("subtitles_txt"),GAFTextField).text = "";
	}

	private function onShow(pEvent: Dynamic): Void
	{
		cast(gafMovieClip.getChildByName("subtitles_txt"), GAFTextField).text = subtitles[Std.int(pEvent.data) - 1];
	}
	
	private function gameLoop(pIdentifier:Float)
	{
		Browser.window.requestAnimationFrame(gameLoop);
		renderer.render(stage);
	}

}