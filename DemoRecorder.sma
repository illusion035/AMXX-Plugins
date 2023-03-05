// Plugin Created by illusion
// Credits: Huehue
// Needed Version: AMXX 1.10

#include <amxmodx>
#include <geoip>

#define PLUGIN_NAME "ILLUSION PLUGINS: Demo Recorder"
#define PLUGIN_VERSION "1.0"
#define PLUGIN_AUTHOR "illusion"

new g_pC_DemoRecorder, g_pC_DemoName[MAX_NAME_LENGTH], Float:g_pC_StartDemoAfter, g_pC_ChatPrefix[32]

new g_szAuthID[MAX_PLAYERS + 1][MAX_AUTHID_LENGTH]

public plugin_init()
{
    register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR)

    bind_pcvar_num(create_cvar("demo_recorder", "1", FCVAR_NONE, "Enable/Disable the auto demo recorder"), g_pC_DemoRecorder)
    bind_pcvar_string(create_cvar("demo_recorder_chat_prefix", "^1[^3Danger^1-^4CS^1]", FCVAR_NONE, "Prefix appears in chat"), g_pC_ChatPrefix, charsmax(g_pC_ChatPrefix))
    bind_pcvar_string(create_cvar("demo_recorder_name", "DangerCS_HNS", FCVAR_NONE, "Demo Name"), g_pC_DemoName, charsmax(g_pC_DemoName))
    bind_pcvar_float(create_cvar("demo_recorder_start_after", "10.0", FCVAR_NONE, "After how many seconds demo will start"), g_pC_StartDemoAfter)

    AutoExecConfig(true, "Illusion_DemoRecorder")
}

public client_authorized(id, const authid[])
{
    if (g_pC_DemoRecorder)
    {
        copy(g_szAuthID[id], charsmax(g_szAuthID[]), authid)
        set_task(g_pC_StartDemoAfter, "RecordingDemo", id)
    }
}

public RecordingDemo(id)
{
    if(!is_user_connected(id))
        return

    client_cmd(id, "stop")

    static szTime[64], szCountry[64], szPlayerIP[MAX_IP_LENGTH]

    get_time("%H:%M:%S ^1&^4 %d/%m/%Y", szTime, charsmax(szTime))

    get_user_ip(id, szPlayerIP, charsmax(szPlayerIP), .without_port = 1)
    geoip_country_ex(szPlayerIP, szCountry, charsmax(szCountry))

    client_cmd(id, "record %s", g_pC_DemoName)

    client_print_color(id, print_team_default, "%s ^1[^3NickName^1: ^4%n^1] ^1[^3SteamID^1: ^4%s^1]", g_pC_ChatPrefix, id, g_szAuthID[id])
    client_print_color(id, print_team_default, "%s ^1[^3Recording Demo^1: ^4%s^1] ^1[^3Time/Date^1: ^4%s^1]", g_pC_ChatPrefix, g_pC_DemoName, szTime)
    client_print_color(id, print_team_default, "%s ^1[^3Current Map^1: ^4%s^1] ^1[^3Country^1: ^4%s^1]", g_pC_ChatPrefix, MapName, szCountry)
}
