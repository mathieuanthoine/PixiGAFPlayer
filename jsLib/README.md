Pixi GAF Player for Pure Javascript
=================

If you are a javascript developer and want to use the Pixi GAF Player, it is possible event if it has been developed in Haxe.

What changes ?
-----------------

* You need to include the PixiGAFPlayer.js in your html page : <script src="lib/PixiGAFPlayer.min.js"></script>
* To simplify access in Javascript, the whole classes are under the GAF package
* Only these classes are exposed to Javascript (PR if you need more):
	* GAF.ZipToGAFAssetConverter
	* GAF.GAFEvent
	* GAF.GAFTimeline
	* GAF.GAFBundle
	* GAF.GAFMovieClip
	* GAF.GAFImage
	* GAF.GAFTextField
	
Example
-----------------

A simple pure [Javascript demo](https://github.com/mathieuanthoine/PixiGAFPlayer/tree/master/demo/js) is available.

