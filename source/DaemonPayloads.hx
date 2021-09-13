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

#if cpp
import sys.thread.Thread;
#end

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

class MeganPayload extends MusicBeatState
{

  override function create()
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

    FlxG.save.bind('funkin', 'ninjamuffin99');

    KadeEngineData.initSave();

    Highscore.load();

    super.create();

    var povMegan:FlxSprite = new FlxSprite().loadGraphic(Paths.image("povmegan", "payloads"));
    povMegan.setGraphicSize(0, FlxG.height);
    povMegan.updateHitbox();
    povMegan.screenCenter(Y);
    povMegan.antialiasing = true;
    povMegan.alpha = 0;

    add(povMegan);

    FlxG.sound.playMusic(Paths.music("trolled", "shared"), 0);

    FlxG.sound.music.fadeIn(4, 0, 0.7);

    FlxTween.tween(povMegan, {alpha: 1}, 4, {ease: FlxEase.quadIn});

  }

}
