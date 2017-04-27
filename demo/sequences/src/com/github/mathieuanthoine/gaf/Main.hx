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
	
	private var _gafMovieClip: GAFMovieClip;
	
	private static function main ():Void
	{
		new Main();
	}

	/**
	 * création du jeu
	*/
	private function new ()
	{
		renderer = Detector.autoDetectRenderer(800, 600, {backgroundColor : 0x999999});
		Browser.document.body.appendChild(renderer.view);

		stage = new Container();
		
		new Perf("TL");
		
		var converter: ZipToGAFAssetConverter = new ZipToGAFAssetConverter();
		converter.on(GAFEvent.COMPLETE, onConverted);		
		converter.convert("RedRobot/RedRobot.gaf");
		
	}
	
	private function onConverted (pEvent:Dynamic):Void {

		var gafBundle:GAFBundle = cast(pEvent.target, ZipToGAFAssetConverter).gafBundle;
		var gafTimeline: GAFTimeline = gafBundle.getGAFTimeline("RedRobot");
		
		_gafMovieClip = new GAFMovieClip(gafTimeline);
		setSequence("stand");
		
		stage.addChild(_gafMovieClip);
		
		_gafMovieClip.interactive = true;
		
		_gafMovieClip.on("click", onClick);
		Browser.window.requestAnimationFrame(gameLoop);
		
	}
	
	private function setSequence(sequence: String): Void
	{
		_gafMovieClip.setSequence(sequence);
		cast(_gafMovieClip.getField("sequence"),GAFTextField).text = sequence;
	}
	
	private function onClick(pEvent: MouseEvent): Void
	{	
		if (_gafMovieClip.currentSequence == "walk")
		{
			setSequence("stand");
		}
		else
		{
			setSequence("walk");
		}
	}
	
	private function gameLoop(pIdentifier:Float)
	{
		Browser.window.requestAnimationFrame(gameLoop);
		renderer.render(stage);
	}

}