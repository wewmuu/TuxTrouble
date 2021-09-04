package;
import flixel.*;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

//import flixel.addons.transition.FlxTransitionableState;

#if windows
import Discord.DiscordClient;
#end

using Lambda; // SHOOT YOURSLEF, HAXE DEVELOPERS

/**
 * ...
 */
//class EndingState extends FlxState // why the fuck did he make this an flxsprite? that ruins fade transitions.
class EndingState extends MusicBeatState
{

  var allowInput:Bool = false;

	var _goodEnding:Bool = false;
  var _badEnding:Bool = false;

	public function new(goodEnding:Bool = true)
	{
		super();
		_goodEnding = goodEnding;
    _badEnding = FlxG.random.bool(70); // set this here instead of on the fly so we can have an accurate discord rich presence

	}

	override public function create():Void
	{
		super.create();

    new FlxTimer().start(3, function(tmr:FlxTimer){
      allowInput = true;
    });

    if (!_badEnding) // set a flag for getting a larp ending. Is outside of the saveshit function since it has no reason to be set outside of this state (unlike the rest of the save stuff)
      FlxG.save.data.gotSecretEnding = false;

    saveShit(false); // set all of the save flags for getting an ending

    // --Discord--
    #if windows

    if (_goodEnding)
    {
      DiscordClient.changePresence("Got an Ending", 'Good Ending', 'ending0002');
    }
    else if (_badEnding){
      DiscordClient.changePresence("Got an Ending", 'Bad Ending', 'ending0001');
    }
    else
    {
      DiscordClient.changePresence("Got an Ending", 'A Secret Ending', 'secret');
    }

    #end


    // --DISPLAY ENDINGS--

		var end:FlxSprite = new FlxSprite(0, 0);
		if (_goodEnding)
    {
			end.loadGraphic(Paths.image("endings/ending0002"));
			FlxG.sound.playMusic(Paths.music("demon_rail_andante"),1,false);
      Conductor.changeBPM(100); // use demon rail bpm here
		  FlxG.camera.fade(FlxColor.BLACK, 0.8, true);
		}

    else
    {

			if (_badEnding)
      {
			end.loadGraphic(Paths.image("endings/ending0001"));
			FlxG.sound.playMusic(Paths.music("demon_rail_andante"), 1, false);
      Conductor.changeBPM(100); // use demon rail bpm here
			FlxG.camera.fade(FlxColor.BLACK, 0.8, true);
			}

      else
      {
			end.loadGraphic(Paths.image("endings/ending0003"));
			FlxG.sound.playMusic(Paths.music("my_first_streetpass_hit"), 1, false);
      Conductor.changeBPM(100); // use gustavo bpm here
			}


		}

		add(end);

		//new FlxTimer().start(8, endIt);
		//new FlxTimer().start(20, endIt); // 8 seconds is super short. I'm making that 20.

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		//if (FlxG.keys.pressed.ENTER && allowInput){
		if ((controls.BACK || controls.ACCEPT) && allowInput){
			endIt();
		}

	}


	public function endIt(e:FlxTimer=null){
		trace("ENDING");

    //transIn = FlxTransitionableState.defaultTransIn;
    //transOut = FlxTransitionableState.defaultTransOut;

    //FlxTransitionableState.skipNextTransIn = true;
    //FlxTransitionableState.skipNextTransOut = true;

		//FlxG.switchState(new StoryMenuState());
		//FlxG.switchState(new MainMenuState()); // StoryMenuState is being retired
    if(FlxG.save.data.botplay)
    {
      FlxG.switchState(new MainMenuState());
    }
    else if (FlxG.save.data.seenUnlockMessage)
    {
      FlxG.switchState(new VideoState(Paths.webm('credits'), new MainMenuState()));
    }
    else if (!FlxG.save.data.seenUnlockMessage && PlayState.storyDifficulty == 2)
    {
      FlxG.save.data.seenUnlockMessage = true;
      FlxG.switchState(new VideoState(Paths.webm('credits'), new UnlockMessageState(new MainMenuState(), Paths.image('unlock/unlock002'))));
    }
    else if (!FlxG.save.data.seenUnlockMessage)
    {
      FlxG.switchState(new VideoState(Paths.webm('credits'), new UnlockMessageState(new MainMenuState(), Paths.image('unlock/unlock001'))));
    }
	}

  public static function saveShit(?isNiiteRemix:Bool = false) // this will probably be called outside of this state for the niite story week (which I assume will not have endings)
  {
    // --SAVE DATA SHIT--
    // this is stupid, please rewrite

    // remove this, the story menu is being replaced.

    if (FlxG.save.data.trollingHide && !FlxG.save.data.weekClearTUX && !FlxG.save.data.botplay && !isNiiteRemix)
    {
      FlxG.save.data.trollingHide = false;
      //trace("Track spoilers for trolling should be turned on!");
      //trace(FlxG.save.data.trollingHide);
    }

    // Set the week clear flag AFTER we have checked and done the stuff above

    if(!FlxG.save.data.botplay)
    {

      switch (isNiiteRemix)
      {
        case false:
          FlxG.save.data.weekClearTUX = true;

          // set a flag of the highest cleared difficulty for main menu trophies
          if (PlayState.storyDifficulty >= FlxG.save.data.weekClearDifficultyTUX)
            FlxG.save.data.weekClearDifficultyTUX = PlayState.storyDifficulty;

          if (!Lambda.has(FlxG.save.data.ratsUnlocked, 'beastie/')) // USE LAMBDA INSTEAD OF COBTAINS BECAUSE HAXE IS STUPID AND DIDN'T SAY THAT CONTAINS DOESN'T WORK ON JS
            FlxG.save.data.ratsUnlocked.push('beastie/');

        case true:
          FlxG.save.data.weekClearNIITE = true;

          // set a flag of the highest cleared difficulty for main menu trophies
          if (PlayState.storyDifficulty >= FlxG.save.data.weekClearDifficultyNIITE)
            FlxG.save.data.weekClearDifficultyNIITE = PlayState.storyDifficulty;

          if (!Lambda.has(FlxG.save.data.ratsUnlocked, 'freestyle/')) // I'M SO FUCKING ANGRY AT KADE AND HAXE. LET ME NEVER USE OR WORK ON/WITH THIS HORRIBLE SHIT CODE EVER AGAIN. FUCK.
            FlxG.save.data.ratsUnlocked.push('freestyle/');

      }

    }


    FlxG.save.flush(); // MAKE SURE FLAGS ARE SAVED
  }

}
