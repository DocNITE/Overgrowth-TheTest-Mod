void SetParameters() {
    params.AddString("music", "");
    params.AddString("music_filename", "");
}

void Init() {
    string music_xml = params.GetString("music");
    string m_filename = params.GetString("music_filename");
    if(music_xml != ""){
        AddMusic("Data/Mods/the_test_campaign/Data/Music/" + music_xml + ".xml");
        if (m_filename != "") {
            Log(info, "Music '" + m_filename + "' has been played");
            PlaySong(m_filename);
        }
    }
    DebugText("check_hotspot", "Music System played: " + music_xml + ".xml - " + m_filename, 15.0f);

    level.ReceiveLevelEvents(hotspot.GetID());
    //testSave();
};

void Dispose() {
    level.StopReceivingLevelEvents(hotspot.GetID());
}

void ReceiveMessage(string msg) {
    TokenIterator token_iter;
    token_iter.Init();

    if(!token_iter.FindNextToken(msg)) {
        return;
    }

    string token = token_iter.GetToken(msg);

    DebugText("receive_message_dbg", "ReceiveMessage: " + token, 15.0f);
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