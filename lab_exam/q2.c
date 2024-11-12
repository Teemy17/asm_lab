#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

struct thread_data {
    int thread_id;
    int sleep_duration;
    char task_name;
};

// function executed by each thread
void* task(void* arg) {
    struct thread_data *data = (struct thread_data*)arg;
    int thread_id = data->thread_id;
    // Your code here
    int sleep_duration = data->sleep_duration;
    char task_name = data->task_name;

    for (int i = 1; i <= 5; i++) {
        printf("Thread %d: Task %c - iteration %d\n", thread_id, task_name, i);
void* task(void* arg) {
    struct thread_data *data = (struct thread_data*)arg;
    int thread_id = data->thread_id;
    int sleep_duration = data->sleep_duration;
    char task_name = data->task_name;

    for (int i = 0; i<=5; i++) {
        printf("Thread %d: Task %c - Iteration %d\n", thread_id, task_name, i);
        sleep(sleep_duration);
    }

    pthread_exit(NULL);

}

int main() {
    pthread_t thread1, thread2, thread3;
    struct thread_data data1, data2, data3;
    //Thread 1 data
    data1.thread_id = 1;
    data1.sleep_duration = 1;
    data1.task_name = 'A';
    //Your code here
    data1.thread_id = 1;
    data1.sleep_duration = 1;
    data1.task_name = 'A';

    data2.thread_id = 2;
    data2.sleep_duration = 2;
    data2.task_name = 'B';

    data3.thread_id = 3;
    data3.sleep_duration = 3;
    data3.task_name = 'C';

    pthread_create(&thread1, NULL, task, (void*)&data1);    
    pthread_create(&thread1, NULL, task, (void*)&data1);
    pthread_create(&thread2, NULL, task, (void*)&data2);
    pthread_create(&thread3, NULL, task, (void*)&data3);

    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    pthread_join(thread3, NULL);
    
    //Print completion message
    printf("All threads have completed their tasks!\n");
    return 0;
}

    printf("All thread have completed their tasks\n");
    return 0;
}
