package;

import lime.utils.Assets;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import lime.app.Application;

using StringTools;
using Date;
using DateTools;

/*
 * Easter egg helper functions and base class
*/


class DaemonPayloadHelpers
{

  public function sendWindowAlert(?message:String, ?title:String)
  {
    var mainWindow = Application.current.window;
    mainWindow.alert(message, title); // this changes the focus to the alert, so no code can run during the alert message. Also, our only option is ok, no yes or no.
  }

}
