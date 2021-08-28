package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

#if web
import openfl.utils.Assets;
#end

using StringTools;

// port of the first (only) game wewmu/snohq made in flash to haxeflixel

class RatPlayState extends MusicBeatState
{

	// RAT SHIT
	static var ratArray:Array<String> = ['', 'hexley/', 'tayto/', 'klasky/', 'soy/', 'nik/'];
	static var ratSoundArray:Array<String> = ['', 'hexley/', 'tayto/', 'klasky/', 'soy/', 'nik/'];
	static var ratArrayUneditedLength:Int = -1;
	static var frarlyRatArray:Array<Array<String>> = [];

	// BG COLOR SHIT //
	// FOR ACTUAL FLXCOLOR INSTANCES vvv
	static var colorArray:Array<FlxColor> = [FlxColor.RED, FlxColor.WHITE, FlxColor.BLACK];
	static var colorArrayUneditedLength:Int = -1;
	// FOR COLOR CODES TO BE CONVERTED ON RUN
	static var frarlyColorArray:Array<String> = [];

	var bg:FlxSprite;
	var rate:FlxSprite;
	var rateRealHitbox:FlxSprite;

	var ratButton:FlxSprite;
	var colorButton:FlxSprite;
	var ratButtonRealHitbox:FlxSprite;
	var colorButtonRealHitbox:FlxSprite;

	var bgColorAlt:Bool = false;

	var noReact:Bool = false; // no react on mouse button being held THEN dragged overtop of rat to mimic flash button behavior
	var currentlySquished:Bool = false; // ditto. just shit to mimic flash version behavior.

