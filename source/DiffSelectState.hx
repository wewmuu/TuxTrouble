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

using StringTools;

class DiffSelectState extends MusicBeatState
{

	var tutorialSkip = true;

	#if !DEMOBUILD
	public static var isDemoBuild = false;
	#else
	public static var isDemoBuild = true;
	#end

	var bg:FlxSprite;
	var bgFlash:FlxSprite;
	var allowPlayerControl:Bool = false;

	var menuHeader:FlxText;

	var beastie:FlxSprite;

	var arrowl:FlxSprite;
	var arrowr:FlxSprite;
	var arrowScale:Float = 0.7;
	var diffText:FlxSprite;

	var scoreText:FlxText;

	var arrowlINV:FlxSprite;
	var arrowrINV:FlxSprite;
	var diffTextINV:FlxSprite;

	var tutRemSprite:FlxSprite;

	var beastieDestX:Float;
	var diffTextDestX:Float;

	var arrowTween:FlxTween;
	var arrowTweenIsFinished:Bool = false;

	var difficultyLock:Int = -1;

	override function create()
	{

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Selecting a difficulty", null);
		#end

		if (MainMenuState.curSubmenu == 2)
		{

			switch(MainMenuState.diffSelectMod)
			{
				case 2:
					difficultyLock = 2; // TRUE TROLLING
				default:
					difficultyLock = 2; // SMOOTH
			}

		}

		if (difficultyLock != -1)
		{
			ModGlobals.currentDifficulty = difficultyLock;
		}

		//if (!FlxG.sound.music.playing)
		//{
			//FlxG.sound.playMusic(Paths.music('recycler'));
		//}

		//persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('tuxMenu/diffSel/diff'));
		//bg.setGraphicSize(FlxG.width);
		//bg.updateHitbox();
		//bg.antialiasing = true;
		add(bg);

		//camFollow = new FlxObject(0, 0, 1, 1);
		//add(camFollow);

		bgFlash = new FlxSprite(0, 0).loadGraphic(Paths.image('tuxMenu/diffSel/diffFlash'));
		//bgFlash.setGraphicSize(FlxG.width);
		//bgFlash.updateHitbox();
		bgFlash.visible = false;
		//bgFlash.antialiasing = true;
		//bgFlash.color = 0xFFfd719b;
		//bgFlash.color = 0xFFff5aab;
		//bgFlash.color = flashColor;
		add(bgFlash);
		// bgFlash.scrollFactor.set();

		// since we now have multiple menu item songs in the extras menu
		// I figured I needed to add indication of what song is selected
		// I think this is the best way to do it without much effort
		// "choose your difficulty" is kinda innacurate for the extras menu
		// anyways since these options don't give you a choice.
		// they're only charter dor hard.
		var headerText:String = 'CHOOSE YOUR DIFFICULTY';

		switch (MainMenuState.curSubmenu)
		{

			case 2:
				switch (MainMenuState.diffSelectMod)
				{
					case 2:
						headerText = 'TRUE TROLLING';
					default:
						headerText = 'SMOOTH';
				}

			default:
				headerText = 'CHOOSE YOUR DIFFICULTY';

		}

		menuHeader = new FlxText(0, 10, 0, headerText, 12);
		//menuHeader.setFormat("friday night", 118, FlxColor.WHITE, CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
		menuHeader.setFormat("friday night", 96, FlxColor.WHITE, CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
		menuHeader.borderSize = 3;
		menuHeader.antialiasing = true;
		menuHeader.updateHitbox();
		menuHeader.screenCenter(X);
		add(menuHeader);

		beastie = new FlxSprite(0, 0);

		beastie.loadGraphic(Paths.image('tuxMenu/diffSel/beastie/' + ModGlobals.currentDifficulty));

		beastie.antialiasing = true;
		beastie.screenCenter();
		beastie.y -= Std.int(beastie.height / 4.5);
		beastieDestX = beastie.x;
		beastie.x = -FlxG.width;
		add(beastie);


		scoreText = new FlxText(100, 100, 0, '0000', 12);
		//scoreText.setFormat(Paths.font("terminus chunky.ttf"), 118, FlxColor.WHITE, CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
		scoreText.setFormat(Paths.font("terminus chunky.ttf"), 84, FlxColor.WHITE, CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
		scoreText.borderSize = 3;
		scoreText.antialiasing = true;
		scoreText.updateHitbox();
		scoreText.visible = false;
		scoreText.screenCenter(X);
		add(scoreText);


		// WARNING: I forgot to update the hitbox after scaling all of the following shit.
		// Please don't add an updateHitbox(), it could fuck shit up.

		arrowr = new FlxSprite(0, 0);
		arrowr.loadGraphic(Paths.image('tuxMenu/diffSel/arrowr'));
		arrowr.scale.x = arrowScale;
		arrowr.scale.y = arrowr.scale.x;
		arrowr.updateHitbox();
		arrowr.antialiasing = true;
		arrowr.screenCenter();
		arrowr.x += 280;

		arrowl = new FlxSprite(0, 0);
		arrowl.loadGraphic(Paths.image('tuxMenu/diffSel/arrowl'));
		arrowl.scale.x = arrowScale;
		arrowl.scale.y = arrowl.scale.x;
		arrowl.updateHitbox();
		arrowl.antialiasing = true;
		arrowl.screenCenter();
		arrowl.x -= 280;

		arrowr.visible = arrowl.visible = false;

		add(arrowr);
		add(arrowl);

		arrowrINV = new FlxSprite(0, 0);
		arrowrINV.loadGraphic(Paths.image('tuxMenu/diffSel/arrowrINV'));
		arrowrINV.scale.x = arrowScale;
		arrowrINV.scale.y = arrowrINV.scale.x;
		arrowrINV.updateHitbox();
		arrowrINV.antialiasing = true;
		arrowrINV.screenCenter();
		arrowrINV.x += 280;

		arrowlINV = new FlxSprite(0, 0);
		arrowlINV.loadGraphic(Paths.image('tuxMenu/diffSel/arrowlINV'));
		arrowlINV.scale.x = arrowScale;
		arrowlINV.scale.y = arrowlINV.scale.x;
		arrowlINV.updateHitbox();
		arrowlINV.antialiasing = true;
		arrowlINV.screenCenter();
		arrowlINV.x -= 280;

		arrowrINV.visible = arrowlINV.visible= false;

		add(arrowrINV);
		add(arrowlINV);

		diffText = new FlxSprite(0, 0);
		diffText.loadGraphic(Paths.image('tuxMenu/diffSel/text/' + ModGlobals.currentDifficulty));
		diffText.scale.x = 0.55;
		diffText.scale.y = diffText.scale.x;
		diffText.updateHitbox();
		diffText.antialiasing = true;
		diffText.screenCenter();
		diffText.y += 240;
		diffTextDestX = diffText.x;
		diffText.x += FlxG.width;
		add(diffText);

		diffTextINV = new FlxSprite(0, 0);
		diffTextINV.loadGraphic(Paths.image('tuxMenu/diffSel/textINV/' + ModGlobals.currentDifficulty));
		diffTextINV.scale.x = 0.55;
		diffTextINV.scale.y = diffText.scale.x;
		diffTextINV.updateHitbox();
		diffTextINV.antialiasing = true;
		diffTextINV.screenCenter();
		diffTextINV.y += 240;

		diffTextINV.visible = false;

		add(diffTextINV);


		// Definately DO NOT try to update the hitbox on this sprite.
		tutRemSprite = new FlxSprite(0, 0);
		tutRemSprite.loadGraphic(Paths.image('tuxMenu/diffSel/tutorialDia/skip'));
		tutRemSprite.antialiasing = true;
		tutRemSprite.screenCenter();
		tutRemSprite.scale.x = 0.001;
		tutRemSprite.scale.y = diffText.scale.x;
		tutRemSprite.visible = false;
		add(tutRemSprite);

		var initTweenSpeed:Float = 0.5;

		FlxTween.tween(beastie, { x:beastieDestX }, initTweenSpeed, {
			onStart: function(twn:FlxTween)
			{
				FlxTween.tween(diffText, { x:diffTextDestX }, initTweenSpeed);
			},
			onComplete: function(twn:FlxTween)
			{
				if (difficultyLock == -1)
					arrowr.visible = arrowl.visible = true;
				allowPlayerControl = true;

				switch (MainMenuState.curSubmenu)
				{
					case 0:
						updateHighscoreWeek(1);

					case 1:
						updateHighscoreWeek(3);

					case 2:
						//updateHighscoreSong("Tutorial Remix");
						switch(MainMenuState.diffSelectMod)
						{
							case 2:
								updateHighscoreSong("True Trolling");
							default:
								updateHighscoreSong("Smooth");
						}
				}

			}
		});

		super.create();
	}

	var selectedSomethin:Bool = false;
	var selectedTutorialRemix:Bool = false;

	override function update(elapsed:Float)
	{

		//if (FlxG.sound.music.volume < 0.8)
		//{
			//FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		//}


		if (!selectedSomethin && allowPlayerControl)
		{
			if (controls.LEFT_P && difficultyLock == -1)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}
			else if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollDeny'));
			}

			if (controls.RIGHT_P && difficultyLock == -1)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}
			else if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollDeny'));
			}

