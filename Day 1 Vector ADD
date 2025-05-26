#include <iostream>
#include <cuda_runtime.h>


__global__ void vec_add(const float *A , const float *B ,  float *C , int N) {
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    if( i < N){
        C[i] = B[i] + A[i];
    }

    
}

int main() {
    const int N = 10;
    float A[N] , B[N] , C[N];

    for(int i = 0 ; i < N ;i++){
        A[i] = i * 1.0f;
        B[i] = (N-i) * 1.0f;
    }
    float *d_a , *d_b ,*d_c;
    cudaMalloc(&d_a , N * sizeof(float));
    cudaMalloc(&d_b , N * sizeof(float));
    cudaMalloc(&d_c , N * sizeof(float));

    cudaMemcpy(d_a ,A , N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b ,B , N * sizeof(float) , cudaMemcpyHostToDevice);

    int blocksize = 256;
    int gridsize = (N + blocksize - 1)/blocksize;

    vec_add<<<gridsize , blocksize>>>(d_a , d_b , d_c , N);

    cudaMemcpy(C , d_c , N * sizeof(float) , cudaMemcpyDeviceToHost);

    for (int i = 0 ; i < N ;i++){
        std::cout<<C[i]<<std::endl;
    }
    std::cout<<std::endl;
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);


}
