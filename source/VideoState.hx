package;

import flixel.FlxState;
import flixel.FlxG;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.system.FlxSound;
import openfl.utils.Assets;
import openfl.utils.AssetType;

import openfl.Lib;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class VideoState extends MusicBeatState
{
	public var leSource:String = "";
	public var transClass:FlxState;
	public var txt:FlxText;
	public var fuckingVolume:Float = 1;
	public var notDone:Bool = true;
	public var vidSound:FlxSound;
	public var useSound:Bool = false;
	public var soundMultiplier:Float = 1;
	public var prevSoundMultiplier:Float = 1;
	public var videoFrames:Int = 0;
	public var defaultText:String = "";
	public var doShit:Bool = false;
	public var pauseText:String = "Press P To Pause/Unpause";

	public function new(source:String, toTrans:FlxState)
	{

		// Video cutscene crap
		var ourSource:String = "assets/videos/DO NOT DELETE OR GAME WILL CRASH/dontDelete.webm";

		#if web
		var str1:String = "HTML CRAP";
		var vHandler = new VideoHandler();
		vHandler.init1();
		vHandler.video.name = str1;
		Lib.current.addChild(vHandler.video);
		vHandler.init2();
		GlobalVideo.setVid(vHandler);
		vHandler.source(ourSource);
		#elseif desktop
		var str1:String = "WEBM SHIT";
		var webmHandle = new WebmHandler();
		webmHandle.source(ourSource);
		webmHandle.makePlayer();
		webmHandle.webm.name = str1;
		Lib.current.addChild(webmHandle.webm);
		GlobalVideo.setWebm(webmHandle);
		#end

		super();

		leSource = source;
		transClass = toTrans;
	}

	override function create()
	{

		//FlxG.sound.music.stop();

		discordDisplay();

		super.create();
		FlxG.autoPause = false;
		doShit = false;

		if (GlobalVideo.isWebm)
		{
		videoFrames = Std.parseInt(Assets.getText(leSource.replace(".webm", ".txt")));
		}

		fuckingVolume = FlxG.sound.music.volume;
		FlxG.sound.music.volume = 0;
		var isHTML:Bool = false;
		#if web
		isHTML = true;
		#end
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var html5Text:String = "You Are Not Using HTML5...\nThe Video Didnt Load!";
		if (isHTML)
		{
			html5Text = "You Are Using HTML5!";
		}
		defaultText = "If Your On HTML5\nTap Anything...\nThe Bottom Text Indicates If You\nAre Using HTML5...\n\n" + html5Text;
		txt = new FlxText(0, 0, FlxG.width,
			defaultText,
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);

		if (GlobalVideo.isWebm)
		{
			if (Assets.exists(leSource.replace(".webm", ".ogg"), MUSIC) || Assets.exists(leSource.replace(".webm", ".ogg"), SOUND))
			{
				useSound = true;
				vidSound = FlxG.sound.play(leSource.replace(".webm", ".ogg"));
			}
		}

		GlobalVideo.get().source(leSource);
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

		/*if (useSound)
		{*/
			//vidSound = FlxG.sound.play(leSource.replace(".webm", ".ogg"));

			/*new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{*/

				// HTML5 FIX
				// This whole cutscene implementation will probably never build
				// for android by the way lmao
				#if !web
				vidSound.time = vidSound.length * soundMultiplier;
				#end


				/*new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					if (useSound)
					{
						vidSound.time = vidSound.length * soundMultiplier;
					}
				}, 0);*/
				doShit = true;
			//}, 1);
		//}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (useSound)
		{
			var wasFuckingHit = GlobalVideo.get().webm.wasHitOnce;
			soundMultiplier = GlobalVideo.get().webm.renderedCount / videoFrames;

			if (soundMultiplier > 1)
			{
				soundMultiplier = 1;
			}
			if (soundMultiplier < 0)
			{
				soundMultiplier = 0;
			}
			if (doShit)
			{
				var compareShit:Float = 50;
				if (vidSound.time >= (vidSound.length * soundMultiplier) + compareShit || vidSound.time <= (vidSound.length * soundMultiplier) - compareShit)
					vidSound.time = vidSound.length * soundMultiplier;
			}
			if (wasFuckingHit)
			{
			if (soundMultiplier == 0)
			{
				if (prevSoundMultiplier != 0)
				{
					vidSound.pause();
					vidSound.time = 0;
				}
			} else {
				if (prevSoundMultiplier == 0)
				{
					vidSound.resume();
					vidSound.time = vidSound.length * soundMultiplier;
				}
			}
			prevSoundMultiplier = soundMultiplier;
			}
		}

		if (notDone)
		{
			FlxG.sound.music.volume = 0;
		}
		GlobalVideo.get().update(elapsed);

		if (controls.RESET)
		{
			GlobalVideo.get().restart();
		}

		if (FlxG.keys.justPressed.P)
		{
			txt.text = pauseText;
			trace("PRESSED PAUSE");
			GlobalVideo.get().togglePause();
			if (GlobalVideo.get().paused)
			{
				GlobalVideo.get().alpha();
			} else {
				GlobalVideo.get().unalpha();
				txt.text = defaultText;
			}
		}

		if (controls.ACCEPT || GlobalVideo.get().ended || GlobalVideo.get().stopped)
		{
			txt.visible = false;
			GlobalVideo.get().hide();
			GlobalVideo.get().stop();
		}

		if (controls.ACCEPT || GlobalVideo.get().ended)
		{
			notDone = false;
			FlxG.sound.music.volume = fuckingVolume;
			txt.text = pauseText;
			FlxG.autoPause = true;
			FlxG.switchState(transClass);
		}

		if (GlobalVideo.get().played || GlobalVideo.get().restarted)
		{
			GlobalVideo.get().show();
		}

		GlobalVideo.get().restarted = false;
		GlobalVideo.get().played = false;
		GlobalVideo.get().stopped = false;
		GlobalVideo.get().ended = false;
	}

	function discordDisplay()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In a cutscene", null);
		#end
		trace('changed discordrpc if on windows');
	}

}