			if (controls.BACK)
			{

				if (FlxG.random.bool(1))
					FlxG.sound.play(Paths.sound('cancelMenuAlt'));
				else
					FlxG.sound.play(Paths.sound('cancelMenu'));

				cancelArrowTween();

				arrowTweenIsFinished = false;

				FlxG.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
			{

				cancelArrowTween();

				arrowTweenIsFinished = false;

				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				if (FlxG.save.data.flashing)
				{

					FlxFlicker.flicker(bgFlash,  1.1, 0.15, false, true, function(flick:FlxFlicker)
					{

						switch (MainMenuState.curSubmenu)
						{

							case 0:
								tutorialRemixPrompt(true);

							default:
								 goToState();

						}

					});

					if (difficultyLock == -1)
					{
						FlxFlicker.flicker(arrowlINV,  1.1, 0.15, false, true);
						FlxFlicker.flicker(arrowrINV,  1.1, 0.15, false, true);
					}

					FlxFlicker.flicker(diffTextINV,  1.1, 0.15, false, true);

				}

				else
				{

					new FlxTimer().start(1.1, function(tmr:FlxTimer)
					{

						switch (MainMenuState.curSubmenu)
						{

							case 0:
								tutorialRemixPrompt(true);

							default:
								 goToState();

						}

					});

				}

			}

		}

