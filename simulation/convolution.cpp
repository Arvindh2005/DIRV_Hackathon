#include <iostream>
#include <cstdint>

#define N 3  // Input matrix size
#define K 2  // Kernel size

int input[N][N] = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};

int kernel[K][K] = {
    {1, 1},
    {1, 1}
};

int output[N - K + 1][N - K + 1];

//to read cycle count
uint64_t read_mcycle() {
    uint64_t cycles;
    asm volatile ("rdcycle %0" : "=r" (cycles));
    return cycles;
}

//Convolution
void convolve() {
    int *outPtr = &output[0][0]; 
    for (int i = 0; i < N - K + 1; i++) {
        for (int j = 0; j < N - K + 1; j++) {
            int *inPtr = &input[i][j];  
            int sum = 0;

            
            sum += inPtr[0] * kernel[0][0] + inPtr[1] * kernel[0][1]; 
            sum += inPtr[N] * kernel[1][0] + inPtr[N + 1] * kernel[1][1]; // here we are unrolling it 

            *outPtr++ = sum;  
        }
    }
}


void printMatrix(int matrix[N - K + 1][N - K + 1]) {
    for (int i = 0; i < N - K + 1; i++) {
        for (int j = 0; j < N - K + 1; j++) {
            std::cout << matrix[i][j] << " ";
        }
        std::cout << std::endl;
    }
}

int main() {
    uint64_t start_cycles = read_mcycle();  

    convolve();  

    uint64_t end_cycles = read_mcycle();  

    std::cout << "Convolution Output Matrix:" << std::endl;
    printMatrix(output);

    std::cout << "Cycles Taken: " << (end_cycles - start_cycles) << std::endl;

    return 0;
}

