/*
	Modifying bots iw5
*/

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\bots\_bot_utility;

/*
	Init
*/
init()
{
	if ( getDvar( "bots_main_chat" ) == "" )
		setDvar( "bots_main_chat", 1.0 );

	level thread onBotConnected();
}

/*
	Bot connected
*/
onBotConnected()
{
	for ( ;; )
	{
		level waittill( "bot_connected", bot );

		bot thread start_chat_threads();
	}
}

/*
	Does the chatter
*/
BotDoChat( chance, string, isTeam )
{
	mod = getDvarFloat( "bots_main_chat" );

	if ( mod <= 0.0 )
		return;

	if ( chance >= 100 || mod >= 100.0 ||
	    ( RandomInt( 100 ) < ( chance * mod ) + 0 ) )
	{
		if ( isDefined( isTeam ) && isTeam )
			self sayteam( string );
		else
			self sayall( string );
	}
}

/*
	Threads for bots
*/
start_chat_threads()
{
	self endon( "disconnect" );

	self thread start_onnuke_call();
	self thread start_random_chat();
	self thread start_chat_watch();
	self thread start_killed_watch();
	self thread start_death_watch();
	self thread start_endgame_watch();

	self thread start_startgame_watch();
}

/*
	Nuke gets called
*/
start_onnuke_call()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		while ( !isDefined( level.nukeIncoming ) && !isDefined( level.moabIncoming ) )
			wait 0.05 + randomInt( 4 );

		self thread bot_onnukecall_watch();

		wait level.nukeTimer + 5;
	}
}

/*
	death
*/
start_death_watch()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "death" );

		self thread bot_chat_death_watch( self.lastAttacker, self.bots_lastKS );

		self.bots_lastKS = 0;
	}
}

/*
	start_endgame_watch
*/
start_endgame_watch()
{
	self endon( "disconnect" );

	level waittill ( "game_ended" );

	self thread endgame_chat();
}

/*
	Random chatting
*/
start_random_chat()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		wait 1;

		if ( randomInt( 100 ) < 1 )
		{
			if ( randomInt( 100 ) < 1 && isReallyAlive( self ) )
				self thread doQuickMessage();
		}
	}
}

/*
	Got a kill
*/
start_killed_watch()
{
	self endon( "disconnect" );

	self.bots_lastKS = 0;

	for ( ;; )
	{
		self waittill( "killed_enemy" );

		if ( self.bots_lastKS < self.pers["cur_kill_streak"] )
		{
			for ( i = self.bots_lastKS + 1; i <= self.pers["cur_kill_streak"]; i++ )
			{
				self thread bot_chat_streak( i );
			}
		}

		self.bots_lastKS = self.pers["cur_kill_streak"];

		self thread bot_chat_killed_watch( self.lastKilledPlayer );
	}
}

/*
	Starts things for the bot
*/
start_chat_watch()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );

	for ( ;; )
	{
		self waittill( "bot_event", msg, a, b, c, d, e, f, g );

		switch ( msg )
		{
			case "revive":
				self thread bot_chat_revive_watch( a, b, c, d, e, f, g );
				break;

			case "killcam":
				self thread bot_chat_killcam_watch( a, b, c, d, e, f, g );
				break;

			case "stuck":
				self thread bot_chat_stuck_watch( a, b, c, d, e, f, g );
				break;

			case "tube":
				self thread bot_chat_tube_watch( a, b, c, d, e, f, g );
				break;

			case "killstreak":
				self thread bot_chat_killstreak_watch( a, b, c, d, e, f, g );
				break;

			case "crate_cap":
				self thread bot_chat_crate_cap_watch( a, b, c, d, e, f, g );
				break;

			case "attack_vehicle":
				self thread bot_chat_attack_vehicle_watch( a, b, c, d, e, f, g );
				break;

			case "follow_threat":
				self thread bot_chat_follow_threat_watch( a, b, c, d, e, f, g );
				break;

			case "camp":
				self thread bot_chat_camp_watch( a, b, c, d, e, f, g );
				break;

			case "follow":
				self thread bot_chat_follow_watch( a, b, c, d, e, f, g );
				break;

			case "equ":
				self thread bot_chat_equ_watch( a, b, c, d, e, f, g );
				break;

			case "nade":
				self thread bot_chat_nade_watch( a, b, c, d, e, f, g );
				break;

			case "jav":
				self thread bot_chat_jav_watch( a, b, c, d, e, f, g );
				break;

			case "throwback":
				self thread bot_chat_throwback_watch( a, b, c, d, e, f, g );
				break;

			case "rage":
				self thread bot_chat_rage_watch( a, b, c, d, e, f, g );
				break;

			case "tbag":
				self thread bot_chat_tbag_watch( a, b, c, d, e, f, g );
				break;

			case "revenge":
				self thread bot_chat_revenge_watch( a, b, c, d, e, f, g );
				break;

			case "heard_target":
				self thread bot_chat_heard_target_watch( a, b, c, d, e, f, g );
				break;

			case "uav_target":
				self thread bot_chat_uav_target_watch( a, b, c, d, e, f, g );
				break;

			case "attack_equ":
				self thread bot_chat_attack_equ_watch( a, b, c, d, e, f, g );
				break;

			case "turret_attack":
				self thread bot_chat_turret_attack_watch( a, b, c, d, e, f, g );
				break;

			case "dom":
				self thread bot_chat_dom_watch( a, b, c, d, e, f, g );
				break;

			case "hq":
				self thread bot_chat_hq_watch( a, b, c, d, e, f, g );
				break;

			case "sab":
				self thread bot_chat_sab_watch( a, b, c, d, e, f, g );
				break;

			case "sd":
				self thread bot_chat_sd_watch( a, b, c, d, e, f, g );
				break;

			case "cap":
				self thread bot_chat_cap_watch( a, b, c, d, e, f, g );
				break;

			case "dem":
				self thread bot_chat_dem_watch( a, b, c, d, e, f, g );
				break;

			case "gtnw":
				self thread bot_chat_gtnw_watch( a, b, c, d, e, f, g );
				break;

			case "oneflag":
				self thread bot_chat_oneflag_watch( a, b, c, d, e, f, g );
				break;

			case "arena":
				self thread bot_chat_arena_watch( a, b, c, d, e, f, g );
				break;

			case "vip":
				self thread bot_chat_vip_watch( a, b, c, d, e, f, g );
				break;

			case "conf":
				self thread bot_chat_conf_watch( a, b, c, d, e, f, g );
				break;

			case "grnd":
				self thread bot_chat_grnd_watch( a, b, c, d, e, f, g );
				break;

			case "tdef":
				self thread bot_chat_tdef_watch( a, b, c, d, e, f, g );
				break;

			case "box_cap":
				self thread bot_chat_box_cap_watch( a, b, c, d, e, f, g );
				break;
		}
	}
}

