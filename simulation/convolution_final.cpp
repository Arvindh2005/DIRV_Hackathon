#include <iostream>
#include <vector>

on
void conv2d(const std::vector<std::vector<int>>& image, const std::vector<std::vector<int>>& kernel, std::vector<std::vector<int>>& output) {
    int image_size = image.size();       
    int kernel_size = kernel.size();    
    int output_size = image_size - kernel_size + 1; 

    
    output = std::vector<std::vector<int>>(output_size, std::vector<int>(output_size, 0));

   
    for (int i = 0; i < output_size; i++) {
        for (int j = 0; j < output_size; j++) {
            
            for (int ki = 0; ki < kernel_size; ki++) {
                for (int kj = 0; kj < kernel_size; kj++) {
                    output[i][j] += image[i + ki][j + kj] * kernel[ki][kj];
                }
            }
        }
    }
}

int main() {
    
    std::vector<std::vector<int>> image = {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9}
    };

    
    std::vector<std::vector<int>> kernel = {
        {1, 1},
        {1, 1}
    };

    
    std::vector<std::vector<int>> output;

    
    conv2d(image, kernel, output);

   
    std::cout << "Output of 2D Convolution:\n";
    for (const auto& row : output) {
        for (int val : row) {
            std::cout << val << " ";
        }
        std::cout << "\n";
    }

    return 0;
}
