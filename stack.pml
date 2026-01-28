#define STACK_SIZE 10

int stack[STACK_SIZE];
int top_index = -1;

inline stack_push(value) {
    if
    :: top_index < STACK_SIZE - 1 ->
        printf("stack_push Before top_index: %d\n", top_index);
        top_index++;
        printf("stack_push Also top_index: %d\n", top_index);
        stack[top_index] = value;
        printf("stack_push stack[top_index]: %d\n", stack[top_index]);
    :: else ->
        skip;
    fi
}

inline stack_pop(ref_value) {
    if
    :: top_index >= 0 ->
        printf("stack_pop Before top_index: %d\n", top_index);
        ref_value = stack[top_index];
        printf("stack_pop ref_value: %d\n", ref_value);
        top_index--;
        printf("stack_pop Also top_index: %d\n", top_index);
    :: else ->
        skip;
    fi
}

inline stack_peek(ref_value) {
    if
    :: top_index >= 0 -> 
        ref_value = stack[top_index];
    :: else ->
        skip;
    fi
}

inline stack_is_empty() {
    if
    :: top_index == -1 ->
        skip;
    :: else -> 
        skip;
    fi
}

inline stack_is_full() {
    if 
    :: top_index == STACK_SIZE - 1 ->
        skip;
    :: else ->
        skip;
    fi
}

init {
    int val;
    byte i = 0;

    if
    :: top_index == -1 -> skip;
    :: else -> assert(false);
    fi

    do
    :: i <= 5 ->
        stack_push(i);
        printf("Push: %d\n", i);
        i++;
    :: else ->
        break;
    od

    i = 0;
    do
    :: i <= 5 ->
        stack_pop(val);
        printf("Popped: %d\n", val);
        i++;
    :: else ->
        break;
    od

    if
    :: top_index == -1 -> skip;
    :: else -> assert(false);
    fi
}

ltl f { [] top_index >= 4}