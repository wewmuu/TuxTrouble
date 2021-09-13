package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import lime.utils.Assets;

#if windows
import Discord.DiscordClient;
#end

class OptionsMenu extends MusicBeatState
{
	public static var instance:OptionsMenu;

	var selector:FlxText;
	var curSelected:Int = 0;

	var busSound:FlxSound;
	var busScore:Int = 0;

	var options:Array<OptionCategory> = [
		new OptionCategory("Gameplay", [
			new DFJKOption(controls),
			new DownscrollOption("Change the layout of the strumline."),
			new GhostTapOption("Ghost Tapping is when you tap a direction and it doesn't give you a miss."),
			new Judgement("Customize your Hit Timings (LEFT or RIGHT)"),
			#if desktop
			new FPSCapOption("Cap your FPS"),
			#end
			new ScrollSpeedOption("Change your scroll speed (1 = Chart dependent)"),
			new AccuracyDOption("Change how accuracy is calculated. (Accurate = Simple, Complex = Milisecond Based)"),
			new ResetButtonOption("Toggle pressing R to gameover."),
			// new OffsetMenu("Get a note offset based off of your inputs!"),
			new CustomizeGameplay("Drag'n'Drop Gameplay Modules around to your preference"),
			new BusOption("\"GAMEPLAY\"")
		]),
		new OptionCategory("Appearance", [
			new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay."),
			new CamZoomOption("Toggle the camera zoom in-game."),
			#if desktop
			new RainbowFPSOption("Make the FPS Counter Rainbow"),
			new AccuracyOption("Display accuracy information."),
			new NPSDisplayOption("Shows your current Notes Per Second."),
			new SongPositionOption("Show the songs current position (as a bar)"),
			new CpuStrums("CPU's strumline lights up when a note hits it."),
			#end
		]),

		new OptionCategory("Misc", [
			#if (windows && !NODISCORD && !DEMOBUILD)
			new DiscordRP_Option("Toggle the Discord Rich Presence functionality."),
			#end
			#if desktop
			new FPSOption("Toggle the FPS Counter"),
			new ReplayOption("View replays"),
			#end
			new FlashingLightsOption("Toggle flashing lights that can cause epileptic seizures and strain."),
			new DaemonDrop("Toggle the color light flash even during the drop in Daemon."),
			new WatermarkOption("Enable and disable all watermarks from kade engine."),
			new BotPlay("Showcase your charts and mods with autoplay."),
			new ScoreScreen("Show the score screen after the end of a song")
		]),

		new OptionCategory("!DANGER ZONE!", [
			new SaveEraseDummyOption("THE OPTION BELOW WILL ERASE ALL SAVED DATA AND SETTINGS!"),
			new SaveEraseOption("BE SURE YOU WANT TO ERASE ALL SAVE DATA BEFORE PUSHING ENTER. WE WARNED YOU!"),
			new SaveEraseDummyOption("THE OPTION ABOVE WILL ERASE ALL SAVED DATA AND SETTINGS!")
		]),

		new OptionCategory("Links", [
			new DonateItchOption("Show the offical game some love on itch.io!"),
			new NewgroundsOption("Support the kickstarter upload of FNF!"),
			new GamebananaOption("Link to our mod's page on GameBanana!")
		]),

		#if debug
		new OptionCategory("Dev", [
			new GoodEndingOption("Test the good ending state."),
			new BadEndingOption("Test the bad (and random secret) ending state."),
			new TracklistSpoilerOption("Only here to make testing easier."),
			new WeekClearFlagOption("Toggle the week clear flag for TUX week."),
			new DialogueOption("Toggle the dialogue in story mode. For debug and botplay.")
		])
		#end

	];

	public var acceptInput:Bool = true;

	private var currentDescription:String = "";
	//private var grpControls:FlxTypedGroup<Alphabet>;
	private var grpControls:FlxTypedGroup<ManiaMenuItem>;
	public static var versionShit:FlxText;

