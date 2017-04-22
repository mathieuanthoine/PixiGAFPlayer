Pixi GAF Player
=================

What is Pixi GAF Player?
-----------------

Pixi GAF Player is a Javascript library that allows developer easily to play back animations in GAF format using [PixiJs][1] HTML5 engine.

Pixi GAF player is developed with [Haxe Toolkit][15]. The code is an adaptation of the [Starling GAF Player][12] code wrote in ActionScript 3.

At the moment, Pixi GAF Player is avalaible for the [Haxe version of PixiJs][14].
A pure js library will be available soon for Javascript developers.

Pixi GAF Player is still at a early stage of development, supported features match with the [availables demos][17]. Also read Requirements of GAF Pixi Player below.

What is GAF?
-----------------

GAF is a solution that allows porting animations created in Adobe Animate or Flash Pro into an open format GAF and play back them in different popular frameworks, such as Starling, Unity3d, Cocos2d-x and other. [More info...][2]

What are the main features of GAF?
-----------------
* Designed as “What you see in Animate/Flash is what you get in GAF”;
* Doesn’t require additional technical knowledge from animators, designers and artists;
* Allows to port existing Flash Animations without special preparation before porting;
* [Supports 99% of what can be created in Animate/Flash Pro][6];
* Small size due to storing only unique parts of the animation in a texture atlas and a highly compressed binary config file describing object positions and transformations;
* High performance due to numerous optimizations in conversion process and optimized playback libraries;

What are the integral parts of GAF?
-----------------

GAF consist of [SWF to GAF Converter][3], [GAF Format][4], and [GAF Playback Libraries][5].

What is SWF to GAF Converter?
-----------------

GAF Converter is a tool for conversion animations from the SWF files into the [GAF format][4]. It is available as [standalone application GAF Converter][7], Unity GAF Converter and GAF Publisher for Animate/Flash Pro. [More info…][3]

What is GAF Format?
-----------------

GAF stands for Generic Animation Format. It is an extended cut-out animation format. It was designed to store animations, converted from SWF format into open format, that can be played using any framework/technology on any platform. [More info…][4]

How do I create GAF animation?
-----------------

Use Animate or Flash Pro to create an animation in a way that you familiar with. There is no restrictions on document structure. Then you have to convert your animation using [Standalone GAF Converter][7].

What are the supported features of Animate/Flash Pro?
-----------------

GAF Converter can convert 99% of what can be done in Flash Pro. Vector and Raster graphics; Classic, Motion, Shape and Path(Guide) Tweens; Masks; Filters and [more…][6]

How does the conversion work?
-----------------

GAF Converter has two conversion modes: Plain and Nesting. Each mode is suited for certain tasks and has its own features. [More info…][8]

Where I can find examples of using GAF?
-----------------

You can find several demo projects in demo directory [here][17].

Requirements of Pixi GAF Library:
-----------------

* You need to use Haxe-Pixi and PixiJS v4
* Configure the [GAF Converter][17] as you see on screenshots below 

  * Click on the configuration button
  <img src="https://github.com/mathieuanthoine/PixiGAFPlayer/blob/dev/imgs/Configuration.PNG">
  
  * Uncheck the save as *.Zip option
  <img src="https://github.com/mathieuanthoine/PixiGAFPlayer/blob/dev/imgs/saveAsZip.PNG">
  
  * Uncheck the compress *.gaf option
  <img src="https://github.com/mathieuanthoine/PixiGAFPlayer/blob/dev/imgs/compress.PNG">

Links and resources:
-----------------

* [Official Homepage][10]
* [GAF documentation][13]
* [FAQ page][11]
* [PixiJS][1]


[1]: http://www.pixijs.com/
[2]: http://gafmedia.com/documentation/what-is-gaf
[3]: http://gafmedia.com/documentation/what-is-gaf-converter
[4]: http://gafmedia.com/documentation/what-is-gaf-format
[5]: http://gafmedia.com/documentation/what-is-gaf-playback-library
[6]: http://gafmedia.com/documentation/supported-features-of-the-flash-pro
[7]: http://gafmedia.com/documentation/standalone/overview
[8]: http://gafmedia.com/documentation/how-does-the-conversion-work
[10]: http://gafmedia.com
[11]: http://gafmedia.com/faq
[12]: https://github.com/CatalystApps/StarlingGAFPlayer
[13]: http://gafmedia.com/documentation
[14]: https://github.com/pixijs/pixi-haxe
[15]: http://haxe.org/
[16]: https://gafmedia.com/downloads
[17]: https://github.com/mathieuanthoine/PixiGAFPlayer/tree/master/demo