/*
	start_startgame_watch
*/
start_startgame_watch()
{
	self endon( "disconnect" );
}

/*
	Does quick cod4 style message
*/
doQuickMessage()
{
	self endon( "disconnect" );
	self endon( "death" );
}

/*
	endgame_chat
*/
endgame_chat()
{
	self endon( "disconnect" );
}

/*
	bot_onnukecall_watch
*/
bot_onnukecall_watch()
{
	self endon( "disconnect" );
}

/*
	Got streak
*/
bot_chat_streak( streakCount )
{
	self endon( "disconnect" );
}

/*
	Say killed stuff
*/
bot_chat_killed_watch( victim )
{
	self endon( "disconnect" );

	if ( !isDefined( victim ) || !isDefined( victim.name ) )
		return;
}

/*
	Does death chat
*/
bot_chat_death_watch( killer, last_ks )
{
	self endon( "disconnect" );

	if ( !isDefined( killer ) || !isDefined( killer.name ) )
		return;
}

/*
	Revive
*/
bot_chat_revive_watch( state, revive, c, d, e, f, g )
{
	self endon( "disconnect" );

}

/*
	Killcam
*/
bot_chat_killcam_watch( state, b, c, d, e, f, g )
{
	self endon( "disconnect" );

}

/*
	Stuck
*/
bot_chat_stuck_watch( a, b, c, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	Tube
*/
bot_chat_tube_watch( state, tubeWp, tubeWeap, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_killstreak_watch( streakName, b, c, d, e, f, g )
*/
bot_chat_killstreak_watch( state, streakName, c, directionYaw, e, f, g )
{
	self endon( "disconnect" );	
}

/*
	self thread bot_chat_crate_cap_watch( a, b, c, d, e, f, g )
*/
bot_chat_crate_cap_watch( state, aircare, player, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_attack_vehicle_watch( a, b, c, d, e, f, g )
*/
bot_chat_attack_vehicle_watch( state, vehicle, rocketAmmo, d, e, f, g )
{
	self endon( "disconnect" );

}

/*
	bot_chat_follow_threat_watch( a, b, c, d, e, f, g )
*/
bot_chat_follow_threat_watch( state, threat, c, d, e, f, g )
{
	self endon( "disconnect" );

	switch ( state )
	{
		case "start":
			break;

		case "stop":
			break;
	}
}

/*
	bot_chat_camp_watch( a, b, c, d, e, f, g )
*/
bot_chat_camp_watch( state, wp, time, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_follow_watch( a, b, c, d, e, f, g )
*/
bot_chat_follow_watch( state, player, time, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_equ_watch
*/
bot_chat_equ_watch( state, wp, weap, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_nade_watch
*/
bot_chat_nade_watch( state, wp, weap, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_jav_watch
*/
bot_chat_jav_watch( state, wp, c, d, e, f, g )
{
	self endon( "disconnect" );

	switch ( state )
	{
		case "go":
			break;

		case "start":
			break;
	}
}

/*
	bot_chat_throwback_watch
*/
bot_chat_throwback_watch( state, nade, c, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_tbag_watch
*/
bot_chat_tbag_watch( state, who, c, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_rage_watch
*/
bot_chat_rage_watch( state, b, c, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_revenge_watch
*/
bot_chat_revenge_watch( state, loc, killer, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_heard_target_watch
*/
bot_chat_heard_target_watch( state, heard, c, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_uav_target_watch
*/
bot_chat_uav_target_watch( state, heard, c, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_turret_attack_watch
*/
bot_chat_turret_attack_watch( state, turret, c, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_attack_equ_watch
*/
bot_chat_attack_equ_watch( state, equ, c, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_dom_watch
*/
bot_chat_dom_watch( state, sub_state, flag, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_hq_watch
*/
bot_chat_hq_watch( state, sub_state, c, d, e, f, g )
{
	self endon( "disconnect" );
}

/*
	bot_chat_sab_watch
*/
bot_chat_sab_watch( state, sub_state, c, d, e, f, g )
{
	self endon( "disconnect" );

	switch ( sub_state )
	{
		case "bomb":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "defuser":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "planter":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "plant":
			switch ( state )
			{
				case "go":
					break;

				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "defuse":
			switch ( state )
			{
				case "go":
					break;

				case "start":
					break;

				case "stop":
					break;
			}

			break;
	}
}

/*
	bot_chat_sd_watch
*/
bot_chat_sd_watch( state, sub_state, obj, d, e, f, g )
{
	self endon( "disconnect" );

	switch ( sub_state )
	{
		case "bomb":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "defuser":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "planter":
			site = obj;

			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "plant":
			site = obj;

			switch ( state )
			{
				case "go":
					break;

				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "defuse":
			switch ( state )
			{
				case "go":
					break;

				case "start":
					break;

				case "stop":
					break;
			}

			break;
	}
}

/*
	bot_chat_cap_watch
*/
bot_chat_cap_watch( state, sub_state, obj, d, e, f, g )
{
	self endon( "disconnect" );

	switch ( sub_state )
	{
		case "their_flag":
			flag = obj;

			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "my_flag":
			flag = obj;

			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "cap":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;
	}
}

/*
	bot_chat_dem_watch
*/
bot_chat_dem_watch( state, sub_state, obj, d, e, f, g )
{
	self endon( "disconnect" );

	switch ( sub_state )
	{
		case "defuser":
			site = obj;

			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "planter":
			site = obj;

			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "plant":
			site = obj;

			switch ( state )
			{
				case "go":
					break;

				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "defuse":
			site = obj;

			switch ( state )
			{
				case "go":
					break;

				case "start":
					break;

				case "stop":
					break;
			}

			break;
	}
}

/*
	bot_chat_gtnw_watch
*/
bot_chat_gtnw_watch( state, sub_state, c, d, e, f, g )
{
	self endon( "disconnect" );

	switch ( sub_state )
	{
		case "cap":
			switch ( state )
			{
				case "go":
					break;

				case "start":
					break;

				case "stop":
					break;
			}

			break;
	}
}

/*
	bot_chat_oneflag_watch
*/
bot_chat_oneflag_watch( state, sub_state, c, d, e, f, g )
{
	self endon( "disconnect" );

	switch ( sub_state )
	{
		case "cap":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "their_flag":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "my_flag":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;
	}
}

/*
	bot_chat_arena_watch
*/
bot_chat_arena_watch( state, sub_state, c, d, e, f, g )
{
	self endon( "disconnect" );

	switch ( sub_state )
	{
		case "cap":
			switch ( state )
			{
				case "go":
					break;

				case "start":
					break;

				case "stop":
					break;
			}

			break;
	}
}

/*
	bot_chat_vip_watch
*/
bot_chat_vip_watch( state, sub_state, c, d, e, f, g )
{
	self endon( "disconnect" );

	switch ( sub_state )
	{
		case "cap":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;
	}
}

/*
	bot_chat_conf_watch
*/
bot_chat_conf_watch( state, sub_state, tag, d, e, f, g )
{
	self endon( "disconnect" );

	switch ( sub_state )
	{
		case "cap":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;
	}
}

/*
	bot_chat_grnd_watch
*/
bot_chat_grnd_watch( state, sub_state, target, d, e, f, g )
{
	self endon( "disconnect" );

	switch ( sub_state )
	{
		case "kill":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "cap":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;

		case "go_cap":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;
	}
}

/*
	bot_chat_tdef_watch
*/
bot_chat_tdef_watch( state, sub_state, c, d, e, f, g )
{
	self endon( "disconnect" );

	switch ( sub_state )
	{
		case "cap":
			switch ( state )
			{
				case "start":
					break;

				case "stop":
					break;
			}

			break;
	}
}

/*
	bot_chat_box_cap_watch
*/
bot_chat_box_cap_watch( state, box, c, d, e, f, g )
{
	self endon( "disconnect" );

	switch ( state )
	{
		case "go":
			break;

		case "start":
			break;

		case "stop":
			break;
	}
}
