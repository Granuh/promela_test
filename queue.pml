#define QUEUE_SIZE 10

int queue[QUEUE_SIZE];
int start = 0;
int end = -1;
int count = 0;

inline queue_enqueue(value) {
    if
    :: count < QUEUE_SIZE ->
        //printf("ENQUEUE\n");
        //printf("count before: %d\n", count);
        end = (end + 1) % QUEUE_SIZE;
        //printf("end: %d\n", end);
        queue[end] = value;
        //printf("queue[end]: %d\n", queue[end]);
        count++;
        //printf("count also: %d\n", count);
    :: else -> 
        skip;
    fi
}

inline queue_dequeue(ref_value) {
    if
    :: count > 0 ->
        //printf("DEQUEUE\n");
        //printf("count before: %d\n", count);
        ref_value = queue[start];
        //printf("ref_value: %d\n", ref_value);
        start = (start + 1) % QUEUE_SIZE;
        //printf("start: %d\n", start);
        count--;
        //printf("count also: %d\n", count);
    :: else ->
        skip;
    fi
}

inline queue_is_empty() {
    if
    :: count == 0 ->
        skip;
    :: else ->
        skip;
    fi
}

inline queue_is_full() {
    if
    :: count == QUEUE_SIZE ->
        skip;
    :: else ->
        skip;
    fi
}

init {
    int val;
    byte i = 0;

    if
    :: count == 0 ->
        skip;
    :: else -> assert(false);
    fi

    do
    :: i <= 5 ->
        queue_enqueue(i);
        printf("Enqueue: %d\n", i);
        i++;
    :: else ->
        break;
    od

    i = 0;

    do
    :: i <= 5 ->
        queue_dequeue(val);
        printf("Dequeue: %d\n", val);
        i++;
    :: else ->
        break;
    od

    if
    :: count == 0 ->
        skip;
    :: else -> assert(false);
    fi
}