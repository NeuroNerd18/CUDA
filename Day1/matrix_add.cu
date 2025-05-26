#include <iostream>
#include <cuda_runtime.h>


__global__ void matrix_add(const float *A , const float *B ,  float *C , int rows , int cols) {
    int row = blockDim.y * blockIdx.y + threadIdx.y;
    int col = blockDim.x * blockIdx.x + threadIdx.x;
    if(row < rows && col < cols){
        int i = row * cols + col;
        C[i] = A[i] + B[i];
    }

}

int main() {
    const int rows = 2;
    const int cols = 3;
    const int size = rows * cols * sizeof(float);

    float A[rows * cols] = {1,2,3,4,5,6};
    float B[rows * cols] = {1,2,3,4,5,6};
    float C[rows * cols];

    float *d_a , *d_b , *d_c;
    cudaMalloc(&d_a , size);
    cudaMalloc(&d_b , size);
    cudaMalloc(&d_c , size);

    cudaMemcpy(d_a , A, size , cudaMemcpyHostToDevice);
    cudaMemcpy(d_b , B, size , cudaMemcpyHostToDevice);
    
    dim3 threadsperblock(16,16);
    dim3 blockspergrid((cols + 15)/16 , (rows +15)/16);

    matrix_add<<<blockspergrid , threadsperblock>>>(d_a , d_b , d_c, rows , cols);

    cudaMemcpy(C , d_c , size , cudaMemcpyDeviceToHost);

    for(int i = 0 ; i < rows ; i++){
        for(int j = 0 ; j < cols ; j++){
            std::cout<<C[i*cols + j]<<std::endl;
        }
        std::cout<<std::endl;
    } 
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
}
