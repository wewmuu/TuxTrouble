import openfl.Lib;
import flixel.FlxG;

class KadeEngineData
{
    public static function initSave()
    {
        if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;

		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.songPosition == null)
			FlxG.save.data.songPosition = false;

		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = false;

		if (FlxG.save.data.changedHit == null)
		{
			FlxG.save.data.changedHitX = -1;
			FlxG.save.data.changedHitY = -1;
			FlxG.save.data.changedHit = false;
		}

		if (FlxG.save.data.fpsRain == null)
			FlxG.save.data.fpsRain = false;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 120;

		if (FlxG.save.data.fpsCap > 285 || FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = 120; // baby proof so you can't hard lock ur copy of kade engine

		if (FlxG.save.data.scrollSpeed == null)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.npsDisplay == null)
			FlxG.save.data.npsDisplay = false;

		if (FlxG.save.data.frames == null)
			FlxG.save.data.frames = 10;

		if (FlxG.save.data.accuracyMod == null)
			FlxG.save.data.accuracyMod = 1;

		if (FlxG.save.data.watermark == null)
			FlxG.save.data.watermark = false;

		if (FlxG.save.data.ghost == null)
			FlxG.save.data.ghost = true;

		if (FlxG.save.data.distractions == null)
			FlxG.save.data.distractions = true;

		if (FlxG.save.data.flashing == null)
			FlxG.save.data.flashing = true;

		if (FlxG.save.data.resetButton == null)
			FlxG.save.data.resetButton = false;

		if (FlxG.save.data.botplay == null)
			FlxG.save.data.botplay = false;

		if (FlxG.save.data.cpuStrums == null)
			FlxG.save.data.cpuStrums = true;

		if (FlxG.save.data.strumline == null)
			FlxG.save.data.strumline = false;

		if (FlxG.save.data.customStrumLine == null)
			FlxG.save.data.customStrumLine = 0;

		if (FlxG.save.data.camzoom == null)
			FlxG.save.data.camzoom = true;

		if (FlxG.save.data.scoreScreen == null)
			FlxG.save.data.scoreScreen = false;



    // Tux Trouble additions

    if (FlxG.save.data.persistDiff == null)
      FlxG.save.data.persistDiff = 1;

    if (FlxG.save.data.trollingHide == null)
      FlxG.save.data.trollingHide = true;

    if (FlxG.save.data.dialogueToggle == null) // DO NOT REMOVE EVEN IF TOGGLE DOES NOT EXIST IN OPTIONS MENU
      FlxG.save.data.dialogueToggle = true;

    if (FlxG.save.data.weekClearTUX == null)
      FlxG.save.data.weekClearTUX = false;

    if (FlxG.save.data.weekClearNIITE == null)
      FlxG.save.data.weekClearNIITE = false;

    if (FlxG.save.data.weekClearDifficultyTUX == null)
      FlxG.save.data.weekClearDifficultyTUX = -1;

    if (FlxG.save.data.weekClearDifficultyNIITE == null)
      FlxG.save.data.weekClearDifficultyNIITE = -1;

    if (FlxG.save.data.gotSecretEnding == null)
      FlxG.save.data.gotSecretEnding = false;

    if (FlxG.save.data.beatTrueTrolling == null)
      FlxG.save.data.beatTrueTrolling = false;

    if (FlxG.save.data.beatTrueTrollingDuet == null)
      FlxG.save.data.beatTrueTrollingDuet = false;

    if (FlxG.save.data.ratsUnlocked == null)
      FlxG.save.data.ratsUnlocked = [];

    if (FlxG.save.data.currentRat == null)
      FlxG.save.data.currentRat = 0;

    if (FlxG.save.data.ratCurrentColor == null)
      FlxG.save.data.ratCurrentColor = 0;

    if (FlxG.save.data.seenUnlockMessage == null)
      FlxG.save.data.seenUnlockMessage = false;

    if (FlxG.save.data.daemonDropToggle == null) // toggle the daemon drop event
      FlxG.save.data.daemonDropToggle = true;

    #if (windows && !NODISCORD && !DEMOBUILD)
    if (FlxG.save.data.discordRP == null) // Discord Rich Presence toggle
      FlxG.save.data.discordRP = true;
    #elseif windows
    FlxG.save.data.discordRP = false; // Disallow discord rpc on demos or dev builds
    #end

		Conductor.recalculateTimings();
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();

		Main.watermarks = FlxG.save.data.watermark;

		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
	}
}
