byte counter = 0;

active proctype Counter() {
    do
    :: counter < 10 -> counter++;
        printf("Counter: %d\n", counter);
    :: counter == 10 -> break;
    od
    printf("Counter reached 10\n");
}