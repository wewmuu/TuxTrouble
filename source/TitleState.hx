package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

import flixel.math.FlxMath;

//import Highscore;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{

	#if !DEMOBUILD
	public static var isDemoBuild = false;
	#else
	public static var isDemoBuild = true;
	#end

	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	public static var firstStartTitle:Bool = true;

	public static var soyjak =  FlxG.random.bool(1);

	override public function create():Void
	{
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: []});
		#end

		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		FlxG.save.bind('funkin', 'ninjamuffin99');

		KadeEngineData.initSave();

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		ModGlobals.currentDifficulty = FlxG.save.data.persistDiff; // LOAD PERSISTENT MOD DIFFICULTY

		// TUX TROUBLE MOD VERSION SHIT (We'll probably never update after 2.0, but you never know)

		if (FlxG.save.data.tuxTroubleVer != MainMenuState.tuxTroubleVer){ // mod version change? (Pops off for save data from all versions < 2.0 or 2.0_DEV or if a 2.0_DEV and 2.0 save swap because I'm too lazy to do a thorough check for something with so little consequence)

			// Do save versioning stuff first

			// Fix song highscores due to name changes
			if (FlxG.save.data.tuxTroubleVer == null){ // if we are on any pre-2.0_DEV version or it's a new save in which case none of the below will work anyway
				for (i in 0...2){

					// "Tutorial-Remix" changed to "Tutorial Remix" (In version 2.0_DEV)
					if (Highscore.songScores.exists(Highscore.formatSong('tutorial-remix', i))){
						Highscore.saveScore('Tutorial Remix', Highscore.getScore('Tutorial-Remix', i));
					}

					// "Floss" became "F.L.O.S.S" (In version 2.0_DEV)
					if (Highscore.songScores.exists(Highscore.formatSong('floss', i))){
						Highscore.saveScore('F.L.O.S.S', Highscore.getScore('Floss', i));
					}

					// "TUX" week changed from week 7 to week 1 (In version 1.5)
					if (Highscore.songScores.exists(Highscore.formatSong('week7', i))){
						Highscore.saveWeekScore(1, Highscore.getWeekScore(7, i), i);
					}

					// Save flags added for spoilers (in version 2.0_DEV)
					if (Highscore.getWeekScore(1, i) > 0 || Highscore.getWeekScore(7, i) > 0){ // If TUX week has been completed on ANY difficulty
						FlxG.save.data.weekClearTUX = true; // Mark the flag
						FlxG.save.data.trollingHide = false; // Unhide trolling
					}

				}

			}

			// Then update the save data version
			FlxG.save.data.tuxTroubleVer = MainMenuState.tuxTroubleVer; // set mod version
			FlxG.save.data.tuxTroubleVerNum = MainMenuState.tuxTroubleVerNum; // set mod version (float)
			FlxG.save.data.tuxTroubleVerTag = MainMenuState.tuxTroubleVerTag; // set mod version (string tag can be null)

		}


		// I moved this discord stuff to right before the intro so the save data
		// has a chance to load first. Otherwise the Discord RPC toggle does not
		// work as it will always return null before it is initialized.
		#if windows

		if (firstStartTitle){ // We really only want to start the discord client once... It might be harmful if we start multiple instances, but what do I know?
			DiscordClient.initialize();

			Application.current.onExit.add (function (exitCode) {
				FlxG.save.data.persistDiff = ModGlobals.currentDifficulty;
				FlxG.save.flush();
			 });
		}

		#end

		firstStartTitle = false;

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end
	}

	var logoBl:FlxSprite;

	var bg:TrollBG;

	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		persistentUpdate = true;

		//var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		//add(bg);

		bg = new TrollBG(0, 0);
		bg.loadGraphic(Paths.image('pe'));
		bg.setGraphicSize(Std.int(bg.width * 1.1), Std.int(bg.height * 1.1));
		bg.updateHitbox();
		//bg.screenCenter();

		//bg.updateDefaultPos(bg.x, bg.y);

		bg.antialiasing = true;
		add(bg);

		//logoBl = new FlxSprite(-150, -100);
		logoBl = new FlxSprite(-100, -50);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		add(gfDance);
		add(logoBl);

		titleText = new FlxSprite(120, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		//titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "wewmu\nsnohq\ncmyth\nsuperpositivep", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		//ngSpr = new FlxSprite(0, FlxG.height * 0.52);
		ngSpr = new FlxSprite(0, FlxG.height * 0.47);

		//ngSpr.loadGraphic(Paths.image('newgrounds_logo'));
		ngSpr.loadGraphic(Paths.image('freestyle_dev_team'));

		add(ngSpr);
		ngSpr.visible = false;
		//ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else { // fix for "presents" from kade upstream
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.music('recycler'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
			//Conductor.changeBPM(102);
			Conductor.changeBPM(113); // recycler bpm

			initialized = true;
		}

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			#if !switch
			NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			#end

			if (FlxG.save.data.flashing)
			{
				titleText.animation.play('press');
				// fuck you ninjamuffin and your stupid fucking corrupted fla. Update to adobe animate, dumbass.
				titleText.x += 6;
				titleText.y += 6;
			}

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				// Get current version of Tux Trouble

				var http = new haxe.Http("https://raw.githubusercontent.com/wewmuu/TuxTrouble/main/version.downloadMe");
				var returnedData:Array<String> = [];

				http.onData = function (data:String)
				{
					returnedData[0] = data.substring(0, data.indexOf(';'));
					returnedData[1] = data.substring(data.indexOf('-'), data.length);
				  	if (!MainMenuState.tuxTroubleVer.contains(returnedData[0].trim()) && !OutdatedSubState.leftState && MainMenuState.firstStartMainMenu && !isDemoBuild)
					{
						trace('outdated lmao! ' + returnedData[0] + ' != ' + MainMenuState.tuxTroubleVer);
						OutdatedSubState.needVer = returnedData[0];
						OutdatedSubState.currChanges = returnedData[1];
						FlxG.switchState(new OutdatedSubState());
					}
					else
					{
						FlxG.switchState(new MainMenuState());
					}
				}

				http.onError = function (error) {
				  trace('error: $error');
				  FlxG.switchState(new MainMenuState()); // fail but we go anyway
				}

				http.request();
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro && initialized)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?useSmaller:Bool = false)
	{
		for (i in 0...textArray.length)
		{
			//var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			//money.screenCenter(X);
			//money.y += (i * 60) + 200;
			//credGroup.add(money);
			//textGroup.add(money);

			var money:FlxText = new FlxText(0, (i * (64+32+16)) + 100, 0, textArray[i], 12);
			//money.scrollFactor.set();
			money.setFormat("friday night", 64+32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

			if (useSmaller)
			{
				money.y -= 16;
				money.setFormat("friday night", 64+16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			}


			//add(money);
			money.screenCenter(X);
			money.antialiasing = true;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String, ?aboveSmaller:Bool = false)
	{
		//var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		var coolText:FlxText = new FlxText(0, (textGroup.length * (64+32+16)) + 100, 0, text, 12);
		coolText.setFormat("friday night", 64+32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		coolText.screenCenter(X);
		coolText.antialiasing = true;

		if (aboveSmaller)
		{
			coolText.y -= 8;
		}

		//coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (logoBl != null)
		{
			logoBl.animation.play('bump');
		}

		danceLeft = !danceLeft;

		if (danceLeft && gfDance != null)
			gfDance.animation.play('danceRight');
		else if (gfDance != null)
			gfDance.animation.play('danceLeft');

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 1:
				//createCoolText(['wewmu', 'snohq', 'cmyth', 'superpositivep'], true); // maybe try to fit tuys and frarly here later.
				createCoolText(['wewmu      snohq', 'cmyth      frarly', 'hashbrowncow     superpositivep', 'tuys'], true); // maybe try to fit tuys and frarly here later.
			// credTextShit.visible = true;
			case 3:
				addMoreText('present', true);
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 4:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 5:
				if (Main.watermarks)
					if (soyjak)
						createCoolText(['Soy Engine', 'by']);
					else
						createCoolText(['Kade Engine', 'by']);
				else
					createCoolText(['In Partnership with']);
			case 7:
				if (Main.watermarks)
					if (soyjak)
						addMoreText('SoyContributors');
					else
						addMoreText('KadeDeveloper');
				else
				{
					//addMoreText('Freestyle Dev Team');
					addMoreText('Friday Niite Freestyle');

					ngSpr.visible = true;
				}
			// credTextShit.text += '\nNewgrounds';
			case 8:
				deleteCoolText();
				ngSpr.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();

			#if !DEMOBUILD
			case 9:
				createCoolText([curWacky[0]]);
			// credTextShit.visible = true;
			case 11:
				addMoreText(curWacky[1]);
			// credTextShit.text += '\nlmao';
			#else
			case 9:
				createCoolText(["This is non-representative"]);
			// credTextShit.visible = true;
			case 11:
				addMoreText("of the final product");
			// credTextShit.text += '\nlmao';
			#end

			case 12:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 13:
				//addMoreText('Friday');
				createCoolText(['Tux']);
			// credTextShit.visible = true;
			case 14:
				//addMoreText('Night');
				addMoreText('Trouble');
			// credTextShit.text += '\nNight';
			case 15:
				//addMoreText('Funkin'); // credTextShit.text += '\nFunkin';
				new FlxTimer().start(0.05, function(tmr:FlxTimer)
				{
					deleteCoolText();
					createCoolText(['OH']);
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						addMoreText('MY');
						new FlxTimer().start(0.2, function(tmr:FlxTimer)
						{
							addMoreText('GOD!');
							FlxG.log.add('I JUST POOPED!');
							trace('I JUST POOPED!');
						});
					});
				});

			case 16:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);

			ngSpr.destroy();

			skippedIntro = true;
		}
	}
}
