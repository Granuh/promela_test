bool flag = false;

active proctype Conditional() {
    if 
    :: flag == false -> flag = true;
        printf("Flag was false, no set to true\n");
    :: else -> printf("Flag was already true\n");
    fi
}