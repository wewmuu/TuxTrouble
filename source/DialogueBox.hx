package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';
	var curOrient:String = '';
	var curSoundByte:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var stillPortraits:Bool = true;
	var oldDiaBox:Bool = false;

	var stillOffsetY:Float = 24;

	static var keepMusicPlaying:Bool = false;

	public function new(dialogueList:Array<String>, ?_stillPortraits:Bool = true, ?_oldDiaBox:Bool = false)
	{
		super();

		stillPortraits = _stillPortraits;
		oldDiaBox = _oldDiaBox;

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'hornz':
				//FlxG.sound.playMusic(Paths.music('Moo', 'mansion'), 0);
				FlxG.sound.playMusic(Paths.music('strawberrylarp', 'mansion'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'daemon':
				//FlxG.sound.playMusic(Paths.music('Moo', 'mansion'), 0);
				FlxG.sound.playMusic(Paths.music('strawberrylarp', 'mansion'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'trolling':
				//FlxG.sound.playMusic(Paths.music('Moo', 'mansion'), 0);
				FlxG.sound.playMusic(Paths.music('strawberrylarp', 'mansion'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'f.l.o.s.s':
				//FlxG.sound.playMusic(Paths.music('Moo', 'mansion'), 0);
				if (!keepMusicPlaying)
				{
					FlxG.sound.playMusic(Paths.music('ravenbridge_mansion', 'mansion'), 0);
					FlxG.sound.music.time = 22000;
					FlxG.sound.music.fadeIn(1, 0, 0.8);
					keepMusicPlaying = true;
				}
				else
					keepMusicPlaying = false;
			case 'troublemakers':
				//FlxG.sound.playMusic(Paths.music('Moo', 'mansion'), 0);
				FlxG.sound.playMusic(Paths.music('strawberrylarp', 'mansion'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);

		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);

			case 'hornz':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dia');
				box.animation.addByIndices('normalOpen', 'dia', [0,1,2,3,4,5], "", 24,false);
				box.animation.addByIndices('normal', 'dia', [6], "", 24);
				box.width = 230;
				box.height = 230;
				box.x = 100;
				box.y = 35;

			case 'daemon':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dia');
				box.animation.addByIndices('normalOpen', 'dia', [0,1,2,3,4,5], "", 24,false);
				box.animation.addByIndices('normal', 'dia', [6], "", 24);
				box.width = 230;
				box.height = 230;
				box.x = 100;
				box.y = 35;

			case 'f.l.o.s.s':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dia');
				box.animation.addByIndices('normalOpen', 'dia', [0,1,2,3,4,5], "", 24,false);
				box.animation.addByIndices('normal', 'dia', [6], "", 24);
				box.width = 230;
				box.height = 230;
				box.x = 100;
				box.y = 35;

			case 'trolling':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dia');
				box.animation.addByIndices('normalOpen', 'dia', [0,1,2,3,4,5], "", 24,false);
				box.animation.addByIndices('normal', 'dia', [6], "", 24);
				box.width = 230;
				box.height = 230;
				box.x = 100;
				box.y = 35;

			case 'troublemakers':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dia');
				box.animation.addByIndices('normalOpen', 'dia', [0,1,2,3,4,5], "", 24,false);
				box.animation.addByIndices('normal', 'dia', [6], "", 24);
				box.width = 230;
				box.height = 230;
				box.x = 100;
				box.y = 35;
		}

		this.dialogueList = dialogueList;

		if (!hasDialog)
			return;
	if (!stillPortraits && (PlayState.SONG.song.toLowerCase()=='senpai' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='thorns'))
	{
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
    }

	if (!stillPortraits && PlayState.SONG.song.toLowerCase()=='hornz')
	{
		portraitLeft = new FlxSprite(200, 167);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/port');
		portraitLeft.animation.addByPrefix('enter', 'portrait', 24, false);
		//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
		//portraitLeft.x = -1000;
    }

	if (!stillPortraits && PlayState.SONG.song.toLowerCase()=='hornz')
	{
		portraitRight = new FlxSprite(684.05, 190);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfport');
		portraitRight.animation.addByPrefix('enter', 'bfport', 24, false);
		//portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
    }

	if (!stillPortraits && PlayState.SONG.song.toLowerCase()=='daemon')
	{
		portraitLeft = new FlxSprite(200, 167);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/port');
		portraitLeft.animation.addByPrefix('enter', 'portrait', 24, false);
		//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
		//portraitLeft.x = -1000;
    }

	if (!stillPortraits && PlayState.SONG.song.toLowerCase()=='daemon')
	{
		portraitRight = new FlxSprite(684.05, 190);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfport');
		portraitRight.animation.addByPrefix('enter', 'bfport', 24, false);
		//portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
    }

	if (!stillPortraits && PlayState.SONG.song.toLowerCase()=='f.l.o.s.s')
	{
		portraitLeft = new FlxSprite(200, 167);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/portd');
		portraitLeft.animation.addByPrefix('enter', 'portrait', 24, false);
		//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
		//portraitLeft.x = -1000;
    }

	if (!stillPortraits && PlayState.SONG.song.toLowerCase()=='f.l.o.s.s')
	{
		portraitRight = new FlxSprite(684.05, 190);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfport');
		portraitRight.animation.addByPrefix('enter', 'bfport', 24, false);
		//portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
    }

	if (!stillPortraits && PlayState.SONG.song.toLowerCase()=='trolling')
	{
		portraitLeft = new FlxSprite(200, 167);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/port');
		portraitLeft.animation.addByPrefix('enter', 'portrait', 24, false);
		//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
		//portraitLeft.x = -1000;
    }

	if (!stillPortraits && PlayState.SONG.song.toLowerCase()=='trolling')
	{
		portraitRight = new FlxSprite(684.05, 190);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfport');
		portraitRight.animation.addByPrefix('enter', 'bfport', 24, false);
		//portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
    }

	if (!stillPortraits && (PlayState.SONG.song.toLowerCase()=='senpai' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='thorns'))
	{
		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
	}

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		//if (!stillPortraits)
			//portraitLeft.screenCenter(X);

		if (stillPortraits)
		{
			portraitLeft = new FlxSprite(0, 0);
			portraitLeft.loadGraphic(Paths.image('portraits/P_Beastie'));

			portraitLeft.antialiasing = true;

			portraitLeft.flipX = true;
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			portraitLeft.visible = false;

			portraitLeft.screenCenter(Y);
			portraitLeft.y -= stillOffsetY;
			portraitLeft.x = box.x + Std.int(portraitLeft.width * 0.5);

			add(portraitLeft);

			portraitRight = new FlxSprite(0, 0);
			portraitRight.loadGraphic(Paths.image('portraits/P_BF'));
			portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.9));

			portraitRight.antialiasing = true;

			portraitRight.flipX = true;
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			portraitRight.visible = false;

			portraitRight.screenCenter(Y);
			portraitRight.y -= stillOffsetY;
			portraitRight.x = box.x + box.width - Std.int(portraitRight.width * 1.5);

			add(portraitRight);
		}

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 38);
		dropText.font = 'Delfino';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 38);
		swagDialogue.font = 'Delfino';
		swagDialogue.color = 0xFF3F2021;
		//#if web
		//swagDialogue.finishSounds = true;
		//#end
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);

			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'hornz' || PlayState.SONG.song.toLowerCase() == 'daemon' || PlayState.SONG.song.toLowerCase() == 'trolling' || PlayState.SONG.song.toLowerCase() == 'troublemakers')
						FlxG.sound.music.fadeOut(2.2, 0);
					else if (PlayState.SONG.song.toLowerCase() == 'f.l.o.s.s' && !keepMusicPlaying)
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);

		switch (curCharacter)
		{
			case 'dad':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('diaSounds/beastieText'), 0.6)];

			case 'bf':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('diaSounds/bfText'), 0.6)];

			case 'P_Troublemakers':
				if (stillPortraits)
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('diaSounds/gavrocheText'), 0.6), FlxG.sound.load(Paths.sound('diaSounds/hexleyText'), 0.6)];

			default:
				if (stillPortraits && curSoundByte != '')
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound(curSoundByte), 0.6)];
		}

		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				if (!stillPortraits)
				{
					portraitRight.visible = false;
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');

				}
				else
				{
					portraitLeft.loadGraphic(Paths.image('portraits/P_Missing'));
					portraitLeft.updateHitbox();
					portraitLeft.screenCenter(Y);
					portraitLeft.y -= stillOffsetY;
					portraitLeft.x = box.x + Std.int(portraitLeft.width * 0.5);

					portraitRight.visible = false;
					portraitLeft.visible = true;
				}

			case 'bf':
				if (!stillPortraits)
				{
					portraitLeft.visible = false;
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
				else
				{
					portraitRight.loadGraphic(Paths.image('portraits/P_BF'));
					portraitRight.updateHitbox();
					portraitRight.screenCenter(Y);
					portraitRight.y -= stillOffsetY;
					portraitRight.x = box.x + box.width - Std.int(portraitRight.width * 1.5);

					portraitLeft.visible = false;
					portraitRight.visible = true;
				}

			default:
				if (stillPortraits && curOrient != '')
				{

					switch (curOrient)
					{

						case 'left':
							portraitLeft.loadGraphic(Paths.image('portraits/' + curCharacter));
							portraitLeft.updateHitbox();

							portraitLeft.flipX = false;

							portraitLeft.screenCenter(Y);
							portraitLeft.y -= stillOffsetY;
							portraitLeft.x = box.x + Std.int(portraitLeft.width * 0.5);

							portraitRight.visible = false;
							portraitLeft.visible = true;

						case 'left_flip':
							portraitLeft.loadGraphic(Paths.image('portraits/' + curCharacter));
							portraitLeft.updateHitbox();

							portraitLeft.flipX = true;

							portraitLeft.screenCenter(Y);
							portraitLeft.y -= stillOffsetY;
							portraitLeft.x = box.x + Std.int(portraitLeft.width * 0.5);

							portraitRight.visible = false;
							portraitLeft.visible = true;

						case 'right':
							portraitRight.loadGraphic(Paths.image('portraits/' + curCharacter));
							portraitRight.updateHitbox();

							portraitRight.flipX = false;

							portraitRight.screenCenter(Y);
							portraitRight.y -= stillOffsetY;
							portraitRight.x = box.x + box.width - Std.int(portraitRight.width * 1.5);

							portraitLeft.visible = false;
							portraitRight.visible = true;

						case 'right_flip':
							portraitRight.loadGraphic(Paths.image('portraits/' + curCharacter));
							portraitRight.updateHitbox();

							portraitRight.flipX = true;

							portraitRight.screenCenter(Y);
							portraitRight.y -= stillOffsetY;
							portraitRight.x = box.x + box.width - Std.int(portraitRight.width * 1.5);

							portraitLeft.visible = false;
							portraitRight.visible = true;

						default:
							portraitLeft.loadGraphic(Paths.image('portraits/' + curCharacter));
							portraitLeft.updateHitbox();

							portraitLeft.flipX = false;

							portraitLeft.screenCenter(Y);
							portraitLeft.y -= stillOffsetY;
							portraitLeft.x = box.x + Std.int(portraitLeft.width * 0.5);

							portraitRight.visible = false;
							portraitLeft.visible = true;
					}

				}


		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");

		curCharacter = splitName[1];
		curOrient = splitName[0];

		if (stillPortraits) // just always use this if we are using still portraits
		{
			//var larpHardCode:String = StringTools.replace('P_', curOrient, '');

			/*larpHardCode = StringTools.replace('0', larpHardCode, '');
			larpHardCode = StringTools.replace('1', larpHardCode, '');
			larpHardCode = StringTools.replace('2', larpHardCode, '');
			larpHardCode = StringTools.replace('3', larpHardCode, '');
			larpHardCode = StringTools.replace('4', larpHardCode, '');
			larpHardCode = StringTools.replace('4', larpHardCode, '');
			larpHardCode = StringTools.replace('6', larpHardCode, '');
			larpHardCode = StringTools.replace('7', larpHardCode, '');
			larpHardCode = StringTools.replace('8', larpHardCode, '');
			larpHardCode = StringTools.replace('9', larpHardCode, '');*/

			//switch (larpHardCodeA.toLowerCase())

			// I FUCKING HATE THIS YANDEV TYPE CODE, BUT I CANNOT WORK OUT ANY
			// REASONABLY BETTER WAY TO DO THIS.

			if (StringTools.contains(curCharacter, 'Beastie'))
				curSoundByte = 'diaSounds/beastieText';

			else if (StringTools.contains(curCharacter, 'Bsuit'))
				curSoundByte = 'diaSounds/beastieText';

			else if (StringTools.contains(curCharacter, 'Beastie_old'))
				curSoundByte = 'diaSounds/beastieText';

			else if (StringTools.contains(curCharacter, 'Bsuit_old'))
				curSoundByte = 'diaSounds/beastieText';

			else if (StringTools.contains(curCharacter, 'Gavroche'))
				curSoundByte = 'diaSounds/gavrocheText';

			else if (StringTools.contains(curCharacter, 'Hexley'))
				curSoundByte = 'diaSounds/hexleyText';

			else if (StringTools.contains(curCharacter, 'Puffy'))
				curSoundByte = 'diaSounds/puffyText';

			else if (StringTools.contains(curCharacter, 'Tux'))
				curSoundByte = 'diaSounds/tuxText';

			else if (StringTools.contains(curCharacter, 'Gnu'))
				curSoundByte = 'diaSounds/gnuText';

			else if (StringTools.contains(curCharacter, 'BF'))
				curSoundByte = 'diaSounds/bfText';

			else
				curSoundByte = 'pixelText'; // default to pixeltext if the character isn't hardcoded (ahem gnu)

		}

		//trace(curOrient);
		dialogueList[0] = dialogueList[0].substr(splitName[0].length + splitName[1].length + 2).trim();
	}
}
