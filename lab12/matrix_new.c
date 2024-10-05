#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <time.h>

#define SIZE 2000 // Matrix size, can be adjusted as needed
#define BLOCK_SIZE 32 // Block size for cache blocking optimization

// Declare the matrices
int (*matrixA)[SIZE];
int (*matrixB)[SIZE];
int (*result)[SIZE];

// Structure to store data for each thread
typedef struct {
    int thread_id;
    int start_row;
    int end_row;
} thread_data_t;

// Block matrix multiplication function
void multiply_block(int start_row, int end_row, int block_size) {
    for (int i = start_row; i < end_row; i += block_size) {
        for (int j = 0; j < SIZE; j += block_size) {
            for (int k = 0; k < SIZE; k += block_size) {
                // Compute a sub-block of the result matrix
                for (int ii = i; ii < i + block_size && ii < end_row; ii++) {
                    for (int jj = j; jj < j + block_size && jj < SIZE; jj++) {
                        int sum = result[ii][jj];
                        for (int kk = k; kk < k + block_size && kk < SIZE; kk++) {
                            sum += matrixA[ii][kk] * matrixB[kk][jj];
                        }
                        result[ii][jj] = sum;
                    }
                }
            }
        }
    }
}

// Thread function for matrix multiplication
void *multiply(void *arg) {
    thread_data_t *data = (thread_data_t *)arg;
    int start_row = data->start_row;
    int end_row = data->end_row;

    // Perform cache-blocked matrix multiplication for assigned rows
    multiply_block(start_row, end_row, BLOCK_SIZE);

    pthread_exit(NULL);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <number_of_threads>\n", argv[0]);
        return 1;
    }
    int num_threads = atoi(argv[1]);
    if (num_threads <= 0 || num_threads > SIZE) {
        printf("Invalid number of threads. Please choose between 1 and %d.\n", SIZE);
        return 1;
    }

    // Dynamically allocate memory for matrices
    matrixA = malloc(SIZE * sizeof(*matrixA));
    matrixB = malloc(SIZE * sizeof(*matrixB));
    result = malloc(SIZE * sizeof(*result));
    if (!matrixA || !matrixB || !result) {
        printf("Memory allocation failed\n");
        return 1;
    }

    pthread_t threads[num_threads];
    thread_data_t thread_data[num_threads];

    // Initialize matrices A and B with random values
    srand(time(NULL));
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            matrixA[i][j] = rand() % 10;
            matrixB[i][j] = rand() % 10;
            result[i][j] = 0; // Initialize result matrix to 0
        }
    }

    int rows_per_thread = SIZE / num_threads;
    int remaining_rows = SIZE % num_threads;

    clock_t start = clock();

    // Create threads
    for (int i = 0; i < num_threads; i++) {
        thread_data[i].thread_id = i;
        thread_data[i].start_row = i * rows_per_thread + (i < remaining_rows ? i : remaining_rows);
        thread_data[i].end_row = (i + 1) * rows_per_thread + (i < remaining_rows ? i + 1 : remaining_rows);
        pthread_create(&threads[i], NULL, multiply, (void *)&thread_data[i]);
    }

    // Join threads
    for (int i = 0; i < num_threads; i++) {
        pthread_join(threads[i], NULL);
    }

    clock_t end = clock();
    double time_taken = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Execution time with %d threads and cache blocking: %.2f seconds\n", num_threads, time_taken);

    // Free allocated memory
    free(matrixA);
    free(matrixB);
    free(result);

    return 0;
}

