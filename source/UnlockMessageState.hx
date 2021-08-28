package;
import flixel.*;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

//import flixel.addons.transition.FlxTransitionableState;

#if windows
import Discord.DiscordClient;
#end

/**
 * based on (old...?) endingstate
 */
class UnlockMessageState extends MusicBeatState
{

	var returnState:FlxState;
  var image:String = '';

	public function new(state:FlxState, imgName:String)
	{
		super();
		returnState = state;
    image = imgName;

	}

	override public function create():Void
	{
		super.create();

		var message:FlxSprite = new FlxSprite(0, 0);
		message.loadGraphic(image);
		add(message);

		new FlxTimer().start(6, endIt); // show message for 6 seconds

	}

	public function endIt(e:FlxTimer=null){
		FlxG.switchState(returnState); // go to next state
	}

}
