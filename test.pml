#define N 5
byte m = 0

proctype test_process(byte id) {
    printf("Id: %d\n", id);
    byte left;
    byte right;

    id = _pid;
    left = id;
    right = (id + 1) % N;
    m = right;
    assert(m == 0 | m == 1 | m == 2 | m == 3 | m == 4);
    printf("m: %d\n", m);
}

init {
    byte i = 0;
    do
    :: (i < 5) ->
        run test_process(i);
        i++;
    :: else -> break;
    od
}

ltl f { [] (m == 0 | m == 1 | m == 2 | m == 3 | m == 4) }