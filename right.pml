mtype = {ping, pong, trash};
chan pingpong = [0] of {mtype};

bool bug = false;
bool fin = false;
bool weSend = false;
bool weReceive = false;

active proctype ping_proc() {
    mtype msg;
    printf("ping started, sending ping!\n");
    atomic {
        pingpong ! ping;
        weSend = true;
    }
    printf("waiting for pong...\n");
    pingpong ? msg;
    if
        ::msg == pong -> {
            printf("pingpong done!\n");
        }
        ::else -> {
            printf("pingpong bug!\n");
            bug = true;
        }  
    fi
    fin = true;  
}

active proctype pong_proc() {
   mtype msg;
   printf("pong started, waiting for ping...\n");
   pingpong ? msg;
   weReceive = true;
   if
        ::msg == ping -> {
            printf("We got ping msg, sending pong\n");
            pingpong ! pong;
        }
        ::else -> {
            bug = true;
            printf("Bug!");
        }
    fi
    printf("pong done!\n");
}

ltl formula1 {([] !bug)}
ltl formula2 {([]<>fin)}
//ltl formula3 {([] !bug) && ([]<>fin)}
//ltl formula4 {[] (weSend -> <> weReceive)  }
//[] = всегда
//<> = когда-то
