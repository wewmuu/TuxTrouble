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

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxSpriteGroup;

	public static var curSubmenu:Int = 0; // current submenu

	public static var diffSelectMod = 0;

	// These are static so that when returning to the main menu it will be in the
	// last submenu it was in, reducing the code I need to do.
	static var optionShit:Array<String> = ['storymode', 'freeplay', 'remix', 'extras', 'stk', 'options'];
	static var optionShitFilePrefix:String = 'TT_';
	static var optionShitArtFilenames:Array<String> = ['StoryMode', 'Freeplay', 'Freestyle', 'Extras', 'STK', 'Options'];

	static var optionShitDisplay:Array<String> = ['storymode', 'freeplay', 'remix', 'extras', 'supertuxkart', 'options']; // these are the names the menu item text uses. These are separate for potential translation purposes. For English, they pretty much just match the names used for switching states.

	// WARNING: optionShit, optionShitArtFilenames, and optionShitDisplay should be of the same length. I DO NOT check this for you and it will NOT throw a detailed exception if you make a mistake!

	static var flashColor:FlxColor = 0xFFff5aab; // this looks okay for now, may change later
	static var trollBG_variant:String = 'pe';
	static var menuHeaderText:String = 'TUX TROUBLE';
	static var rpcText:String = 'On the Main Menu';

	public static var firstStartMainMenu:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.3" + nightly;
	public static var gameVer:String = "0.2.7.1";

	//public static var tuxTroubleVer:String = '1.5';

	public static var tuxTroubleVer:String = '2.3';
	public static var tuxTroubleVerNum:Float = 2.3;
	public static var tuxTroubleVerTag:String = '';

	//public static var tuxTroubleVer:String = '2.0';

	#if !DEMOBUILD
	public static var isDemoBuild = false;
	#else
	public static var isDemoBuild = true;
	#end

	var bg:TrollBG;
	var bgFlash:FlxSprite;
	//var camFollow:FlxObject;
	//public static var allowPlayerControl:Bool = false;
	var allowPlayerControl:Bool = false;

	var menuArt:FlxSprite;
	var menuArtSwap:FlxSprite;
	var menuArtSwapTween:FlxTween;
	var menuArtSwapTweenIsFinished:Bool = false;
	static var menuArtFinalX:Float = -300;

	var menuHeader:FlxText;

	// lazy trophy shit
	var trophyShelf:FlxSprite;

	var storyTrophy:FlxSprite;
	var storyTrophyConditionMet:Bool = false;
	var storyTrophyImage:String = 'storyEasy';

	var freestyleTrophy:FlxSprite;
	var freestyleTrophyConditionMet:Bool = false;
	var freestyleTrophyImage:String = 'FreestyleTrophyEasy';

	var trollingTrophy:FlxSprite;
	var trollingTrophyConditionMet:Bool = false;
	var trollingTrophyImage:String = 'LENNYTROPHY';

	var ratTrophy:FlxSprite;
	var ratTrophyConditionMet:Bool = false;

	override function create()
	{

		FlxG.mouse.visible = false; // fuck you haxeflixel, don't ruin my beutiful menu

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence(rpcText, null);
		#end

		#if web
		// fuck you html5
		Assets.loadLibrary('ratsquisher');
		Assets.loadLibrary('payloads');
		Assets.loadLibrary('gallery');
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('recycler'));
		}

		diffSelectMod = 0; // I only want this to persist when leaving the main menu state.

		persistentUpdate = persistentDraw = true;

		bg = new TrollBG(0, 0);
		bg.loadGraphic(Paths.image(trollBG_variant));
		bg.setGraphicSize(Std.int(bg.width * 1.1), Std.int(bg.height * 1.1));
		bg.updateHitbox();
		bg.antialiasing = true;
		add(bg);

		//camFollow = new FlxObject(0, 0, 1, 1);
		//add(camFollow);

		bgFlash = new FlxSprite(0, 0);
		bgFlash.loadGraphic(Paths.image('peDesat'));
		bgFlash.setGraphicSize(Std.int(bgFlash.width * 1.1), Std.int(bgFlash.height * 1.1));
		bgFlash.updateHitbox();
		bgFlash.visible = false;
		bgFlash.antialiasing = true;
		//bgFlash.color = 0xFFfd719b;
		//bgFlash.color = 0xFFff5aab;
		bgFlash.color = flashColor;
		add(bgFlash);
		// bgFlash.scrollFactor.set();

		menuItems = new FlxSpriteGroup();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		menuArt = new FlxSprite(-FlxG.width, 0).loadGraphic(Paths.image('tuxMenu/' + optionShitFilePrefix + optionShitArtFilenames[curSelected]));
		menuArt.antialiasing = true;
		//menuArt.scale.x = 1.5;
		//menuArt.scale.y = 1.5;
		menuArt.updateHitbox();
		menuArt.screenCenter(Y);

		add(menuArt);

		menuArtSwap = new FlxSprite(-FlxG.width, 0).loadGraphic(Paths.image('tuxMenu/' + optionShitFilePrefix + optionShitArtFilenames[curSelected]));
		menuArtSwap.antialiasing = true;
		//menuArtSwap.scale.x = 1.5;
		//menuArtSwap.scale.y = 1.5;
		menuArtSwap.updateHitbox();
		menuArtSwap.screenCenter(Y);

		add(menuArtSwap);

		menuHeader = new FlxText(0, 20, 0, menuHeaderText, 12);
		menuHeader.setFormat("friday night", 118, FlxColor.WHITE, CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
		menuHeader.borderSize = 3;
		menuHeader.antialiasing = true;
		menuHeader.updateHitbox();
		menuHeader.x = menuArt.getGraphicMidpoint().x - menuHeader.getGraphicMidpoint().x + FlxG.width - 170; // there are probably better ways for me to figure this out idk I just tried shit until it put everything where I wanted it

		#if web
		menuHeader.y -= 20;
		#end

		add(menuHeader);

		trophySetup();

		trophyShelf = new FlxSprite(-13, menuArt.y + menuArt.height + 5).loadGraphic(Paths.image('tuxMenu/trophies/shelf'));
		trophyShelf.antialiasing = true;
		//trophyShelf.scale.x = 0.26;
		//trophyShelf.scale.y = trophyShelf.scale.x;
		//trophyShelf.updateHitbox();

		if (storyTrophyConditionMet || freestyleTrophyConditionMet || trollingTrophyConditionMet || ratTrophyConditionMet)
			trophyShelf.visible = true;
		else
			trophyShelf.visible = false;

		add(trophyShelf);

		storyTrophy = new FlxSprite(25, menuArt.y + menuArt.height).loadGraphic(Paths.image('tuxMenu/trophies/' + storyTrophyImage));
		storyTrophy.antialiasing = true;
		storyTrophy.scale.x = 0.26;
		storyTrophy.scale.y = storyTrophy.scale.x;
		storyTrophy.updateHitbox();

		if (storyTrophyConditionMet)
			storyTrophy.visible = true;
		else
			storyTrophy.visible = false;

		add(storyTrophy);

		freestyleTrophy = new FlxSprite(storyTrophy.x + storyTrophy.width, storyTrophy.y).loadGraphic(Paths.image('tuxMenu/trophies/' + freestyleTrophyImage));
		freestyleTrophy.antialiasing = true;
		freestyleTrophy.setGraphicSize(-1, Std.int(storyTrophy.height));
		freestyleTrophy.updateHitbox();

		if (freestyleTrophyConditionMet)
			freestyleTrophy.visible = true;
		else
			freestyleTrophy.visible = false;

		add(freestyleTrophy);

		trollingTrophy = new FlxSprite(freestyleTrophy.x + freestyleTrophy.width, freestyleTrophy.y).loadGraphic(Paths.image('tuxMenu/trophies/' + trollingTrophyImage));
		trollingTrophy.antialiasing = true;
		trollingTrophy.setGraphicSize(-1, Std.int(freestyleTrophy.height));
		trollingTrophy.updateHitbox();

		if (trollingTrophyConditionMet)
			trollingTrophy.visible = true;
		else
			trollingTrophy.visible = false;

		add(trollingTrophy);

		ratTrophy = new FlxSprite(trollingTrophy.x + trollingTrophy.width, trollingTrophy.y).loadGraphic(Paths.image('tuxMenu/trophies/PetRat'));
		ratTrophy.antialiasing = true;
		ratTrophy.setGraphicSize(-1, Std.int(trollingTrophy.height));
		ratTrophy.updateHitbox();

		if (ratTrophyConditionMet)
			ratTrophy.visible = true;
		else
			ratTrophy.visible = false;

		add(ratTrophy);

		var tweenDur:Float = 0;

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSpriteGroup = new FlxSpriteGroup(FlxG.width * 1.6, menuArt.y - 20);


			//var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6).loadGraphic(Paths.image('tuxMenu/TT_MENU_STORYMODE_1'));
			//var menuItem:FlxSprite = new FlxSprite((FlxG.width/2)+200, FlxG.height * 1.6).loadGraphic(Paths.image('tuxMenu/TT_MENU_STORYMODE_1'));
			//var menuItem:FlxSprite = new FlxSprite((FlxG.width/2)+200, menuArt.y - 20).loadGraphic(Paths.image('tuxMenu/TT_MENU_STORYMODE_1'));
			//var menuItem:FlxSprite = new FlxSprite(menuArt.x + menuArt.width, menuArt.y - 20).loadGraphic(Paths.image('tuxMenu/TT_MENU_STORYMODE_1'));


			//var menuItemBG:FlxSprite = new FlxSprite(FlxG.width * 1.6, menuArt.y - 20).loadGraphic(Paths.image('tuxMenu/TT_MENU_STORYMODE_1'));
			//var menuItemBG:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tuxMenu/TT_MENU_STORYMODE_1'));
			var menuItemBG:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tuxMenu/TT_MENU_OPTION'));
			menuItemBG.antialiasing = true;
			menuItemBG.scale.x = 0.9;
			menuItemBG.scale.y = 0.9;
			menuItemBG.updateHitbox();

			menuItem.add(menuItemBG);

			var menuItemText:FlxText = new FlxText(0, 10, 0, optionShitDisplay[i].toUpperCase(), 12); // use a separate array containing names of menu items for potential translation
			//menuItemText.setFormat("Koverwatch", 102, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
			menuItemText.setFormat("Koverwatch", 102, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			menuItemText.borderSize = 6;
			menuItemText.antialiasing = true;
			//menuItemText.alpha = 0.5;
			menuItemText.updateHitbox();
			menuItem.add(menuItemText);

			// this all kinda sucks but FlxTween will have a little soyjak fit if it is
			// passed something that isnt a FlxSprite or FlxSpriteGroup even if that item's
			// class is derived from FlxSprite or FlxSpriteGroup, so uhhhh :troll:
			menuItem.members[1].x = menuItem.x + menuItem.members[0].getMidpoint().x - menuItem.members[1].getMidpoint().x;

			//menuItem.frames = tex;
			//menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			//menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			//menuItem.animation.play('idle');

			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();

			if (i == curSelected)
				changeItem();

			//if (firstStartMainMenu)
			if (!allowPlayerControl) // if player control is locked
			{
				menuItem.y += (i * 161);

				//FlxTween.tween(menuArt,{x: menuArtFinalX},1 + (i * 0.25) ,{ease: FlxEase.expoInOut});
				if (i == 0)
					FlxTween.tween(menuArt,{x: menuArtFinalX},1.25 ,{ease: FlxEase.expoInOut});

				if (i < 4) // if the menu item will be on screen, do the tween
				{

					var braapDur:Float = 1 + (i * 0.25);

					tweenDur += braapDur;

					//FlxTween.tween(menuItem,{x: (menuArtFinalX + menuArt.width) - (i * 60)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut}); // the funnymove true being in a function called on tween end was an issue because this tween runs for each menuitem individually.
					FlxTween.tween(menuItem,{x: (menuArtFinalX + menuArt.width) - (i * 60)},braapDur ,{ease: FlxEase.expoInOut}); // the funnymove true being in a function called on tween end was an issue because this tween runs for each menuitem individually.

				}
				else
				{

					menuItem.y += (i * 161);
					menuItem.x = (menuArtFinalX + menuArt.width) - (i * 60);

				}

			}
			else
			{
				menuArt.x = -300;


				//menuItem.y = 60 + (i * 160);
				//menuItem.y += (i * 160);
				menuItem.y += (i * 161);
				menuItem.x = (menuArtFinalX + menuArt.width) - (i * 60);
			}
		}

		//FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer + " FNF - " + kadeEngineVer + " Kade Engine - " + tuxTroubleVer + " Tux Trouble", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		//changeItem();

		firstStartMainMenu = false;

		// this is best outside of the loop
		new FlxTimer().start(tweenDur/3, function(tmr:FlxTimer) // Delay player control until after tween.
		{
			allowPlayerControl = true; // we don't want to let the player control the menu until the tween is COMPLETELY finished
		});

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{

		if (allowPlayerControl && menuItems.members.length > 3)
		{
			menuItems.forEach(function(spr:FlxSprite)
			{

				if (curSelected < (menuItems.members.length-1) - 2)
				{
					spr.y = FlxMath.lerp(spr.y, (menuArt.y - 20) + (spr.ID * 161) - (curSelected * 161), 0.30);
					spr.x = FlxMath.lerp(spr.x, (menuArtFinalX + menuArt.width) - (spr.ID * 60) + (curSelected * 60), 0.30);
				}
				else if (curSelected >= (menuItems.members.length-1) - 2)
				{
					spr.y = FlxMath.lerp(spr.y, (menuArt.y - 20) + (spr.ID * 161) - ((menuItems.members.length-1-2) * 161), 0.30);
					spr.x = FlxMath.lerp(spr.x, (menuArtFinalX + menuArt.width) - (spr.ID * 60) + ((menuItems.members.length-1-2) * 60), 0.30);
				}

			});
		}

		if (bgFlash != null)
		{
			bgFlash.x = bg.x;
			bgFlash.y = bg.y;
		}

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin && allowPlayerControl)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK && curSubmenu == 0)
			{

				if (FlxG.random.bool(1))
					FlxG.sound.play(Paths.sound('cancelMenuAlt'));
				else
					FlxG.sound.play(Paths.sound('cancelMenu'));

				FlxG.switchState(new TitleState());
			}
			else if (controls.BACK && curSubmenu != 0) // switch to main menu if back is pressed in a sub-menu
			{
				setSubmenu(0);

				if (FlxG.random.bool(1))
					FlxG.sound.play(Paths.sound('cancelMenuAlt'));
				else
					FlxG.sound.play(Paths.sound('cancelMenu'));

				FlxG.switchState(new MainMenuState());
			}

			if (controls.ACCEPT && optionShit[curSelected] != 'stk')
			{

				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				if (optionShit[curSelected] == 'ratsquisher' && ratTrophyConditionMet)
					ratTrophy.loadGraphic(Paths.image('tuxMenu/trophies/PetRatClick'));

				remove(menuArtSwap);
				menuArtSwap.destroy();

				if (FlxG.save.data.flashing)
					FlxFlicker.flicker(bgFlash, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{

					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {x: FlxG.width * 1.6}, 0.25, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								remove(spr);
								spr.destroy();
							}
						});
					}

					else
					{

						if (FlxG.save.data.flashing)
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								goToState();
							});
						}
						else
						{
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								goToState();
							});
						}

					}

				});

			}
			else if (controls.ACCEPT && optionShit[curSelected] == 'stk')
			{

				FlxG.sound.play(Paths.sound('confirmMenu'));

				#if linux
				Sys.command('/usr/bin/xdg-open', ["https://supertuxkart.net/", "&"]);
				#else
				FlxG.openURL('https://supertuxkart.net/');
				#end

			}

		}

		super.update(elapsed);

		//menuItems.forEach(function(spr:FlxSprite)
		//{
			//spr.screenCenter(X);
		//});
	}

	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'storymode':
				//FlxG.switchState(new StoryMenuState());
				diffSelectMod = 0;
				FlxG.switchState(new DiffSelectState());
				trace("Story Menu Selected");

			case 'freeplay' | 'duetplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'remix':
				setSubmenu(1);
				FlxG.switchState(new MainMenuState());

			case 'extras':
				setSubmenu(2);
				FlxG.switchState(new MainMenuState());

			case 'smooth':
				diffSelectMod = 1;
				FlxG.switchState(new DiffSelectState());
				//loadFreeplaySong('Smooth', 2);

			case 'true trolling':
				diffSelectMod = 2;
				FlxG.switchState(new DiffSelectState());
				//loadFreeplaySong('True Trolling', 2);

			case 'memoriam':
				FlxG.switchState(new DaemonPayloads.MansionPayload());

			case 'ratsquisher':
				FlxG.switchState(new RatPlayState());

			case 'gallery':
				FlxG.switchState(new GalleryState());

			case 'credits':
				//LoadingState.loadAndSwitchState(new VideoState(Paths.webm('credits'), new MainMenuState()), true);
				FlxG.switchState(new VideoState(Paths.webm('credits'), new MainMenuState()));

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		// this if statement is (always was) useless now.
		//if (allowPlayerControl)
		//{
		var prevSelected = curSelected;
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		//}


		//menuItems.forEach(function(spr:FlxSprite)
		//{
			////spr.animation.play('idle');
			//spr.loadGraphic(Paths.image('tuxMenu/TT_MENU_STORYMODE_1'));

			//if (spr.ID == curSelected)// && allowPlayerControl) // I FINALLY figured out the cause of that fuckin camera stutter. It hardly matters now with us replacing the whole menu.
			//{
				////spr.animation.play('selected');
				//spr.loadGraphic(Paths.image('tuxMenu/TT_MENU_STORYMODE_2'));
				////camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			//}

			//spr.updateHitbox();
		//});

		menuItems.forEachOfType(FlxSpriteGroup, function(spr:FlxSpriteGroup)
		{
			spr.members[0].loadGraphic(Paths.image('tuxMenu/TT_MENU_OPTION'));

			if (spr.ID == curSelected) // I FINALLY figured out the cause of that fuckin camera stutter. It hardly matters now with us replacing the whole menu.
			{
				spr.members[0].loadGraphic(Paths.image('tuxMenu/TT_MENU_OPTION2'));
			}

			spr.members[0].updateHitbox();
		});

		if (allowPlayerControl && FlxG.save.data.flashing)
		{
			menuArtChange(prevSelected);
		}
		else if (allowPlayerControl && !FlxG.save.data.flashing) // the menuArt tween is so fast it could potentially be bad for photosensitives, so diable that if flashing is off.
		{
			menuArt.loadGraphic(Paths.image('tuxMenu/' + optionShitFilePrefix + optionShitArtFilenames[curSelected]));
		}

		if (ratTrophyConditionMet && optionShit[curSelected] == 'ratsquisher')
			ratTrophy.loadGraphic(Paths.image('tuxMenu/trophies/PetRatHover'));
		else if (ratTrophyConditionMet)
			ratTrophy.loadGraphic(Paths.image('tuxMenu/trophies/PetRat'));

	}

	function menuArtChange(prevSelected:Int = 0)
	{

		if (menuArtSwapTween != null && !menuArtSwapTweenIsFinished)
		{
			menuArtSwapTween.cancel();
			menuArt.loadGraphic(Paths.image('tuxMenu/' + optionShitFilePrefix + optionShitArtFilenames[prevSelected]));
			menuArtSwap.x = -FlxG.width;
		}

		menuArtSwapTweenIsFinished = false;

		menuArtSwap.loadGraphic(Paths.image('tuxMenu/' + optionShitFilePrefix + optionShitArtFilenames[curSelected]));

		menuArtSwapTween = FlxTween.tween(menuArtSwap,{x: menuArtFinalX},0.15 , {onComplete: function(flxTween:FlxTween)
		{
			menuArt.loadGraphic(Paths.image('tuxMenu/' + optionShitFilePrefix + optionShitArtFilenames[curSelected]));
			menuArtSwap.x = -FlxG.width;
			menuArtSwapTweenIsFinished = true;
		}});

	}

	public function setSubmenu(?submenu:Int)
	{

		if (submenu == null) // do nothing if no argument is passed
			return;

		switch (submenu)
		{

			case 0: // Main Menu

				optionShit = ['storymode', 'freeplay', 'remix', 'extras', 'stk', 'options'];
				optionShitDisplay = ['storymode', 'freeplay', 'remix', 'extras', 'supertuxkart', 'options']; // set separate names for menu items from what is used internally.
				//optionShitDisplay = optionShit; // use the same names as the state switch function for the menu item text
				optionShitFilePrefix = 'TT_';
				optionShitArtFilenames = ['StoryMode', 'Freeplay', 'Freestyle', 'Extras', 'STK', 'Options'];

				if (isDemoBuild) // niite remix menu not ready
				{
					optionShit.remove('remix');
					optionShitDisplay.remove('remix');
					optionShitArtFilenames.splice(2, 1);
				}

				flashColor = 0xFFff5aab;
				trollBG_variant = 'pe';
				menuHeaderText = 'TUX TROUBLE';
				rpcText = 'On the Main Menu';

			case 1: // Niite Freestyle Remix submenu

				optionShit = ['storymode', 'freeplay', 'options'];
				//optionShitDisplay = ['storymode', 'freeplay', 'options']; // set separate names for menu items from what is used internally.
				optionShitDisplay = optionShit; // use the same names as the state switch function for the menu item text
				optionShitFilePrefix = 'NF_';
				optionShitArtFilenames = ['StoryMode', 'Freeplay', 'Options'];

				trollBG_variant = 'peDesat';
				menuHeaderText = 'FREESTYLE';
				rpcText = 'In the Remix Menu';

			case 2: // Extras submenu

				optionShit = ['duetplay', 'smooth', 'ratsquisher', 'gallery', 'credits'];
				optionShitDisplay = ['duetplay', 'beta song', 'ratsquisher', 'gallery', 'credits']; // set separate names for menu items from what is used internally.
				//optionShitDisplay = optionShit; // use the same names as the state switch function for the menu item text
				optionShitArtFilenames = ['Duetplay', 'Placeholder', 'RatSquisher', 'Gallery', 'Credits'];

				if (DaemonPayloads.MansionPayload.canTrigger())
				{
					optionShit.push('memoriam');
					optionShitDisplay.push('...');
					optionShitArtFilenames.push('Placeholder');
				}

				if (isDemoBuild) // gallery and credits menus are not ready
				{
					optionShit.remove('gallery');
					optionShitDisplay.remove('gallery');
					optionShitArtFilenames.remove('Gallery');

					optionShit.remove('credits');
					optionShitDisplay.remove('credits');
					optionShitArtFilenames.remove('Credits');
				}

				#if debug
				var forceEnable:Bool = true;
				#else
				var forceEnable:Bool = false;
				#end

				if (FlxG.save.data.weekClearDifficultyTUX == 2 || forceEnable)
				{
					optionShit.insert(2, 'true trolling');
					optionShitDisplay.insert(2, 'truetrolling');
					optionShitArtFilenames.insert(2, 'TrueTrolling');
				}

				optionShitFilePrefix = 'TT_EX_';

				trollBG_variant = 'peBlue';
				menuHeaderText = 'EXTRAS';
				rpcText = 'In the Extras Menu';

		}

		curSubmenu = submenu;

	}

	public function loadFreeplaySong(songname:String, week:Int, ?diff:Int = 1) // p sure 1 corresponds to normal difficulty. A lot of this is copied and adapted from the freeplay menu. Song name should probably include spaces and caps.
	{

		// adjusting the song name to be compatible
		var songFormat = StringTools.replace(songname, " ", "-");
		switch (songFormat) {
			case 'Dad-Battle': songFormat = 'Dadbattle';
			case 'Philly-Nice': songFormat = 'Philly';
		}

		var poop:String = Highscore.formatSong(songFormat, diff);

		trace(poop);

		PlayState.SONG = Song.loadFromJson(poop, songname); // song name is parsed by function. No worries!
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = diff;
		PlayState.storyWeek = week;

		trace('CUR WEEK' + PlayState.storyWeek);
		LoadingState.loadAndSwitchState(new PlayState());

	}

	function trophySetup()
	{

		// story
		if (FlxG.save.data.weekClearTUX && FlxG.save.data.weekClearDifficultyTUX != -1)
		{
			storyTrophyConditionMet = FlxG.save.data.weekClearTUX;

			switch(FlxG.save.data.weekClearDifficultyTUX)
			{
				case 0:
					storyTrophyImage = 'storyEasy';
				case 1:
					storyTrophyImage = 'storyNormal';
				case 2:
					storyTrophyImage = 'storyHard';
			}

		}

		// freestyle
		if (FlxG.save.data.weekClearNIITE && FlxG.save.data.weekClearDifficultyNIITE != -1)
		{
			freestyleTrophyConditionMet = FlxG.save.data.weekClearNIITE;

			switch(FlxG.save.data.weekClearDifficultyNIITE)
			{
				case 0:
					freestyleTrophyImage = 'FreestyleTrophyEasy';
				case 1:
					freestyleTrophyImage = 'FreestyleTrophyNormal';
				case 2:
					freestyleTrophyImage = 'FreestyleTrophyHard';
			}

		}

		// true trolling
		if (FlxG.save.data.beatTrueTrolling || FlxG.save.data.beatTrueTrollingDuet)
		{

			trollingTrophyConditionMet = true;

			if (FlxG.save.data.beatTrueTrollingDuet)
				trollingTrophyImage = 'LENNYTROPHYDUET';
			else if (FlxG.save.data.beatTrueTrolling)
				trollingTrophyImage = 'LENNYTROPHY';

		}

		// rat
		if (FlxG.save.data.ratsUnlocked.length == 2)
			ratTrophyConditionMet = true;

	}

}
