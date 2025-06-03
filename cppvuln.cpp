#include <iostream>
#include <unistd.h>
#include <cstring>

void vulnerabile() {
    const char* msg = "Overflow riuscito!\n";
    write(1, msg, strlen(msg));
}

void my_function() {
    char buffer[16]; // buffer piccolo

    // vulnerabilità: legge fino a 64byte senza controllare
    read(0, buffer, 64);

    // normale ritorno: se il buffer overflow ha sovrascritto il return address,
    // potrei saltare altrove (es: vulnerabile)
}

int main() {
    my_function();
    return 0;
}
