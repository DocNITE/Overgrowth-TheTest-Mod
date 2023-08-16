#include "threatcheck.as"

class HealthBar {
    float value;
    float max_value;

    vec2 position;
    vec2 size;

    //float cut_width_value = 0.24691358;

    TextureAssetRef hp_icon;
    TextureAssetRef hp_progress;
    TextureAssetRef hp_background;

    HealthBar() {}

    HealthBar(float val, float max) {
        value = val;
        max_value = max;
    }

    void DrawGUI() {
        if (value <= 0.0f)
            value = 0.0f;

        if(!hp_icon.IsValid()) {
            hp_icon = LoadTexture("Data/Images/hp_icon.png");
        }
        if(!hp_progress.IsValid()) {
            hp_progress = LoadTexture("Data/Images/hp_progress.png");
        }
        if(!hp_background.IsValid()) {
            hp_background = LoadTexture("Data/Images/hp_background.png");
        }

        // draw background
        //ImGui_PushStyleColor(ImGuiCol_TitleBg, vec4(vec3(color.x*0.5f, color.y*0.5f, color.z*0.5f), 1.0f));
        //ImDrawList_AddRectFilled(vec2(position.x, position.y), vec2(position.x+size.x, position.y+size.y), ImGui_GetColorU32(ImGuiCol_TitleBg), 0.0, ImDrawCornerFlags_TopLeft | ImDrawCornerFlags_BotRight);
        
        ImGui_PushStyleColor(ImGuiCol_TitleBg, vec4(1.0f, 1.0f, 1.0f, 1.0f));
        ImDrawList_AddImage(hp_background, position, position + size, vec2(0,0), vec2(1, 1));
        ImDrawList_AddImage(hp_progress, position, position + vec2(size.x*value, size.y), vec2(0,0), vec2(value, 1));
        ImDrawList_AddImage(hp_icon, position, position + size, vec2(0,0), vec2(1, 1)); 
        // draw content
        //ImGui_PushStyleColor(ImGuiCol_TitleBg, vec4(color, 1.0f));
        //ImDrawList_AddRectFilled(vec2(position.x, position.y), vec2(position.x+(size.x*value), position.y+size.y), ImGui_GetColorU32(ImGuiCol_TitleBg), 1.0, ImDrawCornerFlags_TopLeft | ImDrawCornerFlags_BotRight);
    }
}

enum HudOrientation {
    BOTTOM_RIGHT,
    BOTTOM_LEFT,
    TOP_LEFT
}

class HealthHUD {
    int char_id;
    HudOrientation orientation;
    float padding = 10.0f;
    float safe_padding = 20.0f;
    float transparency = 0.0f;
    vec2 size = vec2(405.0f / 1.3, 256.0f / 1.3);
    int zindex = 2;

    HealthBar health_bar = HealthBar(1.0f, 1.0f);

    void Init() {}

    void DrawGUI() {
        MovementObject@ char = ReadCharacter(char_id);

        float health_value = char.GetFloatVar("temp_health"); // or blood_health

        // Change value if character was dead
        if (char.GetIntVar("knocked_out") == _dead) 
            health_value = 0.0f; // OR: char.GetFloatVar("blood_health");

        float xpos = 0;
        float ypos = 0;
        // Position hud on screen
        if (orientation == BOTTOM_RIGHT) {
             xpos = GetScreenWidth() - size.x - safe_padding;
             ypos = GetScreenHeight() - (size.y/2) - safe_padding;
        } else if (orientation == TOP_LEFT) {
             xpos = safe_padding*2;
             ypos = safe_padding*1.5;
        }

        // draw background
        ImGui_Begin("", ImGuiWindowFlags_NoTitleBar|ImGuiWindowFlags_NoResize|ImGuiWindowFlags_NoMove);
        ImGui_PushStyleColor(ImGuiCol_WindowBg, vec4(0.0f, 0.0f, 0.0f, transparency));
        ImGui_SetWindowPos(vec2(xpos-padding, ypos-padding));
        ImGui_SetWindowSize(vec2(size.x+padding, (size.y/2)+padding));
        
        health_bar.position = vec2(xpos-(padding/2), (ypos - (size.y/4))-(padding/2));
        health_bar.size = size;
        health_bar.value = health_value;
        health_bar.DrawGUI();

        ImGui_End();
    }
}

HealthHUD health_hud;

vec3 color_bar_health(0.8f, 0.2f, 0.2f);
vec3 color_bar_stamina(0.2f, 0.8f, 0.2f);
vec3 color_bar_dead(0.0f, 0.0f, 1.0f);

void Init() {
    health_hud.Init();
}

void Draw() {
    int player_id = GetPlayerCharacterID();

    if(player_id != -1 && ObjectExists(player_id)){
        health_hud.char_id = player_id;
        health_hud.orientation = TOP_LEFT;
        health_hud.transparency = 0.0f;
        health_hud.DrawGUI();
    }
}

void DrawEditor(){
    if(EditorModeActive()){
        Object@ obj = ReadObjectFromID(hotspot.GetID());
        DebugDrawBillboard("Data/UI/spawner/hd-thumbs/Hotspot/start_icon.png",
                           obj.GetTranslation(),
                           obj.GetScale()[1]*2.0,
                           vec4(vec3(0.5), 1.0),
                           _delete_on_draw);

    }
}