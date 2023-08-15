#include "threatcheck.as"

// TODO: Remade for AHGUI

TextureAssetRef testTexture1;
TextureAssetRef testTexture2;
string inputTextForClipboard;

void DrawEditord() {
    ImGui_Begin("TEST DRAW STUFF", ImGuiWindowFlags_NoTitleBar|ImGuiWindowFlags_NoResize|ImGuiWindowFlags_NoMove);
    ImGui_PushStyleColor(ImGuiCol_WindowBg, vec4(1.0f, 1.0f, 1.0f, 0.0f));
    ImDrawList_AddText(vec2(300.0, 300.0), ImGui_GetColorU32(1.0, 0.0, 1.0, 1.0), "THIS IS A TEST!!!!");
    ImDrawList_AddRectFilled(vec2(300.0, 300.0), vec2(500.0, 500.0), ImGui_GetColorU32(ImGuiCol_TitleBg), 12.0, ImDrawCornerFlags_TopLeft | ImDrawCornerFlags_BotRight);
    ImGui_End();
}


class BarControl {
    float value;
    float max_value;

    string texture = "Data/Textures/diffuse.tga";
    vec3 color = vec3(1.0f, 1.0f, 1.0f);
    vec3 position;
    vec3 size;
    int zindex = 3;

    BarControl() {}

    BarControl(float val, float max) {
        value = val;
        max_value = max;
    }

    void DrawGUI() {
        if (value <= 0.0f)
            value = 0.0f;

        // draw background
        ImGui_PushStyleColor(ImGuiCol_TitleBg, vec4(vec3(color.x*0.5f, color.y*0.5f, color.z*0.5f), 1.0f));
        ImDrawList_AddRectFilled(vec2(position.x, position.y), vec2(position.x+size.x, position.y+size.y), ImGui_GetColorU32(ImGuiCol_TitleBg), 0.0, ImDrawCornerFlags_TopLeft | ImDrawCornerFlags_BotRight);

        // draw content
        ImGui_PushStyleColor(ImGuiCol_TitleBg, vec4(color, 1.0f));
        ImDrawList_AddRectFilled(vec2(position.x, position.y), vec2(position.x+(size.x*value), position.y+size.y), ImGui_GetColorU32(ImGuiCol_TitleBg), 1.0, ImDrawCornerFlags_TopLeft | ImDrawCornerFlags_BotRight);
    }
}

enum HudOrientation {
    BOTTOM_RIGHT,
    BOTTOM_LEFT
}

class HeroHUD {
    int char_id;
    HudOrientation orientation;
    string texture = "Data/Textures/diffuse.tga";
    vec3 size;
    float padding = 10.0f;
    float safe_padding = 20.0f;
    float height_padding = 5.0f;
    float transparency = 0.75f;
    int zindex = 2;

    BarControl health_bar = BarControl(1.0f, 1.0f);

    void Init() {}

    void DrawGUI() {
        MovementObject@ char = ReadCharacter(char_id);

        float health_value = char.GetFloatVar("temp_health"); // or blood_health

        // Change color if character was dead
        if (char.GetIntVar("knocked_out") == _dead) {
            health_bar.color = color_bar_dead;
            // I there is not need check blood level
            health_value = 0.0f; // char.GetFloatVar("blood_health");
        }
        else {
            health_bar.color = color_bar_health;
        }

        // Position hud on screen
        if (orientation == BOTTOM_RIGHT) {
            float xpos = GetScreenWidth() - size.x - safe_padding;
            float ypos = GetScreenHeight() - size.y - safe_padding;

            // draw background
            ImGui_Begin("", ImGuiWindowFlags_NoTitleBar|ImGuiWindowFlags_NoResize|ImGuiWindowFlags_NoMove);
            ImGui_PushStyleColor(ImGuiCol_WindowBg, vec4(0.0f, 0.0f, 0.0f, transparency));
            ImGui_SetWindowPos(vec2(xpos, ypos));
            ImGui_SetWindowSize(vec2(size.x, size.y));
            //ImDrawList_AddText(vec2(300.0, 300.0), ImGui_GetColorU32(1.0, 0.0, 1.0, 1.0), "THIS IS A TEST!!!!");
            //ImDrawList_AddRectFilled(vec2(300.0, 300.0), vec2(500.0, 500.0), ImGui_GetColorU32(ImGuiCol_TitleBg), 12.0, ImDrawCornerFlags_TopLeft | ImDrawCornerFlags_BotRight);

            health_bar.position = vec3(xpos + padding, ypos + padding, 0.0f);
            health_bar.size = vec3(180.0f, 20.0f, 0.0f);
            health_bar.value = health_value;
            health_bar.zindex = zindex + 1;
            health_bar.DrawGUI();

            ImGui_End();
        }
    }
}

HeroHUD hero_hud;

vec3 color_bar_health(0.8f, 0.2f, 0.2f);
vec3 color_bar_stamina(0.2f, 0.8f, 0.2f);
vec3 color_bar_dead(0.0f, 0.0f, 1.0f);

void Init() {
    float width = 200;
    float height = 40;

    hero_hud.Init();
    hero_hud.orientation = BOTTOM_RIGHT;
    hero_hud.size = vec3(200.0f, 40.0f, 0.0f);
}

void Draw() {
    int player_id = GetPlayerCharacterID();

    if(player_id != -1 && ObjectExists(player_id)){
        hero_hud.char_id = player_id;
        hero_hud.DrawGUI();
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