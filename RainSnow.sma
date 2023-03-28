#include <amxmodx>
#include <engine>

#define PLUGIN_NAME "ILLUSION PLUGINS: Rain/Snow"
#define PLUGIN_VERSION "1.0"
#define PLUGIN_AUTHOR "illusion"

new g_iRainSnow

public plugin_init()
{
	register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR)

	bind_pcvar_num(create_cvar("weather_type", "1", FCVAR_NONE, "1 - Rain / 0 - Snow"), g_iRainSnow)
	
	AutoExecConfig(true, "ILLUSION_RainSnow")
}

public plugin_precache()
{
	if(g_iRainSnow)
	{
		create_entity("env_rain")
	}
	else {
		create_entity("env_snow")
	}
}
