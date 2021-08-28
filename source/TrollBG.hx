package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

using StringTools;

/**
 * The scrolling Background.
 */
class TrollBG extends FlxSprite
{
	public var delay:Float = 2;
  public var moveLimitx:Int = 100;
  public var moveLimity:Int = 100;
  public var lerpThing:Float = 0.005;

	// for the tweening
	public var targetY:Float;
  public var targetX:Float;
  public var defY:Float;
	public var defX:Float;

  public var bgTimer:FlxTimer;

	public function new(x:Float, y:Float)
	{
		super(x, y);

    this.antialiasing = true;

    defX = this.x;
    defY = this.y;

    bgTimer = new FlxTimer().start(delay, function(tmr:FlxTimer)
    {

      //targetY = FlxG.random.float(defY, defY - 100);
      //targetX = FlxG.random.float(defX, defX - 100);
      targetY = FlxG.random.float(defY, defY - moveLimity);
      targetX = FlxG.random.float(defX, defX - moveLimitx);

    }, 0);

	}

  override function update(elapsed:Float)
  {
    super.update(elapsed);

    x = FlxMath.lerp(x, targetX, 0.005);

    y = FlxMath.lerp(y, targetY, 0.005);

  }

  public function updateDefaultPos(xUp:Float, yUp:Float)
  {
    bgTimer.cancel();

    defX = xUp;
    defY = yUp;

    bgTimer = new FlxTimer().start(delay, function(tmr:FlxTimer)
    {

      //targetY = FlxG.random.float(defY, defY - 100);
      //targetX = FlxG.random.float(defX, defX - 100);
      targetY = FlxG.random.float(defY, defY - moveLimity);
      targetX = FlxG.random.float(defX, defX - moveLimitx);

    }, 0);

  }

}
