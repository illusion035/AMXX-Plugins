// Plugin Created by illusion
// Credits: Huehue

#include <amxmodx>
#include <geoip>

#define PLUGIN_NAME "ILLUSION PLUGINS: Demo Recorder"
#define PLUGIN_VERSION "1.0"
#define PLUGIN_AUTHOR "illusion"

#define ContactMessage "Tuk suobshtenieto za contact."

new g_pC_DemoRecorder, g_pC_DemoName[MAX_NAME_LENGTH], Float: g_pC_StartDemoAfter, g_pC_ChatPrefix[32]

public plugin_init() {
    register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR)

    bind_pcvar_num(create_cvar("demo_recorder", "1", FCVAR_NONE, "Enable/Disable the auto demo recorder"), g_pC_DemoRecorder)
    bind_pcvar_string(create_cvar("demo_recorder_chat_prefix", "^1[^3Your^4Prefix^1]", FCVAR_NONE, "Prefix appears in chat"), g_pC_ChatPrefix, charsmax(g_pC_ChatPrefix))
    bind_pcvar_string(create_cvar("demo_recorder_name", "DemoRecorder_Name", FCVAR_NONE, "Demo Name"), g_pC_DemoName, charsmax(g_pC_DemoName))
    bind_pcvar_float(create_cvar("demo_recorder_start_after", "5.0", FCVAR_NONE, "After how many seconds demo will start"), g_pC_StartDemoAfter)

    AutoExecConfig(true, "Illusion_DemoRecorder")
}

public client_putinserver(id)
{
    if (g_pC_DemoRecorder) {
        set_task(g_pC_StartDemoAfter, "RecordingDemo", id)
    }
}

public RecordingDemo(id) {
    if (!is_user_connected(id))
        return

    client_cmd(id, "stop")

    static szTime[64], szCity[64], szCountry[64], szPlayerIP[MAX_IP_LENGTH], MapName[64], UserName[MAX_NAME_LENGTH], szAuthID[MAX_AUTHID_LENGTH]

    get_time("%H:%M:%S ^1&^4 %d/%m/%Y", szTime, charsmax(szTime))

    get_user_ip(id, szPlayerIP, charsmax(szPlayerIP), .without_port = 1)
    geoip_country_ex(szPlayerIP, szCountry, charsmax(szCountry))
    geoip_city(szPlayerIP, szCity, charsmax(szCity))

    get_mapname(MapName, charsmax(MapName))
    get_user_name(id, UserName, charsmax(UserName))

    get_user_authid(id, szAuthID, charsmax(szAuthID))

    client_cmd(id, "record %s", g_pC_DemoName)

    client_print_color(id, print_team_default, "%s ^1[^3NickName^1: ^4%s^1] ^1[^3SteamID^1: ^4%s^1]", g_pC_ChatPrefix, UserName, szAuthID)
    client_print_color(id, print_team_default, "%s ^1[^3Recording Demo^1: ^4%s^1] ^1[^3Time/Date^1: ^4%s^1]", g_pC_ChatPrefix, g_pC_DemoName, szTime)
    client_print_color(id, print_team_default, "%s ^1[^3Current Map^1: ^4%s^1] ^1[^3City^1: ^4%s^1] ^1[^3Country^1: ^4%s^1]", g_pC_ChatPrefix, MapName, szCity, szCountry)
    client_print_color(id, print_team_default, "%s ^1%s", g_pC_ChatPrefix, ContactMessage)
}
