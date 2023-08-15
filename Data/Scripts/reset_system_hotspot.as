#include "threatcheck.as"

float blackout_amount = 0.0;
float ko_time = -1.0;

string death_message = "You died! Press $attack$ to restart";
string knocked_out_message = "You knocked out! Wait until you rest";

void SetParameters() {
    params.AddString("death_message", death_message);
    params.AddString("knocked_out_message", knocked_out_message);
}

void Init() {
    level.ReceiveLevelEvents(hotspot.GetID());
}

void Dispose() {
    level.StopReceivingLevelEvents(hotspot.GetID());
}

void Update() {
    int player_id = GetPlayerCharacterID();
	
	blackout_amount = 0.0;
	if(player_id != -1 && ObjectExists(player_id)){
		MovementObject@ char = ReadCharacter(player_id);
        int knocked_out_state = char.GetIntVar("knocked_out");

		if(knocked_out_state != _awake){
			if(ko_time == -1.0f){
				ko_time = the_time;
			}
			if(ko_time < the_time - 1.0){
                // OLD: if(GetInputPressed(0, "attack") || ko_time < the_time - 5.0){
				if(GetInputPressed(0, "attack")){
                    switch(knocked_out_state) {
                        case 1:
                            // Fuck it. It can be cheaty for NPC. 
                            // Player can rest with `unconscious_system_hotspot`
                            //char.ReceiveScriptMessage("restore_health");
                            break;
                        case 2:
                            level.SendMessage("reset");
                            break;
                    }			               
				}
			}
            blackout_amount = 0.2 + 0.6 * (1.0 - pow(0.5, (the_time - ko_time)));

            bool use_keyboard = (max(last_mouse_event_time, last_keyboard_event_time) > last_controller_event_time);

            string respawn_message = "death_message";
            if (knocked_out_state == _unconscious)
                respawn_message = "knocked_out_message";

            string respawn = params.GetString(respawn_message);
            int index = respawn.findFirst("$attack$");
            while(index != -1) {
                respawn.erase(index, 8);
                respawn.insert(index, GetStringDescriptionForBinding(use_keyboard?"key":"gamepad_0", "attack"));

                index = respawn.findFirst("$attack$", index + 8);
            }
            level.SendMessage("screen_message "+""+respawn);
		} else {
			ko_time = -1.0f;
		}
	} else {
        ko_time = -1.0f;
    }
}

void ReceiveMessage(string msg) {
    TokenIterator token_iter;
    token_iter.Init();

    if(!token_iter.FindNextToken(msg)) {
        return;
    }

    string token = token_iter.GetToken(msg);
    //DebugText("receive_token_dbg", "ReceiveToken: " + token, 15.0f);
    //DebugText("receive_message_dbg", "ReceiveMessage: " + msg, 15.0f);
}

void PreDraw(float curr_game_time) {
    camera.SetTint(camera.GetTint() * (1.0 - blackout_amount));
}

void DrawEditor(){
    if(EditorModeActive()){
        Object@ obj = ReadObjectFromID(hotspot.GetID());
        DebugDrawBillboard("Data/UI/spawner/thumbs/Hotspot/reset_icon.png",
                           obj.GetTranslation(),
                           obj.GetScale()[1]*2.0,
                           vec4(vec3(0.5), 1.0),
                           _delete_on_draw);
    }
}