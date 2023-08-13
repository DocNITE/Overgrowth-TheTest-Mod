#include "music_load.as"

MusicLoad ml("Data/Mods/the_test_campaign/Data/Music/thetest.xml");

void Init(string level_name) {
   DebugText("start_level", "Initialize level: " + level_name + ".xml", 30.0f);
   // Play background
   PlaySong("horror");
};