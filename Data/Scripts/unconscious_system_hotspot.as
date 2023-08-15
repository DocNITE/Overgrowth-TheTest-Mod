class TimerInfo {
    MovementObject@ owner;
    float end_time;
    float current_time;

    bool done = false;

    void Update() {
        current_time = the_time;

        if (current_time > end_time)
            done = true;
    }

    void setOwner(MovementObject@ obj) {
        @owner = obj;
    }
}

array<TimerInfo@> timers;

void SetParameters() {
    params.AddFloat("unconscious_time", 30.0f);
}

void Init() {
}

void Update() {
    int num_chars = GetNumCharacters();
    for(int i=0; i<num_chars; ++i){
        MovementObject@ char = ReadCharacter(i);
        int knocked_out_state = char.GetIntVar("knocked_out");
        // if our character not died and no has timer
        if (knocked_out_state == _unconscious && HasTimer(char) == false)
            AddTimer(char);
    }

    // do timers
    int num_timers = timers.length();
    for(int i=0; i < num_timers; ++i) {

        TimerInfo@ timer = timers[i];
        timer.Update();

        if (timer.done == true) {
            if (timer.owner.GetIntVar("knocked_out") != _dead)
                timer.owner.ReceiveScriptMessage("restore_health");

            timers.removeAt(i);
        }
    }
}

void AddTimer(MovementObject@ char_id) {
    TimerInfo timer;
    timer.current_time = the_time;
    timer.end_time = the_time + params.GetFloat("unconscious_time");
    timer.setOwner(char_id);
    
    timers.insertLast(timer);
}

bool HasTimer(MovementObject@ char_id) {
    int num_timers = timers.length();
    for(int i=0; i<num_timers; ++i) {
        if (timers[i].owner.GetID() == char_id.GetID())
            return true;
    }
    return false;
}

void DrawEditor(){
    if(EditorModeActive()){
        Object@ obj = ReadObjectFromID(hotspot.GetID());
        DebugDrawBillboard("Data/UI/spawner/thumbs/Hotspot/load_icon.png",
                           obj.GetTranslation(),
                           obj.GetScale()[1]*2.0,
                           vec4(vec3(0.5), 1.0),
                           _delete_on_draw);
        return;
    }
}