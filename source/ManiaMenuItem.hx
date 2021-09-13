package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

/**
 * Loosley based on Alphabet.hx except it isn't complete shit and uses a REAL, NOT FAKE, BUT A REAL FUCKING FONT WITH A COMPLETE SET OF CHARACTERS INCLUDING PERIODS AND NUMBERS, NINJAMUFFIN.
 */
class ManiaMenuItem extends FlxSpriteGroup
{
	public var delay:Float = 0.05;
	public var paused:Bool = false;

	// for menu shit
	public var targetY:Float = 0;
	public var isMovingMenuItem:Bool = true; // defaults to true. Can be false so I can add alternative menu layouts later if I want.

	public var text:String = "";

	public var widthOfWords:Float = FlxG.width;

	var yMulti:Float = 1;

  //var spriteBG:FlxSprite;
  //var spriteBG:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tuxMenu/TT_MENU_OPTION')); // Load background early so Update() doesn't flip out
  var spriteBG:ManiaMenuItemBG = new ManiaMenuItemBG(0, 0); // Load background early so Update() doesn't flip out
  //var renderedText = new FlxText(123, 10, -10, text, 12);
  var renderedText:FlxText;

  var freeplayOrientation:Bool = false;

	// bus
	public var isBus:Bool = false;
	public static var busX:Int = 0;
	var busBG:FlxSprite = new FlxSprite(0,0);

  public function new(x:Float, y:Float, text:String = "", ?_freeplayOrientation:Bool = false, ?_isBus:Bool = false)
	{
		super(x, y);
		this.text = text;

		isBus = _isBus;

    freeplayOrientation = _freeplayOrientation;

    renderedText = new FlxText(0, 9, 0, text, 12);

    //renderedText.setFormat("Koverwatch", 116, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    renderedText.setFormat("Koverwatch", 92, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    renderedText.borderSize = 6;
    //renderedText.frameWidth += 5;

    renderedText.updateHitbox();

    renderedText.antialiasing = true;
    //renderedText.alpha = 0.6;

    //spriteBG.setGraphicSize(renderedText.frameWidth + 128, spriteBG.frameHeight);
		if (!isBus)
		{
    	spriteBG.setOptionWidth(renderedText.frameWidth + 32);

    	spriteBG.updateHitbox();

			renderedText.x = spriteBG.getMidpoint().x - renderedText.getMidpoint().x;
		}
		else
		{
			busBG.loadGraphic(Paths.image('tuxMenu/bus'));
			busBG.antialiasing = true;
			renderedText.x = busBG.getMidpoint().x - renderedText.getMidpoint().x;
			renderedText.y += 9;
			add(busBG);
		}

		if (text != "")
		{
			if (!isBus)
      	addSpriteBG();
			addText();
		}
	}

	public function addText()
	{




    add(renderedText);
	}

  public function addSpriteBG()
	{
    //var spriteBG = new FlxSprite(0, 0).loadGraphic(Paths.image('tuxMenu/TT_MENU_OPTION'));

    add(spriteBG);
	}

	override function update(elapsed:Float)
	{
    // This is always a menu item.

		if (isMovingMenuItem && !isBus)
		{

  		var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

      if (freeplayOrientation)
      {
        y = FlxMath.lerp(y, (scaledY * 146) + (FlxG.height * 0.54), 0.30); // best I can do for freeplay
        x = FlxMath.lerp(x, -(targetY * 67) - (spriteBG.width - 406) + 340, 0.30);
      }
      else
      {
        y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.30);
        x = FlxMath.lerp(x, (targetY * 20) + 90, 0.30);
      }

      // Hacky, but it means less menu code I'll need to rewrite (hopefully)
      if (targetY == 0 && !spriteBG._isShowingSelected)
      {
        spriteBG.showSelected();
      }
      else if (targetY != 0 && spriteBG._isShowingSelected)
      {
        spriteBG.showUnselected();
      }

    }
		else if (isBus)
		{

			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

			if (freeplayOrientation)
			{
				y = FlxMath.lerp(y, (scaledY * 146) + (FlxG.height * 0.54), 0.30); // best I can do for freeplay
				x = busX + FlxMath.lerp(x, -(targetY * 67) - (spriteBG.width - 406) + 340, 0.30);
			}
			else
			{
				y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.30);
				x = busX + FlxMath.lerp(x, (targetY * 20) + 90, 0.30);
			}

			// Hacky, but it means less menu code I'll need to rewrite (hopefully)
			if (targetY == 0)
			{
				busBG.loadGraphic(Paths.image('tuxMenu/bus2'));
			}
			else if (targetY != 0)
			{
				busBG.loadGraphic(Paths.image('tuxMenu/bus'));
			}

		}

		super.update(elapsed);
	}
}
