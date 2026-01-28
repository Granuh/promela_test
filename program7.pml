int shared_var = 0;

active proctype Inc() {
    int temp = shared_var;
    temp = temp + 1;
    shared_var = temp;
    printf("Inc finish, shared_var=%d\n", shared_var);
}

active proctype Dec() {
    atomic {
        int temp = shared_var;
        temp = temp - 1;
        shared_var = temp;
    }
    printf("Dec finish\n", shared_var);
}

ltl formula1 { <> (shared_var == 1) }