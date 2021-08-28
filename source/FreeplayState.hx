package;

#if !web
import webm.WebmPlayer;
#end

import Song.SwagSong;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

#if windows
import Discord.DiscordClient;
#end

import openfl.display.Sprite;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	//var ModGlobals.currentDifficulty:Int = 1;

	var scoreText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	private var grpSongs:FlxTypedGroup<ManiaMenuItem>;
	private var curPlaying:Bool = false;

	var initSonglist:Array<String> = ['yom']; // set this earlier so it can later be set by the below

	var curSongData:SwagSong;

	//private var iconArray:Array<HealthIcon> = [];

	// WEBM
	var webmUpdates = false;

	#if web
	public static var vHandler:VideoHandler;

	var openflVidDisplay:Sprite = new Sprite();
	var thanksKade:OFLSprite;
	#else
	public static var webmHandler:WebmHandler;
	#end

	public var videoSprite:FlxSprite;

	var webmFrame:FlxSprite;
	var portraitSprite:FlxSprite;

	var difficultyLock:Int = -1;

	var curWebm:String = 'freeplay/fptest';

	override function create()
	{
		switch (MainMenuState.curSubmenu) // switch freeplay data to load based on current submenu
		{
			case 0:
				initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

			case 1:
				initSonglist = CoolUtil.coolTextFile(Paths.txt('freestyleFreeplaySonglist'));

			case 2:
				initSonglist = CoolUtil.coolTextFile(Paths.txt('duetplaySonglist'));

				#if debug
				var forceEnable:Bool = true;
				#else
				var forceEnable:Bool = false;
				#end

				if (FlxG.save.data.weekClearDifficultyTUX == 2)
					initSonglist.push('True Trolling (Duet):trolling:1');

				difficultyLock = 2;
				//ModGlobals.currentDifficulty = difficultyLock;
		}

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1]));
		}

		/*
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('recycler'));
			}
		 */

		 #if windows
		 // Updating Discord Rich Presence
		 switch (MainMenuState.curSubmenu)
		 {
		 	case 0:
				DiscordClient.changePresence("In the Freeplay Menu", null);

			case 1:
				DiscordClient.changePresence("In the Freestyle Freeplay Menu", null);

			case 2:
				DiscordClient.changePresence("In the Duetplay Menu", null);
		 }
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		//persistentUpdate = true;

		// LOAD MUSIC

		// LOAD CHARACTERS

		//var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		var bg:TrollBG = new TrollBG(0, 0);
		bg.loadGraphic(Paths.image('peBlue'));bg.setGraphicSize(Std.int(bg.width * 1.1), Std.int(bg.height * 1.1));
		bg.updateHitbox();
		bg.antialiasing = true;
		add(bg);

		grpSongs = new FlxTypedGroup<ManiaMenuItem>();
		add(grpSongs);

		var videoBG = new FlxSprite(887,255 + 110);
		videoBG.makeGraphic(Std.int(720 * 0.55), Std.int(405 * 0.55), FlxColor.BLACK);
		add(videoBG);

		videoSprite = new FlxSprite(687,155 + 110);
		add(videoSprite);

		#if web
		// thanks to kade, we can draw sprites overtop the video in html5 by putting the video as a child of a openfl Sprite and using OFLSprite to draw that as a FlxSprite (With modifications to the update cycle)
		thanksKade = new OFLSprite(0, 0, FlxG.width, FlxG.height, openflVidDisplay, true);
		add(thanksKade);
		#end

		webmFrame = new FlxSprite(0, 0).loadGraphic(Paths.image('tuxMenu/FREEPLAYDISPLAY'));
		webmFrame.antialiasing = true;
		webmFrame.updateHitbox();
		webmFrame.screenCenter(Y);
		webmFrame.x = FlxG.width - webmFrame.width + 300;
		webmFrame.y += 110;
		//webmFrame.flipY = true;

		add(webmFrame);

		for (i in 0...songs.length)
		{
			//var songText:ManiaMenuItem = new ManiaMenuItem(0, (70 * i) + 30, songs[i].songName, true);

			// I not only fixed that weird thing when you open the freeplay menu
			// I abused it to make a cool tween on the freeplay menu with no effort
			// awesome!
			var songText:ManiaMenuItem = new ManiaMenuItem(-FlxG.width, (FlxMath.remapToRange(i, 0, 1, 0, 1.3) * 146) + (FlxG.height * 0.54), songs[i].songName, true);
			songText.isMovingMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			//var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			//icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			// ...tell me about it.
			//iconArray.push(icon);
			//add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ManiaMenuItem() !!
			// songText.screenCenter(X);
		}

		//scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		//scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		//scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("terminus.ttf"), 32, FlxColor.WHITE, RIGHT);
		scoreText.y = FlxG.height - (scoreText.height * 2) - 15;
		// scoreText.alignment = RIGHT;
		scoreText.antialiasing = false;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, scoreText.y).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		diffText.antialiasing = false;
		add(diffText);

		comboText = new FlxText(diffText.x + 100, diffText.y, 0, "", 24);
		comboText.font = diffText.font;
		comboText.antialiasing = false;
		add(comboText);

		add(scoreText);

		portraitSprite = new FlxSprite(100, 100).loadGraphic(Paths.image('portraits/P_Beastie', 'preload'));
		portraitSprite.x = webmFrame.getMidpoint().x - webmFrame.x + Std.int(portraitSprite.width * 0.9);
		portraitSprite.y = webmFrame.y - portraitSprite.height;
		portraitSprite.antialiasing = true;
		add(portraitSprite);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:ManiaMenuItem = new ManiaMenuItem(1, 0, "swag", true);

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/*
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);


		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		comboText.text = combo + '\n';

		if (FlxG.sound.music.volume > 0.8)
		{
			FlxG.sound.music.volume -= 0.5 * FlxG.elapsed;
		}

		if (webmUpdates && (GlobalVideo.get().ended || GlobalVideo.get().stopped))
		{
			webmUpdates = false;
			//GlobalVideo.get().hide();
			//GlobalVideo.get().stop();
			previewVideo(Paths.webm(curWebm));
			//trace('RESTART PREVIEW VIDEO');
		}

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
		{
			if (difficultyLock != -1)
				FlxG.sound.play(Paths.sound('scrollDeny'));
			else
				changeDiff(-1);
		}

		if (controls.RIGHT_P)
		{
			if (difficultyLock != -1)
				FlxG.sound.play(Paths.sound('scrollDeny'));
			else
				changeDiff(1);
		}

		if (controls.BACK)
		{

			webmUpdates = false;
			GlobalVideo.get().hide();
			GlobalVideo.get().stop();

			if (FlxG.random.bool(1))
				FlxG.sound.play(Paths.sound('cancelMenuAlt'));
			else
				FlxG.sound.play(Paths.sound('cancelMenu'));

			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{

			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(songs[curSelected].songName, " ", "-");
			switch (songFormat) {
				case 'Dad-Battle': songFormat = 'Dadbattle';
				case 'Philly-Nice': songFormat = 'Philly';
			}

			var chosenDiff:Int = 0;

			if (difficultyLock != -1)
				chosenDiff = difficultyLock;
			else
				chosenDiff = ModGlobals.currentDifficulty;

			trace(songs[curSelected].songName);

			var poop:String = Highscore.formatSong(songFormat, chosenDiff);

			trace(poop);

			webmUpdates = false;
			GlobalVideo.get().hide();
			GlobalVideo.get().stop();

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = chosenDiff;
			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}

	}

	function changeDiff(change:Int = 0)
	{
		ModGlobals.currentDifficulty += change;

		if (ModGlobals.currentDifficulty < 0)
			ModGlobals.currentDifficulty = 2;
		if (ModGlobals.currentDifficulty > 2)
			ModGlobals.currentDifficulty = 0;

		// adjusting the highscore song name to be compatible (changeDiff)
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}

		/*if (difficultyLock != -1)
		{
			ModGlobals.currentDifficulty = difficultyLock;
		}*/

		#if !switch
		intendedScore = Highscore.getScore(songHighscore, ModGlobals.currentDifficulty);
		combo = Highscore.getCombo(songHighscore, ModGlobals.currentDifficulty);
		#end

		if (difficultyLock != -1)
			switch (difficultyLock)
			{
				case 0:
					diffText.text = "EASY";
				case 1:
					diffText.text = 'NORMAL';
				case 2:
					diffText.text = "HARD";
			}
		else
			switch (ModGlobals.currentDifficulty)
			{
				case 0:
					diffText.text = "EASY";
				case 1:
					diffText.text = 'NORMAL';
				case 2:
					diffText.text = "HARD";
			}

	}

	function changeSelection(change:Int = 0)
	{

		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		// adjusting the highscore song name to be compatible (changeSelection)
		// would read original scores if we didn't change packages
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}

		switch (songs[curSelected].songName)
		{

			case "Trolling" | "True Trolling":
				difficultyLock = 2;
				changeDiff();

			default:
				if (MainMenuState.curSubmenu != 2)
					difficultyLock = -1;
				else
				{
					difficultyLock = 2;
					changeDiff();
				}

		}

		#if !switch
		intendedScore = Highscore.getScore(songHighscore, ModGlobals.currentDifficulty);
		combo = Highscore.getCombo(songHighscore, ModGlobals.currentDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var songFormat = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songFormat) {
			case 'Dad-Battle': songFormat = 'Dadbattle';
			case 'Philly-Nice': songFormat = 'Philly';
		}

		/*
		#if !web
		curSongData = Song.loadFromJson(Highscore.formatSong(songFormat, ModGlobals.currentDifficulty), songs[curSelected].songName);
		Conductor.changeBPM(curSongData.bpm);
		#end
		*/

		switch (songs[curSelected].songName)
		{

			case "Hornz" | "Hornz (Duet)":
				curWebm = 'freeplay/HORNZ_BOP';

			case "Daemon" | "Daemon (Duet)":
				curWebm = 'freeplay/DAEMON_BOP';

			case "Troublemakers" | "Troublemakers (Duet)":
				curWebm = 'freeplay/TROUBLEMAKERS_BOP';

			case "F.L.O.S.S" | "F.L.O.S.S (Duet)":
				curWebm = 'freeplay/FLOSS_BOP';

			case "Trolling":
				curWebm = 'freeplay/TROLLING_BOP';

			case "Tutorial Remix":
				curWebm = 'freeplay/TUTORIAL_REMIX_BOP';

			case "Ugh":
				curWebm = 'freeplay/UGH_BOP';

			case "S.T.Y.L.E":
				curWebm = 'freeplay/STYLE_BOP';

			case "Fangz":
				curWebm = 'freeplay/FANGZ_BOP';

			case "Exorcism":
				curWebm = 'freeplay/EXORCISM_BOP';

			case "Flame War":
				curWebm = 'freeplay/FLAME_WAR_BOP';

			case "True Trolling" | "True Trolling (Duet)":
				curWebm = 'freeplay/TT_BOP';

			default:
				curWebm = 'freeplay/fptest';

		}

		GlobalVideo.get().hide();
		GlobalVideo.get().stop();
		previewVideo(Paths.webm(curWebm));

		var bullShit:Int = 0;

		//for (i in 0...iconArray.length)
		//{
			//iconArray[i].alpha = 0.6;
		//}

		//iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
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

		if (difficultyLock != -1)
			switch (difficultyLock)
			{
				case 0:
					diffText.text = "EASY";
				case 1:
					diffText.text = 'NORMAL';
				case 2:
					diffText.text = "HARD";
			}
		else
			switch (ModGlobals.currentDifficulty)
			{
				case 0:
					diffText.text = "EASY";
				case 1:
					diffText.text = 'NORMAL';
				case 2:
					diffText.text = "HARD";
			}

		var portraitName:String = 'P_Beastie';

		switch (songs[curSelected].songCharacter)
		{

			case 'gf-hell' | 'gf-gone' | 'gf' | 'gf-pixel' | 'freestyle-hell':
				portraitName = 'P_CosplayGF';

			case 'beastie' | 'beastie_beta':
				portraitName = 'P_Beastie';

			case 'freestyle_beastie':
				portraitName = 'P_Freestyle_Beastie';

			case 'beastie_old' | 'trolling_old':
				portraitName = 'P_Beastie_old';

			case 'trolling':
				portraitName = 'P_Beastie4';

			case 'bsuit':
				portraitName = 'P_Bsuit';

			case 'bsuit_old':
				portraitName = 'P_Bsuit_old';

			case 'freestyle_troublemakers':
				portraitName = 'P_Freestyle_Troublemakers';

			case 'troublemakers':
				portraitName = 'P_Troublemakers';

			default:
				/*if (FlxG.random.bool(50))
					portraitName = 'P_Beastie5';
				else if (FlxG.random.bool(50))
					portraitName = 'P_Beastie3';
				else if (FlxG.random.bool(50))
					portraitName = 'P_Missing';
				else
					portraitName = 'P_BF2';*/
				portraitName = 'P_Missing';
		}

		switch (portraitName)
		{
			case 'P_Troublemakers' | 'P_Freestyle_Troublemakers':
				portraitSprite.flipX = true;
			case 'P_BF2':
				portraitSprite.flipX = true;
			default:
				portraitSprite.flipX = false;
		}

		portraitSprite.loadGraphic(Paths.image('portraits/' + portraitName, 'preload'));
		portraitSprite.updateHitbox();
		portraitSprite.x = webmFrame.getMidpoint().x - webmFrame.x + Std.int(portraitSprite.width * 0.9);
		portraitSprite.y = webmFrame.y - portraitSprite.height;
		portraitSprite.antialiasing = true;
		add(portraitSprite);

	}

