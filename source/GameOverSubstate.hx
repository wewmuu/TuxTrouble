package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	var deathLines:String = '';
	//var deathLines:String = 'freestyleGavHex';
	var deathLinesNum:Int = 0;
	//var deathLinesNum:Int = 6;

	public function new(x:Float, y:Float, ?_deathLines:String = '', ?_deathLinesNum:Int = 0)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (PlayState.SONG.player1)
		{
			case 'bf-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'noah': // freestyle bf
				daBf = 'noah';
			default:
				daBf = 'bf';
		}

		if (deathLines == '' || deathLinesNum == 0)
		{
			deathLines = _deathLines;
			deathLinesNum = _deathLinesNum;
		}

		super();

		Conductor.songPosition = 0;

		if (PlayState.SONG.stage == 'mansion4' || PlayState.SONG.stage == 'mansion4_tt' || PlayState.SONG.stage == 'larpy' || PlayState.SONG.stage == 'larpy2' || PlayState.SONG.stage == 'larpy3' || PlayState.SONG.stage == 'larpy4') // zoom in immediately and move bf if we're on a mansion stage
		{
			FlxG.camera.zoom = 1;
			y -= 150;
			x -= 150;
		}

		if ((PlayState.SONG.song == "True Trolling" || PlayState.SONG.song == "True Trolling (Duet)") && daBf == 'bf')
		{
			var bg:TrollBG = new TrollBG(-150, -80);
			bg.loadGraphic(Paths.image('peDesat'));
			bg.color = FlxColor.RED;
			bg.alpha = 0.3;
			bg.setGraphicSize(Std.int(bg.width * 1.1), Std.int(bg.height * 1.1));
			bg.updateHitbox();
			bg.antialiasing = true;
			bg.scrollFactor.set(0, 0);
			add(bg);

			// snohq don't lose the fla challenge: fails
			bf = new Boyfriend(x, y, 'tr_death');
			//bf.scale.x = 1.3;
			//bf.scale.y = bf.scale.x;
			//bf.updateHitbox();

			//bg.x = bf.getGraphicMidpoint().x - bg.getGraphicMidpoint().x;
			//bg.updateDefaultPos(bf.getGraphicMidpoint().x - bg.getGraphicMidpoint().x, 0);

			//bf.addOffset('deathConfirm', 37, 15); // needs to be done since we scaled the sprite and updated the hitbox
		}
		else
		{
			bf = new Boyfriend(x, y, daBf);
		}
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);

		if (bf.curCharacter == 'tr_death')
		{
			var camFollowOffset = -30;
			camFollow.x += camFollowOffset;
			camFollow.y += camFollowOffset;
		}

		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		if (PlayState.SONG.song == "True Trolling" || PlayState.SONG.song == "True Trolling (Duet)")
			Conductor.changeBPM(100); // use tex avery bpm here
		else
			Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			if (deathLines != '' && deathLinesNum != 0) // cut-off the game over burn lines to make it not weirdly play out to the change state
			{
				//FlxG.sound.music.fadeIn(0.5, 1);
				FlxG.sound.music.volume =  1;
				FlxG.sound.destroy();
			}
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new MainMenuState());
			else if (PlayState.SONG.song.toLowerCase() != 'true trolling' && PlayState.SONG.song.toLowerCase() != 'smooth')
				FlxG.switchState(new FreeplayState());
			else
				FlxG.switchState(new MainMenuState());
			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{

			if (PlayState.SONG.song == "True Trolling" || PlayState.SONG.song == "True Trolling (Duet)")
				FlxG.sound.playMusic(Paths.music('trolled_2'));
			else
				FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));

			if (deathLines == 'freestyleGavHex')
			{
				var deathLinesArray:Array<String> = ['freestyleGavroche', 'freestyleHexley'];
				deathLines = FlxG.random.getObject(deathLinesArray);
			}

			if (deathLines != '' && deathLinesNum != 0)
			{

				FlxG.sound.music.fadeOut(1, 0.3);
				var roast = FlxG.sound.play(Paths.sound('gameOver/' + deathLines + '/' + FlxG.random.int(1, deathLinesNum)), 2);
				roast.onComplete = function(){
					FlxG.sound.music.fadeIn(0.5, 1);
				}

			}

		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			if (deathLines != '' && deathLinesNum != 0) // cut-off the game over burn lines to make it not weirdly play out to the change state
			{
				//FlxG.sound.music.fadeIn(0.5, 1);
				FlxG.sound.music.volume =  1;
				FlxG.sound.destroy();
			}
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					if (PlayState.isStoryMode)
						PlayState.replayDialougeSkip = true;
					else
						PlayState.replayDialougeSkip = false;
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
