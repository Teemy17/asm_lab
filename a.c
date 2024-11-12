#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

#define NUM_THREADS 5

pthread_mutex_t file_mutex;

void* write_to_file(void* arg) {
    int thread_id = *(int*)arg;
    char filename[20];
    sprintf(filename, "thread%d.txt", thread_id);
    FILE* file = fopen(filename, "w");
    if (!file) {
        perror("fopen");
        pthread_exit(NULL);
    }
    pthread_mutex_lock(&file_mutex);
    fprintf(file, "Hello from thread %d\n", thread_id);
    pthread_mutex_unlock(&file_mutex);
    fclose(file);
    pthread_exit(NULL);
}

int main() {
    pthread_t threads[NUM_THREADS];
    int thread_ids[NUM_THREADS];

    pthread_mutex_init(&file_mutex, NULL);
    for (int i = 0; i < NUM_THREADS; i++) {
        thread_ids[i] = i;
        if (pthread_create(&threads[i], NULL, write_to_file, &thread_ids[i])) {
            perror("pthread_create");
            return 1;
        }
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        if (pthread_join(threads[i], NULL)) {
            perror("pthread_join");
            return 1;
        }
    }
    pthread_mutex_destroy(&file_mutex);
    return 0;
}