#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>

int shared_counter = 0;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void* increment(void* arg) {
    for (int i = 0; i < 5; i++) {
        pthread_mutex_lock(&mutex);

        shared_counter++;
        printf("thread %ld: Counter = %d\n", (long)arg, shared_counter);

        pthread_mutex_unlock(&mutex);
    }
    return NULL;
}

int main() {
    pthread_t thread1, thread2;

    pthread_create(&thread1, NULL, increment, (void*)1);
    pthread_create(&thread2, NULL, increment, (void*)2);

    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    pthread_mutex_destroy(&mutex);

    printf("Final counter value: %d\n", shared_counter);

    return 0;
}
