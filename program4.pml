
chan ch = [0] of { byte };

active proctype Sender() {
    printf("Sender: Sending message 42\n");
    ch ! 42;
    printf("Sender: Message sent\n");
}

active proctype Receiver() {
    byte msg;
    printf("Receiver: Wait mesage\n");
    ch ? msg;
    printf("Receiver: Received message\n");
}

