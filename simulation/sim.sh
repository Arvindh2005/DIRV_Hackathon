riscv64-linux-gnu-g++ -O3 -march=rv64gc -static -o fast_conv convolution.cpp
qemu-riscv64 ./fast_conv
