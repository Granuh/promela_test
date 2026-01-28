
chan ch = [2] of { byte };

active proctype Sender() {
    printf("Sender: Sending message 10\n");
    ch ! 10;
    printf("Sender: Message sent 10, not block\n");
    printf("Sender: Sending message 20\n");
    ch ! 20;
    printf("Sender: Message sent 10\n");
}

active proctype Receiver() {
    byte msg;
    printf("Receiver: Wait first message\n");
    ch ? msg;
    printf("Receiver: Received message %d\n", msg);
    printf("Receiver: Received wait second message %d\n", msg);
    ch ? msg;
    printf("Receiver: Received got message %d\n", msg);
}