	override function create()
	{
		FlxG.mouse.visible = true;

		// custom color/rat mod support I decided to waste time on for some reason

		// LOAD CUSTOM COLORS
		if (colorArrayUneditedLength == -1)
			colorArrayUneditedLength = colorArray.length;

		if (frarlyColorArray.length <= 0)
		{
			var tempTextColorArray = CoolUtil.coolTextFile(Paths.txt('customBgColors', 'ratsquisher'));

			if (tempTextColorArray[0] == "COLOR  --  COMMENT/NAME")
				tempTextColorArray.remove("COLOR  --  COMMENT/NAME");

			for (i in tempTextColorArray)
			{
				frarlyColorArray.push(i.split('--')[0].trim());
			}

		}

		if (frarlyColorArray.length > 0 && colorArray.length == colorArrayUneditedLength)
			for (i in frarlyColorArray)
				{
					var hexToColor:FlxColor = FlxColor.fromString(i);
					colorArray.push(hexToColor);
				}

		// LOAD CUSTOM RATS
		if (ratArrayUneditedLength == -1)
			ratArrayUneditedLength = ratArray.length;

		if (frarlyRatArray.length <= 0)
		{
			var tempTextRatArray = CoolUtil.coolTextFile(Paths.txt('customRats', 'ratsquisher'));

			if (tempTextRatArray[0] == "RAT FOLDER NAME  --  customSound/ogSound")
				tempTextRatArray.remove("RAT FOLDER NAME  --  customSound/ogSound");

			for (i in tempTextRatArray)
			{

				var tempI:Array<String> = [];
				var tempSplit = i.split('--');
				for (a in tempSplit)
					tempI.push(a.trim());

				frarlyRatArray.push(tempI);

			}

		}

		if (frarlyRatArray.length > 0 && ratArray.length == ratArrayUneditedLength)
			for (i in frarlyRatArray)
				{
					var imagePath:String = '';
					var soundPath:String = '';

					imagePath = i[0] + '/';

					ratArray.push(imagePath);

					if (i[1].trim() == 'customSound')
					{
						ratSoundArray.push(imagePath);
					}
					else
					{
						ratSoundArray.push('');
					}
				}

		// Actual game code and initialization of stage goes from here on

		if (FlxG.save.data.ratsUnlocked.length > 0)
		{
			//var tempArray:Array<String> = ratArray;
			//ratArray = tempArray.concat(FlxG.save.data.ratsUnlocked);

			var tempArray:Array<String> = FlxG.save.data.ratsUnlocked;
			for (i in tempArray)
			{
				ratArray.insert(1, i);
				ratSoundArray.insert(1, i);
			}
		}

		if (FlxG.save.data.currentRat > ratArray.length)
			FlxG.save.data.currentRat = 0;

		if (FlxG.save.data.ratCurrentColor > colorArray.length)
			FlxG.save.data.ratCurrentColor = 0;

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Playing Rat Squisher", null, 'rat');
		#end

		// freestyle egg
		/*if (FlxG.random.bool(20))
		{
			ratArray[FlxG.save.data.currentRat] = 'freestyle/';
			bgColorAlt = true;
		}*/

		//ratArray[FlxG.save.data.currentRat] = 'soy/';

		//if (!FlxG.sound.music.playing)
		//{
		FlxG.sound.playMusic(Paths.music('LikeDrake', 'ratsquisher'), 1, true);
		//}

		//persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		bg.color = colorArray[FlxG.save.data.ratCurrentColor];
		add(bg);

		rate = new FlxSprite(0, 0).loadGraphic(Paths.image(ratArray[FlxG.save.data.currentRat] + 'ratsquish1', 'ratsquisher'));
		rate.antialiasing = true;
		rate.scale.x = 1.5;
		rate.scale.y = rate.scale.x;
		rate.updateHitbox();
		rate.screenCenter(Y);
		rate.x = FlxG.width - rate.width;
		add(rate);


		// I wanted to fix AND tighten the rat hitbox, but I honestly think this size is fine
		// still fixed it tho obvs

		//rateRealHitbox = new FlxSprite(0, 0).makeGraphic(Std.int(rate.width - 100), Std.int(rate.height - 100), FlxColor.WHITE);
		rateRealHitbox = new FlxSprite(0, 0).makeGraphic(Std.int(rate.width), Std.int(rate.height), FlxColor.WHITE);
		rateRealHitbox.x = rate.x;
		//rateRealHitbox.y = rate.y + 65;
		rateRealHitbox.y = rate.y;
		rateRealHitbox.visible = false;
		//rateRealHitbox.alpha = 0.5;
		add(rateRealHitbox);


		ratButton = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/RatSelect', 'ratsquisher'));
		ratButton.antialiasing = true;
		ratButton.scale.x = 0.4;
		ratButton.scale.y = ratButton.scale.x;
		ratButton.updateHitbox();
		ratButton.y = FlxG.height - ratButton.height - 25;
		ratButton.x += 25;
		add(ratButton);

		ratButtonRealHitbox = new FlxSprite(0, 0).makeGraphic(Std.int(ratButton.width), Std.int(ratButton.height), FlxColor.WHITE);
		ratButtonRealHitbox.x = ratButton.x;
		ratButtonRealHitbox.y = ratButton.y;
		ratButtonRealHitbox.visible = false;
		add(ratButtonRealHitbox);

		colorButton = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/BackgroundColorSelect', 'ratsquisher'));
		colorButton.antialiasing = true;
		colorButton.scale.x = 0.4;
		colorButton.scale.y = colorButton.scale.x;
		colorButton.updateHitbox();
		colorButton.y = ratButton.y;
		colorButton.x = ratButton.x + ratButton.width + 25;
		add(colorButton);

		colorButtonRealHitbox = new FlxSprite(0, 0).makeGraphic(Std.int(colorButton.width), Std.int(colorButton.height), FlxColor.WHITE);
		colorButtonRealHitbox.x = colorButton.x;
		colorButtonRealHitbox.y = colorButton.y;
		colorButtonRealHitbox.visible = false;
		add(colorButtonRealHitbox);

		super.create();

		FlxG.mouse.visible = true;
	}