public function previewVideo(source:String) // for neat freeplay preview panes. Stolen from the stupid-ass lua modchart code in PlayState.hx. This is the only usefulness I have found out of lua modcharts so far. I added the html5 part.
	{

		var ourSource:String = "assets/videos/DO NOT DELETE OR GAME WILL CRASH/dontDelete.webm";

		#if web

		if (vHandler != null)
			openflVidDisplay.removeChild(vHandler.video);

		vHandler = new VideoHandler();
		vHandler.noSetSize = true;

		var str1:String = "HTML CRAP";
		vHandler.init1();
		vHandler.video.name = str1;
		//Lib.current.addChild(vHandler.video);

		openflVidDisplay.addChild(vHandler.video);

		vHandler.init2();
		GlobalVideo.setVid(vHandler);
		vHandler.source(ourSource);


		// needs to be hard-coded for html5 :(
		videoSprite.makeGraphic(Std.int(720 * 0.55), Std.int(405 * 0.55), FlxColor.TRANSPARENT);

		vHandler.video.x = 849;
		vHandler.video.y = 255 + 110;

		vHandler.video.width = videoSprite.width;
		vHandler.video.height = videoSprite.height;

		#else

		webm.WebmPlayer.SKIP_STEP_LIMIT = 90;
		var str1:String = "WEBM SHIT";
		webmHandler = new WebmHandler();
		webmHandler.source(ourSource);
		webmHandler.makePlayer();
		webmHandler.webm.name = str1;

		GlobalVideo.setWebm(webmHandler);

		#end

		GlobalVideo.get().source(source);
		GlobalVideo.get().clearPause();
		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().updatePlayer();
		}
		GlobalVideo.get().show();

		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().restart();
		} else {
			GlobalVideo.get().play();
		}

		#if !web
		var data = webmHandler.webm.bitmapData;

		videoSprite.loadGraphic(data);

		//videoSprite.setGraphicSize(Std.int(videoSprite.width * 1.2));
		//videoSprite.setGraphicSize(Std.int(videoSprite.width * 0.4));
		videoSprite.setGraphicSize(Std.int(1280 * 0.3));
		videoSprite.updateHitbox();
		videoSprite.x = 687 + 167;
		videoSprite.y = 155 + 110 + 100;

		//add(videoSprite);

		#end

		webmUpdates = true;

		trace('poggers');
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
