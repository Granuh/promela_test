#define msgtype 1 

byte State = 1;
int Dick = 0;

chan cname = [0] of { byte, byte };

proctype A() {
    printf("MSC: proc A\n");
    cname ! msgtype(1);
    cname ! msgtype(2);
    cname ! msgtype(3);
    cname ! msgtype(4);
}

proctype B() {
    printf("MSC: proc B\n");
    byte state;
    int count = 0;
    do
    ::
         count < 4 -> 
            cname ? msgtype(state);
            printf("MSC: proc B. State is %d\n", state);
            count++;
        :: else break;
    od
}

/*active proctype C() {
    printf("MSC: proc C started. State is [%d]\n", State);
    byte tmp;
    (State == 1) -> 
        tmp = State;
        tmp = tmp + 1;
        State = tmp;
    printf("MSC: proc C closed. State is [%d]\n", State);
}

active proctype D() {
    printf("MSC: proc D started. State is [%d]\n", State);
    byte tmp;
    (State == 1) -> 
        tmp = State;
        tmp = tmp - 1;
        State = tmp;
    printf("MSC: proc D closed. State is [%d]\n", State);
}*/

inline sqrt_int(n) {
    int x = n;
    int prev_x = 0;
    do
    :: (x * x > n || x * x < n) && (x != prev_x) ->
        prev_x = x;
        x = (x + n / x) / 2;
    :: else -> break;
    od
    Dick = x;
}

proctype Dickrimenant(int b, a, c) {
    printf("MSC: Dickremenant!\n");
    int d = 0, x1, x2;
    d = b * b - 4 * a * c;
    printf("MSC: Dickremenant is [%d]\n", d);
    if
    :: (d == 0) ->
        printf("MSC: One root.\n");
        x1 = - b / (2 * a);
        printf("MSC: x is = [%d]\n", x1);
    :: (d > 0) ->
        printf("MSC: Two root.\n");
        sqrt_int(d);
        x1 = (- b + Dick) / (2 * a);
        x2 = (- b - Dick) / (2 * a);
        printf("MSC: x1 is = [%d]\n", x1);
        printf("MSC: x2 is = [%d]\n", x2);
    :: (d < 0) ->
        printf("MSC: Not root.\n");
    fi
}

init {
    //atomic {
    //    run A();
    //   run B();
    //}
    run Dickrimenant(-4, 2, -6);

}
