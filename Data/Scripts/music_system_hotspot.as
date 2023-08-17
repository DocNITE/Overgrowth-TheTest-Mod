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