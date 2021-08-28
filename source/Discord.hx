package;

#if windows
import Sys.sleep;
import discord_rpc.DiscordRpc;

import flixel.FlxG; // settings from save data

using StringTools;

class DiscordClient
{

	public static var onReadyText:String = "On the Title Screen";

	public function new()
	{

		if (FlxG.save.data.discordRP){

			trace("Discord Client starting...");
			DiscordRpc.start({
				clientID: "846515386823475200", // change this to what ever the fuck you want lol
				onReady: onReady,
				onError: onError,
				onDisconnected: onDisconnected
			});
			trace("Discord Client started.");

			while (true)
			{
				DiscordRpc.process();
				sleep(2);
				//trace("Discord Client Update");
			}

			DiscordRpc.shutdown();

		}

	}

	public static function shutdown()
	{
		if (FlxG.save.data.discordRP)
			DiscordRpc.shutdown();
	}

	static function onReady()
	{

		if (FlxG.save.data.discordRP){

			DiscordRpc.presence({
				details: onReadyText,
				state: null,
				largeImageKey: 'icon',
				largeImageText: "FNF: Tux Trouble " + MainMenuState.tuxTroubleVer
			});

		}

	}

	static function onError(_code:Int, _message:String)
	{
		if (FlxG.save.data.discordRP)
			trace('Error! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		if (FlxG.save.data.discordRP)
			trace('Disconnected! $_code : $_message');
	}

	public static function initialize()
	{

		if (FlxG.save.data.discordRP){

			var DiscordDaemon = sys.thread.Thread.create(() ->
			{
				new DiscordClient();
			});
			trace("Discord Client initialized");

		}

	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey : String, ?hasStartTimestamp : Bool, ?endTimestamp: Float)
	{

		if (FlxG.save.data.discordRP){

			var startTimestamp:Float = if(hasStartTimestamp) Date.now().getTime() else 0;

			if (endTimestamp > 0)
			{
				endTimestamp = startTimestamp + endTimestamp;
			}

			DiscordRpc.presence({
				details: details,
				state: state,
				largeImageKey: 'icon',
				largeImageText: "FNF: Tux Trouble " + MainMenuState.tuxTroubleVer,
				smallImageKey : smallImageKey,
				// Obtained times are in milliseconds so they are divided so Discord can use it
				startTimestamp : Std.int(startTimestamp / 1000),
	            endTimestamp : Std.int(endTimestamp / 1000)
			});

			//trace('Discord RPC Updated. Arguments: $details, $state, $smallImageKey, $hasStartTimestamp, $endTimestamp');

		}

	}
}
#end