	var currentSelectedCat:OptionCategory;
	var blackBorder:FlxSprite;
	override function create()
	{

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Options Menu", null);
		#end

		instance = this;
		//var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
		var menuBG:FlxSprite = new TrollBG(0, 0).loadGraphic(Paths.image("peDesat"));

		menuBG.color = 0xFFea71fd;
		//menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1), Std.int(menuBG.height * 1.1));
		menuBG.updateHitbox();
		//menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		//grpControls = new FlxTypedGroup<Alphabet>();
		grpControls = new FlxTypedGroup<ManiaMenuItem>();
		add(grpControls);

		for (i in 0...options.length)
		{
			//var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false, true);
			var controlLabel:ManiaMenuItem = new ManiaMenuItem(0, (70 * i) + 30, options[i].getName());
			//controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		currentDescription = "none";

		versionShit = new FlxText(5, FlxG.height + 40, 0, "Offset (SHIFT + Left, SHIFT + Right): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		blackBorder = new FlxSprite(-30,FlxG.height + 40).makeGraphic((Std.int(versionShit.width + 900)),Std.int(versionShit.height + 600),FlxColor.BLACK);
		blackBorder.alpha = 0.5;

		add(blackBorder);

		add(versionShit);

		FlxTween.tween(versionShit,{y: FlxG.height - 18},2,{ease: FlxEase.elasticInOut});
		FlxTween.tween(blackBorder,{y: FlxG.height - 18},2, {ease: FlxEase.elasticInOut});

		busSound = FlxG.sound.play(Paths.sound('engine'), 0, true);

		super.create();
	}

	var isCat:Bool = false;


	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (acceptInput)
		{

			if (controls.BACK && !isCat)
			{

				busSound.volume = 0;

				if (FlxG.random.bool(1))
					FlxG.sound.play(Paths.sound('cancelMenuAlt'));
				else
					FlxG.sound.play(Paths.sound('cancelMenu'));

				FlxG.switchState(new MainMenuState());
			}
			else if (controls.BACK)
			{

				busSound.volume = 0;

				if (FlxG.random.bool(1))
					FlxG.sound.play(Paths.sound('cancelMenuAlt'));
				else
					FlxG.sound.play(Paths.sound('cancelMenu'));

				isCat = false;
				grpControls.clear();
				for (i in 0...options.length)
				{
					//var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false);
					var controlLabel:ManiaMenuItem = new ManiaMenuItem(0, (70 * i) + 30, options[i].getName());
					//controlLabel.isMenuItem = true;
					controlLabel.targetY = i;
					grpControls.add(controlLabel);
					// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
				}

				curSelected = 0;

				changeSelection(curSelected);
			}
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);

			if (isCat)
			{
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
				{
					if (FlxG.keys.pressed.SHIFT)
						{
							if (FlxG.keys.pressed.RIGHT)
								currentSelectedCat.getOptions()[curSelected].right();
							if (FlxG.keys.pressed.LEFT)
								currentSelectedCat.getOptions()[curSelected].left();
						}
					else
					{
						if (FlxG.keys.justPressed.RIGHT)
							currentSelectedCat.getOptions()[curSelected].right();
						if (FlxG.keys.justPressed.LEFT)
							currentSelectedCat.getOptions()[curSelected].left();
					}
				}
				else
				{

					if (currentSelectedCat.getOptions()[curSelected].getDisplay() == "CRAZYBUS")
						busSound.volume = 1;
					else
						busSound.volume = 0;

					if (FlxG.keys.pressed.SHIFT)
					{
						if (FlxG.keys.justPressed.RIGHT)
							FlxG.save.data.offset += 0.1;
						else if (FlxG.keys.justPressed.LEFT)
							FlxG.save.data.offset -= 0.1;
					}
					else if (currentSelectedCat.getOptions()[curSelected].getDisplay() == "CRAZYBUS")
					{
						if (FlxG.keys.pressed.RIGHT)
						{
							ManiaMenuItem.busX += 1;
							busScore += 1;
						}
						if (FlxG.keys.pressed.LEFT)
						{
							ManiaMenuItem.busX -= 1;
							busScore -= 1;
						}
						if (ManiaMenuItem.busX > 200)
							ManiaMenuItem.busX = 0;
						if (ManiaMenuItem.busX < 0)
							ManiaMenuItem.busX = 200;
						if (busScore > 65535)
							busScore = 0;
						if (busScore < 0)
							busScore = 65535;
					}

					if (currentSelectedCat.getOptions()[curSelected].getDisplay() != "CRAZYBUS")
						versionShit.text = "Offset (SHIFT + Left, SHIFT + Right): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
					else
						versionShit.text = "||CRAZYBUS||  SCORE: " + busScore;
				}
				if (currentSelectedCat.getOptions()[curSelected].getDisplay() == "CRAZYBUS")
					versionShit.text = "||CRAZYBUS||  SCORE: " + busScore;
				else if (currentSelectedCat.getOptions()[curSelected].getAccept())
					versionShit.text =  currentSelectedCat.getOptions()[curSelected].getValue() + " - Description - " + currentDescription;
				else
					versionShit.text = "Offset (SHIFT + Left, SHIFT + Right): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
			}
			else
			{
				if (FlxG.keys.pressed.SHIFT)
				{
					if (FlxG.keys.justPressed.RIGHT)
						FlxG.save.data.offset += 0.1;
					else if (FlxG.keys.justPressed.LEFT)
						FlxG.save.data.offset -= 0.1;
			}

				versionShit.text = "Offset (SHIFT + Left, SHIFT + Right): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
			}


			if (controls.RESET)
					FlxG.save.data.offset = 0;

			if (controls.ACCEPT)
			{
				if (isCat)
				{
					if (currentSelectedCat.getOptions()[curSelected].press()) {
						grpControls.remove(grpControls.members[curSelected]);
						//var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, currentSelectedCat.getOptions()[curSelected].getDisplay(), true, false);
						var ctrl:ManiaMenuItem = new ManiaMenuItem(0, (70 * curSelected) + 30, currentSelectedCat.getOptions()[curSelected].getDisplay(), false, (currentSelectedCat.getOptions()[curSelected].getDisplay() == "CRAZYBUS"));
						//ctrl.isMenuItem = true;
						grpControls.add(ctrl);
					}
				}
				else
				{
					currentSelectedCat = options[curSelected];
					isCat = true;
					grpControls.clear();
					for (i in 0...currentSelectedCat.getOptions().length)
					{
						//var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getDisplay(), true, false);
						var controlLabel:ManiaMenuItem = new ManiaMenuItem(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getDisplay(), false, (currentSelectedCat.getOptions()[i].getDisplay() == "CRAZYBUS"));
						//controlLabel.isMenuItem = true;
						controlLabel.targetY = i;
						grpControls.add(controlLabel);
						// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
					}
					curSelected = 0;

					changeSelection(curSelected);
				}
			}
		}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end

		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		if (isCat)
			currentDescription = currentSelectedCat.getOptions()[curSelected].getDescription();
		else
			currentDescription = "Please select a category";
		if (isCat)
		{
			if (currentSelectedCat.getOptions()[curSelected].getAccept())
				versionShit.text =  currentSelectedCat.getOptions()[curSelected].getValue() + " - Description - " + currentDescription;
			else
				versionShit.text = "Offset (SHIFT + Left, SHIFT + Right): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
		}
		else
			versionShit.text = "Offset (SHIFT + Left, SHIFT + Right): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