		else if (!selectedTutorialRemix && tutRemSprite.visible && allowPlayerControl)
		{

			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeTut();
			}

			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeTut();
			}

			if (controls.BACK)
			{

				if (FlxG.random.bool(1))
					FlxG.sound.play(Paths.sound('cancelMenuAlt'));
				else
					FlxG.sound.play(Paths.sound('cancelMenu'));

				tutorialRemixPrompt(false);

				if (selectedSomethin)
					selectedSomethin = !selectedSomethin;

				selectedTutorialRemix = false;
			}

			if (controls.ACCEPT)
			{
				// snohq asked for me not to play this antimation when selecting
				// tutorialRemixPrompt(false);

				selectedTutorialRemix = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				new FlxTimer().start(1.1, function(tmr:FlxTimer)
				{
					goToState(!tutorialSkip);
				});

			}

		}

		super.update(elapsed);

	}

	function goToState(?addTutRemix = false) // load into a differently prepared instance of PlayState based on the current submenu
	{

		switch (MainMenuState.curSubmenu)
		{
			case 0:
				// SHOW THE TUTORIAL REMIX PROMPT FIRST
				var playlist = ['Hornz', 'Daemon', 'Trolling', 'Troublemakers', 'F.L.O.S.S'];
				//var playlist = ['F.L.O.S.S'];

				if (addTutRemix)
					playlist.insert(0, 'Tutorial Remix');

				loadStoryWeek(playlist, 1, ModGlobals.currentDifficulty);

			case 1:
				// load freestyle story week without prompting for tutorial remix
				var playlist = ['S.T.Y.L.E', 'Fangz', 'Exorcism', 'Flame War'];
				loadStoryWeek(playlist, 3, ModGlobals.currentDifficulty);

			case 2: // if we are in the extras menu it means we've selected the beta song or true trolling.
				// check the difficulty select modifier on the main menu to determine what song was chosen
				// Again, go straight to the song, don't ask about tutorial remix
				switch(MainMenuState.diffSelectMod)
				{
					case 2:
						loadFreeplaySong('True Trolling', 1, ModGlobals.currentDifficulty);
					default:
						loadFreeplaySong('Smooth', 2, ModGlobals.currentDifficulty);
				}
		}

	}


	function changeTut()
	{

		var prevSelected = tutorialSkip;
		tutorialSkip = !tutorialSkip;

		if (tutorialSkip)
			tutRemSprite.loadGraphic(Paths.image('tuxMenu/diffSel/tutorialDia/skip'));
		else
			tutRemSprite.loadGraphic(Paths.image('tuxMenu/diffSel/tutorialDia/dontSkip'));

	}

	function cancelArrowTween()
	{

		if (arrowTween != null && !arrowTweenIsFinished)
		{
			arrowTween.cancel();
			arrowl.scale.set(arrowScale, arrowScale);
			arrowr.scale.set(arrowScale, arrowScale);
		}

	}

	function changeItem(huh:Int = 0)
	{

		var prevSelected = ModGlobals.currentDifficulty;
		ModGlobals.currentDifficulty += huh;

		if (ModGlobals.currentDifficulty > 2)
			ModGlobals.currentDifficulty = 0;
		if (ModGlobals.currentDifficulty < 0)
			ModGlobals.currentDifficulty = 2;

		cancelArrowTween();

		arrowTweenIsFinished = false;

		switch (huh)
		{

			case -1: // left
				arrowTween = FlxTween.tween(arrowl,{'scale.x': 1, 'scale.y': 1}, 0.10, {onComplete: function(flxTween:FlxTween)
				{

					FlxTween.tween(arrowl,{'scale.x': arrowScale, 'scale.y': arrowScale}, 0.05);
					//arrowl.scale.set(arrowScale, arrowScale);
					arrowTweenIsFinished = true;

				}});

			case 1: // right
				arrowTween = FlxTween.tween(arrowr,{'scale.x': 1, 'scale.y': 1}, 0.10, {onComplete: function(flxTween:FlxTween)
				{

					FlxTween.tween(arrowr,{'scale.x': arrowScale, 'scale.y': arrowScale}, 0.05);
					//arrowr.scale.set(arrowScale, arrowScale);
					arrowTweenIsFinished = true;

				}});

		}

		diffText.loadGraphic(Paths.image('tuxMenu/diffSel/text/' + ModGlobals.currentDifficulty));
		diffText.updateHitbox();
		diffText.screenCenter();
		diffText.y += 240;

		diffTextINV.loadGraphic(Paths.image('tuxMenu/diffSel/textINV/' + ModGlobals.currentDifficulty));
		diffTextINV.updateHitbox();
		diffTextINV.screenCenter();
		diffTextINV.y += 240;

		beastie.loadGraphic(Paths.image('tuxMenu/diffSel/beastie/' + ModGlobals.currentDifficulty));

		switch (MainMenuState.curSubmenu)
		{
			case 0:
				updateHighscoreWeek(1);

			case 1:
				updateHighscoreWeek(3);

			case 2:
				switch(MainMenuState.diffSelectMod)
				{
					case 2:
						updateHighscoreSong("True Trolling");
					default:
						updateHighscoreSong("Smooth");
				}
		}

	}

	public function loadStoryWeek(tracklist:Array<String>, weekNum:Int, ?diff:Int = 1)
	{

		PlayState.storyPlaylist = tracklist;
		PlayState.isStoryMode = true;


		PlayState.storyDifficulty = diff;

		// adjusting the song name to be compatible
		var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
		switch (songFormat) {
			case 'Dad-Battle': songFormat = 'Dadbattle';
			case 'Philly-Nice': songFormat = 'Philly';
		}

		var poop:String = Highscore.formatSong(songFormat, diff);
		PlayState.sicks = 0;
		PlayState.bads = 0;
		PlayState.shits = 0;
		PlayState.goods = 0;
		PlayState.campaignMisses = 0;
		PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
		PlayState.storyWeek = weekNum;
		PlayState.campaignScore = 0;

		// Video cutscene shit changed
		//FlxG.switchState(new VideoState('assets/videos/hornz.webm', new PlayState()));
		//LoadingState.loadAndSwitchState(new PlayState(), true);

		// I'm using a hacky fix for now for tacking what songs open with cutscenes

		var cutsceneName:String = '';

		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'daemon':
				cutsceneName = 'HornzDaemonTransition';
			case 'trolling':
				cutsceneName = 'Trolling_Pre_Cutscene';
			case 'troublemakers':
				cutsceneName = 'TrollingTroublemakersTransition';
			default:
				cutsceneName = '';
		}

		if (cutsceneName != '') {
			LoadingState.loadAndSwitchState(new VideoState(Paths.webm(cutsceneName), new PlayState()), true);
			trace('The video cutscene exists! Move to VideoState');
		}else{
			LoadingState.loadAndSwitchState(new PlayState(), true);
			trace('No video cutscene, move to PlayState');
		}

	}

	public function loadFreeplaySong(songName:String, week:Int, ?diff:Int = 1) // p sure 1 corresponds to normal difficulty. A lot of this is copied and adapted from the freeplay menu. Song name should probably include spaces and caps.
	{

		// adjusting the song name to be compatible
		var songFormat = StringTools.replace(songName, " ", "-");
		switch (songFormat) {
			case 'Dad-Battle': songFormat = 'Dadbattle';
			case 'Philly-Nice': songFormat = 'Philly';
		}

		var poop:String = Highscore.formatSong(songFormat, diff);

		trace(poop);

		PlayState.SONG = Song.loadFromJson(poop, songName); // song name is parsed by function. No worries!
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = diff;
		PlayState.storyWeek = week;

		trace('CUR WEEK' + PlayState.storyWeek);
		LoadingState.loadAndSwitchState(new PlayState());

	}

	public function tutorialRemixPrompt(show:Bool)
	{

		if(show)
		{

			allowPlayerControl = false;

			tutRemSprite.visible = true;

			FlxTween.tween(tutRemSprite,{'scale.x': 1.5, 'scale.y': 1.5}, 0.15, {onComplete: function(flxTween:FlxTween)
			{

				FlxTween.tween(tutRemSprite,{'scale.x': 1, 'scale.y': 1}, 0.05, {onComplete: function(flxTween:FlxTween)
				{
					allowPlayerControl = true;
				}});

			}});

		}
		else
		{

		allowPlayerControl = false;

		FlxTween.tween(tutRemSprite,{'scale.x': 0.001, 'scale.y': 0.001}, 0.15, {onComplete: function(flxTween:FlxTween)
		{
			tutRemSprite.visible = false;
			allowPlayerControl = true;
		}});

		}

	}

	function updateHighscoreSong(songName:String)
	{

		var intendedScore:Int;
		var combo:String;

		var fullString:String;

		// adjusting the highscore song name to be compatible (changeDiff)
		var songHighscore = StringTools.replace(songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}

		intendedScore = Highscore.getScore(songHighscore, ModGlobals.currentDifficulty);
		combo = Highscore.getCombo(songHighscore, ModGlobals.currentDifficulty);

		if (combo != '')
			fullString = Std.string(intendedScore) + " (" + combo + ")";
		else
			fullString = Std.string(intendedScore);

		scoreText.text = fullString;
		scoreText.updateHitbox();
		scoreText.screenCenter(X);
		scoreText.visible = true;

	}

	function updateHighscoreWeek(curWeek:Int)
	{

		var intendedScore:Int;

		intendedScore = Highscore.getWeekScore(curWeek, ModGlobals.currentDifficulty);

		scoreText.text = Std.string(intendedScore);
		scoreText.updateHitbox();
		scoreText.screenCenter(X);
		scoreText.visible = true;

	}

}
