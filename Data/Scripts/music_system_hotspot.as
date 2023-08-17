#include "threatcheck.as"

enum AmbientState {
    NORMAL,
    THREAT,
    COMBAT,
    SAD
}

bool is_music = false;
string playing_music = "";

void SetParameters() {
    params.AddString("music", "");
    params.AddIntCheckbox("can_threat", true);
    params.AddIntCheckbox("can_combat", true);
    params.AddIntCheckbox("can_sad", true);
}

void Init() {
    SetupMusic();
    level.ReceiveLevelEvents(hotspot.GetID());
};

void Dispose() {
    level.StopReceivingLevelEvents(hotspot.GetID());
}

void Update() {
    if (!is_music)
        return;

    int player_id = GetPlayerCharacterID();
    if(player_id != -1 && ReadCharacter(player_id).GetIntVar("knocked_out") == _dead){
        SetMusic(SAD);
        return;
    }
    int threats_remaining = ThreatsRemaining();
    if(threats_remaining == 0){
        SetMusic(NORMAL);
        return;
    }
    if(player_id != -1 && ReadCharacter(player_id).QueryIntFunction("int CombatSong()") == 1){
        SetMusic(COMBAT);
        return;
    }
    SetMusic(THREAT);
}

void ReceiveMessage(string msg) {
    TokenIterator token_iter;
    token_iter.Init();

    if(!token_iter.FindNextToken(msg)) {
        return;
    }

    string token = token_iter.GetToken(msg);
}

void DrawEditor(){
    if(EditorModeActive()){
        Object@ obj = ReadObjectFromID(hotspot.GetID());
        DebugDrawBillboard("Data/UI/spawner/thumbs/Sounds/speaker_icon.png",
                           obj.GetTranslation(),
                           obj.GetScale()[1]*2.0,
                           vec4(vec3(0.5), 1.0),
                           _delete_on_draw);
    }

    //DrawEditor2();
}

void SetupMusic() {
    string music_xml = params.GetString("music");
    if(music_xml != "" && music_xml != "null"){
        AddMusic("Data/Music/" + music_xml + ".xml");
        is_music = true;
    } else {
        is_music = false;
    }
    DebugText("check_hotspot", "Music System played: " + music_xml + ".xml", 15.0f);
}

void SetMusic(AmbientState state) {
    bool can_threat = params.GetInt("can_threat") != 0;
    bool can_combat = params.GetInt("can_combat") != 0;
    bool can_sad = params.GetInt("can_sad") != 0;

    string music_prefix = params.GetString("music") + "_";
    string play_music;

    if (playing_music == "")
        playing_music = music_prefix + "normal";

    if (state == NORMAL) {
        play_music = music_prefix + "normal";
    } else if(state == THREAT) {
        if (can_threat)
            play_music = music_prefix + "threat";
        else 
            play_music == playing_music;
    } else if(state == COMBAT) {
        if (can_combat)
            play_music = music_prefix + "combat";
        else 
            play_music = playing_music;
    } else if(state == SAD) {
        if (can_sad)
            play_music = music_prefix + "sad";
        else 
            play_music = playing_music;
    }

    PlaySong(play_music);
    playing_music = play_music;
}

/*void testSave() {
    if (GetSaveFile().GetValue("LOL_KEY") == "2")
    {
        DebugText("check_hotspotd", "GAY STATION LOL", 666.0f);
    } else 
    {
        GetSaveFile().SetValue("LOL_KEY", "2");
        DebugText("check_hotspotd", "NORMAL PEOPLE STATION LOL", 666.0f);
    }
}

SavedLevel@ GetSaveFile() {
    return save_file.GetSave("thetest","global","lol");
}*/

TextureAssetRef testTexture1;
TextureAssetRef testTexture2;
string inputTextForClipboard;

void DrawEditor2() {
    if(!testTexture1.IsValid()) {
        testTexture1 = LoadTexture("Data/Textures/ya.tga");
    }

    if(!testTexture2.IsValid()) {
        testTexture2 = LoadTexture("Data/Textures/water_foam.jpg");
    }

    ImGui_Begin("TEST DRAW STUFF");

        ImGui_SetWindowFontScale(1.0f);

    ImGui_Text("THIS IS A выEST");

    // --- Clipboard stuff. Unrelated to low level drawing, just happened to do it at the same time
    ImGui_Text(ImGui_GetClipboardText());
    ImGui_InputText("", inputTextForClipboard, 64);

    // --- Primitive drawing
    ImDrawList_AddImage(
        testTexture1,
        vec2(400.0, 300.0), vec2(500.0, 400.0), vec2(0.0), vec2(1.0),
        ImGui_GetColorU32(1.0, 0.0, 0.0, 1.0));
    ImDrawList_AddImageQuad(
        testTexture1,
        vec2(500.0, 500.0), vec2(600.0, 400.0), vec2(700.0, 500.0), vec2(600.0, 600.0),
        vec2(0, 0), vec2(1, 0), vec2(1, 1), vec2(0, 1),
        ImGui_GetColorU32(0.0, 1.0, 0.0, 1.0));
    ImDrawList_AddImageRounded(
        testTexture2,
        vec2(500.0, 300.0), vec2(600.0, 400.0), vec2(0.0), vec2(1.0),
        ImGui_GetColorU32(0.0, 1.0, 1.0, 1.0),
        32.0,
        ImDrawCornerFlags_TopLeft | ImDrawCornerFlags_BotRight);
    ImGui_End();
}
