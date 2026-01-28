#define N 5
#define FREE 0
#define TAKEN 1

byte forks[N];
bool philosofs_eating[N];

proctype philosof(byte id) {
    byte left, right;
    
    byte idp = id;

    left = idp;
    right = (idp + 1) % N;

    do
    :: true -> 
    // Take forks
    printf("Philosof %d trying to get forks %d and %d\n", id, left, right);
        atomic {
            if
            :: forks[left] == FREE && forks[right] == FREE ->
                forks[left] = TAKEN;
                forks[right] = TAKEN;
            fi
        };
    printf("Philosof %d got forks %d and [%d] %d and [%d]\n", id, left, forks[left], right, forks[right]);
        if
        :: forks[left] == TAKEN && forks[right] == TAKEN ->
            printf("Philosof %d is eating — left=%d, right=%d, forks[%d]=%d, forks[%d]=%d\n", id, left, right, left, forks[left], right, forks[right]);
            philosofs_eating[id] = true;
        
            forks[left] = FREE;
            forks[right] = FREE;
            philosofs_eating[id] = false;
            printf("Philosof %d finish eating\n", id);
        fi
    od
}

init {
    run philosof(0);
    run philosof(1);
    run philosof(2);
    run philosof(3);
    run philosof(4);
}

ltl no_deadlock { []<> (philosofs_eating[0] | philosofs_eating[1] | philosofs_eating[2] | philosofs_eating[3] | philosofs_eating[4]) }
