#define MIN 0
#define MAX 1000
#define MAXLEN 100

int arr[MAXLEN];

bool correct = true;

proctype bubble_sort() {
    int i, j, A_len;
    
    select(A_len: 2 .. MAXLEN);
    printf("Generating an array with len = %d\n", A_len);

    j = 0;
    do
    :: j < A_len ->
        int temp;
        select(temp: MIN .. MAX);
        arr[j] = temp;
        printf("(%d): %d\n", j, arr[j]);
        j++;
    :: else -> break;
    od

    i = 0;
    do
    :: i < A_len - 1 ->
        j = 0;
        do
        :: j < A_len - i - 1 ->
            if
            :: arr[j] > arr[j + 1] ->
                temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            :: else -> skip;
            fi
            j++;
        :: else -> break;
        od
        i++;
    :: else -> break;
    od            

    printf("Result: \n");
    j = 0;
    do
    :: j < A_len ->
        printf("(%d): %d\n", j, arr[j]);
        j++;
    :: else -> break;
    od

    int idx_to_check;
    select(idx_to_check: 0 .. A_len - 2);
    correct = (arr[idx_to_check] <= arr[idx_to_check + 1]);

    //printf("Verification: Arr[%d] = %d <= A[%d] = %d\n", idx_to_check, arr[idx_to_check], idx_to_check + 1, arr[idx_to_check + 1]);


    if
    :: correct -> printf("YES\n");
    :: else -> printf("NO\n");
    fi
}

init {
    run bubble_sort();
}

ltl correct { [] correct }