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
  * Here I assemble the background for menu items from sprites to allow for the background to stretch without distorting.

  * This is NOT scalable. Trust me, I fucking tried. But since the assholes maintaining flixel decided to not make this
  * something it does itself when you scale a group of sprites, I had to try to implement it myself.
  * When implementing it myself the sprites would either end up clipping into each other at certain scales and at various times.
  * The furthest I got the left tail always was a pixel too far in and I could not wrap my head around what the fuck was wrong with the math.
  * I didn't want to hack together a fix by just adding or subtracting a fucking pixel, so I have given up.
  * I need to program the rest of the menus, and I am losing my fucking mind doing this.
  * For your own sake, if you need to change the size of the menu items, just scale the fucking images outside of code.
  * That's probably what I'll be doing after this.
 */

class ManiaMenuItemBG extends FlxSpriteGroup
{

  private var tailLeft:FlxSprite = new FlxSprite(0, 0, Paths.image('tuxMenu/blankSM/TT_MENU_OPTION2_EDGE1')); // 68 px
  private var tailRight:FlxSprite = new FlxSprite(474, 0, Paths.image('tuxMenu/blankSM/TT_MENU_OPTION2_EDGE2')); // 76 px
  private var bgCenter:FlxSprite = new FlxSprite(68, 0, Paths.image('tuxMenu/blankSM/TT_MENU_OPTION2_CENT')); // 406 px

  private var bgCenterFrameWidthReal:Int; // thanks to what I hope is a bug in flxsprite, the frameWidth doesn't update when scaling and updating the hitbox, so I need to do this for scaling to work.
  public var _isShowingSelected = false;
  private var lastScaleX:Float = 1;

	public function new(x:Float, y:Float)
	{
		super(x, y);

    bgCenter.antialiasing = true;
    tailLeft.antialiasing = true;
    tailRight.antialiasing = true;

    bgCenterFrameWidthReal = bgCenter.frameWidth;

    bgCenter.x = tailLeft.frameWidth;
    tailRight.x = tailLeft.frameWidth + bgCenter.frameWidth;

    bgCenter.updateHitbox();
    tailRight.updateHitbox();

    add(tailLeft);
    add(bgCenter);
    add(tailRight);

    showUnselected();

    //super.updateHitbox();

	}

  public function showSelected(){
    tailLeft.loadGraphic(Paths.image('tuxMenu/blankSM/TT_MENU_OPTION2_EDGE1'));
    tailRight.loadGraphic(Paths.image('tuxMenu/blankSM/TT_MENU_OPTION2_EDGE2'));
    bgCenter.loadGraphic(Paths.image('tuxMenu/blankSM/TT_MENU_OPTION2_CENT'));

    _isShowingSelected = true;
  }

  public function showUnselected(){
    tailLeft.loadGraphic(Paths.image('tuxMenu/blankSM/TT_MENU_OPTION_EDGE1'));
    tailRight.loadGraphic(Paths.image('tuxMenu/blankSM/TT_MENU_OPTION_EDGE2'));
    bgCenter.loadGraphic(Paths.image('tuxMenu/blankSM/TT_MENU_OPTION_CENT'));

    _isShowingSelected = false;
  }

  public function setOptionWidth(w:Int){

    // this crap is to resolve a stutter caused by ninjamuffin's homemade tweening
    // for widths that do not exceed 406, if the sprite is not scaled down, the text stutters on changing items
    // that is, unless we employ THIS

    // if the proposed width is greater than 407 then it is enough to be considered
    // for resize, if not, we will resize it anyway to hardcoded values barely noticeable
    // to the human eye - a one or two pixel difference between the sprites is not
    // something a average player will notice

    // I suspect along with the fact the size of the box isn't slightly bigger,
    // the issue is impacted by odd and even numbers which is natural because an odd or even
    // number can easily make enough of a difference if a 1 or two pixel change cases no trouble

    // for even numbers, bump up two pixels to 408
    // for odd, bump up to 407

    // If the issue somehow persists after this admittedly, hacky and possibly barking
    // up the wrong tree of a fix, I'll try to approach from another angle.

    //trace(bgCenter.width);

    var altWidth:Int = (w % 2 == 0 ? bgCenter.frameWidth+2 : bgCenter.frameWidth+1);

    //if (bgCenter.frameWidth % 2 == 0)
      //altWidth = (w % 2 == 0 ? bgCenter.frameWidth+2 : bgCenter.frameWidth+1);
    //else
      //altWidth = (w % 2 == 0 ? bgCenter.frameWidth+1 : bgCenter.frameWidth+2);

    if (w > bgCenter.frameWidth+1)
    {
      bgCenter.setGraphicSize(w+1, bgCenter.frameHeight);
      bgCenter.updateHitbox();
      tailLeft.updateHitbox();
      tailRight.x = w+1 + tailLeft.frameWidth;
      tailRight.updateHitbox();

      bgCenterFrameWidthReal = w+1;
    }
    else
    {
      bgCenter.setGraphicSize(altWidth, bgCenter.frameHeight);
      bgCenter.updateHitbox();
      tailLeft.updateHitbox();
      tailRight.x = altWidth + tailLeft.frameWidth;
      tailRight.updateHitbox();

      bgCenterFrameWidthReal = altWidth;
    }

    //trace(bgCenter.width);

  }

  override function update(elapsed:Float)
	{
    //super.update(elapsed);

    //bgCenter.x = this.x + Math.round(tailLeft.frameWidth * this.scale.x);
    //tailRight.x = this.x + Math.round(tailLeft.frameWidth * this.scale.x) + Math.round(bgCenterFrameWidthReal * this.scale.x);
    bgCenter.updateHitbox();
    tailRight.updateHitbox();
    tailLeft.updateHitbox();

    super.update(elapsed);
  }

}
