bool flag;

active proctype Nondet() {
    if
    :: flag = false;
    fi
    if
    :: !flag -> printf("Flag was false\n");
    fi
}

ltl formula1 { [](!flag) }