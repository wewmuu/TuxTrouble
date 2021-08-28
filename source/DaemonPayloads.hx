package;

import lime.utils.Assets;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;
using Date;
using DateTools;

/*
 * Easter eggs
*/

class MansionPayload extends MusicBeatState
{

  static var today:Date = Date.now();

  static var triggerDate:Date = new Date(2021, 1, 14, 0, 0, 0); // the date on which to trigger.

  var allowPressEnter:Bool = false;

  public static function canTrigger():Bool
  {

    var todayStr:String = DateTools.format(today, "%m-%d");

    var triggerStr:String = DateTools.format(triggerDate, "%m-%d");

    var output:Bool = (todayStr == triggerStr); // evaluates true if todays date matched the set trigger date.

    return output;

  }

  public static function yearsSince():Int
  {
    return today.getFullYear() - triggerDate.getFullYear();
  }

  override function create()
	{

    var mansion:FlxSprite = new FlxSprite().loadGraphic(Paths.image("2.14.21", "payloads"));
    mansion.setGraphicSize(0, FlxG.height);
    mansion.updateHitbox();
    mansion.screenCenter(Y);
    mansion.antialiasing = true;
    mansion.alpha = 0;

    add(mansion);

    FlxG.sound.playMusic(Paths.music("secret", "shared"), 0);

    FlxG.sound.music.fadeIn(4, 0, 0.7);

    FlxTween.tween(mansion, {alpha: 0.15}, 4, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween)
    	{
        allowPressEnter = true;
    	}
    });

    super.create();

  }

  override function update(elapsed:Float)
  {

    //var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

    //if (pressedEnter && allowPressEnter)
    if ((controls.ACCEPT || controls.BACK) && allowPressEnter)
    {
      FlxG.sound.playMusic(Paths.music('recycler'));
      Conductor.changeBPM(113); // recycler bpm
      FlxG.switchState(new MainMenuState());
    }

    super.update(elapsed);
  }

}