	override function update(elapsed:Float)
	{

		if (controls.BACK)
		{
			FlxG.mouse.visible = false;

			if (FlxG.random.bool(1))
				FlxG.sound.play(Paths.sound('cancelMenuAlt'));
			else
				FlxG.sound.play(Paths.sound('cancelMenu'));

			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.mouse.overlaps(ratButtonRealHitbox))
		{

			if (FlxG.mouse.overlaps(ratButtonRealHitbox) && FlxG.mouse.justPressed)
			{
				if (FlxG.save.data.currentRat != ratArray.length - 1)
					FlxG.save.data.currentRat += 1;
				else
					FlxG.save.data.currentRat = 0;

				rate.loadGraphic(Paths.image(ratArray[FlxG.save.data.currentRat] + 'ratsquish1', 'ratsquisher'));
				FlxG.save.flush(); // MAKE SURE RAT IS SAVED
			}
			else if (FlxG.mouse.overlaps(ratButtonRealHitbox) && FlxG.mouse.justPressedRight)
			{
				if (FlxG.save.data.currentRat != 0)
					FlxG.save.data.currentRat -= 1;
				else
					FlxG.save.data.currentRat = ratArray.length - 1;

				rate.loadGraphic(Paths.image(ratArray[FlxG.save.data.currentRat] + 'ratsquish1', 'ratsquisher'));
				FlxG.save.flush(); // MAKE SURE RAT IS SAVED
			}
			else if (FlxG.mouse.overlaps(ratButtonRealHitbox) && !FlxG.mouse.justPressed)
			{
				ratButton.loadGraphic(Paths.image('ui/RatSelectHover', 'ratsquisher'));
			}

		}
		else if (FlxG.mouse.overlaps(colorButtonRealHitbox))
		{
			if (FlxG.mouse.overlaps(colorButtonRealHitbox) && FlxG.mouse.justPressed)
			{
				if (FlxG.save.data.ratCurrentColor != colorArray.length - 1)
					FlxG.save.data.ratCurrentColor += 1;
				else
					FlxG.save.data.ratCurrentColor = 0;

				bg.color = colorArray[FlxG.save.data.ratCurrentColor];
				FlxG.save.flush(); // MAKE SURE COLOR IS SAVED
			}
			else if (FlxG.mouse.overlaps(colorButtonRealHitbox) && FlxG.mouse.justPressedRight)
			{
				if (FlxG.save.data.ratCurrentColor != 0)
					FlxG.save.data.ratCurrentColor -= 1;
				else
					FlxG.save.data.ratCurrentColor = colorArray.length - 1;

				bg.color = colorArray[FlxG.save.data.ratCurrentColor];
				FlxG.save.flush(); // MAKE SURE COLOR IS SAVED
			}
			else if (FlxG.mouse.overlaps(colorButtonRealHitbox) && !FlxG.mouse.justPressed)
			{
				colorButton.loadGraphic(Paths.image('ui/BackgroundColorSelectHover', 'ratsquisher'));
			}
		}
		else
		{

			ratButton.loadGraphic(Paths.image('ui/RatSelect', 'ratsquisher'));
			colorButton.loadGraphic(Paths.image('ui/BackgroundColorSelect', 'ratsquisher'));

			if ((FlxG.mouse.overlaps(rateRealHitbox) && !FlxG.mouse.pressed && !noReact) || (!FlxG.mouse.overlaps(rateRealHitbox) && currentlySquished))
			{
				rate.loadGraphic(Paths.image(ratArray[FlxG.save.data.currentRat] + 'Rat-Alert', 'ratsquisher'));
			}
			else if (FlxG.mouse.overlaps(rateRealHitbox) && FlxG.mouse.pressed && (!noReact || currentlySquished))
			{

				if (FlxG.mouse.justPressed)
				{
					rate.loadGraphic(Paths.image(ratArray[FlxG.save.data.currentRat] + 'ratsquish2', 'ratsquisher'));
					FlxG.sound.play(Paths.sound(ratSoundArray[FlxG.save.data.currentRat] + 'rat_squish', 'ratsquisher'));
					currentlySquished = true;
				}
				else
				{
					rate.loadGraphic(Paths.image(ratArray[FlxG.save.data.currentRat] + 'Squosh', 'ratsquisher'));
				}

			}
			else
			{
				rate.loadGraphic(Paths.image(ratArray[FlxG.save.data.currentRat] + 'ratsquish1', 'ratsquisher'));

				if (FlxG.mouse.pressed)
				{
					noReact = true;
				}

			}

			if (FlxG.mouse.justReleased)
			{
				noReact = false;
				currentlySquished = false;
			}

		}

		super.update(elapsed);

	}

}
