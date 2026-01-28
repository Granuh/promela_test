mtype = { apple, pear, orange, banana };
mtype = { fruit, vegetables, cardboard };

inline add(a, b) {
    atomic { b = a + b};
    printf("Add value [%d]\n", b);
}

inline movl_rr(a, b) {
    atomic { b = a };
    printf("Move a move in b value [%d]\n", b);
}

proctype Fruits (byte id) {
    mtype n;
    byte a = 1, b = 2;
    if
    :: id == 1-> n = apple;
        printf("1 MSC: %e \n", n);
        n = fruit;
        printf("1 MSC: is %e\n", n)
        atomic { add(a, b) };
        atomic { movl_rr(a, b) };
    :: id == 2 -> n = pear;
        printf("2 MSC: %e \n", n);
        n = fruit;
        printf("2 MSC: is %e\n", n)
    :: id == 3 -> n = orange;
        printf("3 MSC: %e \n", n);
        n = vegetables;
        printf("3 MSC: is %e\n", n)
    :: id == 4 -> n = banana;
        printf("4 MSC: %e \n", n);
        n = cardboard;
        printf("4 MSC: is %e\n", n)
    fi
}

active [2] proctype you_run() {
    printf("\nMSC: my pid is: %d\n", _pid)
}

init {
    printf("\nMSC!\n")
    //run Fruits(1);
    //run Fruits(2);
    //run Fruits(3);
    //run Fruits(4);
}
