void DrawEditor(){
    if(EditorModeActive()){
        Object@ obj = ReadObjectFromID(hotspot.GetID());
        DebugDrawBillboard("Data/UI/spawner/hd-thumbs/Hotspot/start_icon.png",
                           obj.GetTranslation(),
                           obj.GetScale()[1]*2.0,
                           vec4(vec3(0.5), 1.0),
                           _delete_on_draw);
        return;
    }
    /*
     MovementObject@ player_char = ReadCharacter(player_id);
                    int num = GetNumCharacters();
                    for(int j=0; j<num; ++j){
                        MovementObject@ char = ReadCharacter(j);
                        if(!player_char.OnSameTeam(char)){
                            int knocked_out = char.GetIntVar("knocked_out");
                            if(knocked_out == 1 && char.GetFloatVar("blood_health") <= 0.0f){
                                knocked_out = 2;
                            }
                            AHGUI::Image img;
                            switch(knocked_out){
                            case 0:    
                                img = AHGUI::Image("Textures/ui/challenge_mode/ok.png");
                                break;
                            case 1:    
                                img = AHGUI::Image("Textures/ui/challenge_mode/ko.png");
                                break;
                            case 2:    
                                img = AHGUI::Image("Textures/ui/challenge_mode/dead.png");
                                break;
                            }
                            img.scaleToSizeY(70);
                            kills.addElement(img,DDLeft);
                        }
                    }
    */
}