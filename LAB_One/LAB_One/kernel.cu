
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <ctime>
#include <stdio.h>
#include <cstdlib>
#include <iostream>

#include <clocale>

//������ ��� ��������� ������
#define cudaCheckError() {                                          \
 cudaError_t e=cudaGetLastError();                                 \
 if(e!=cudaSuccess) {                                              \
   printf("Cuda failure %s:%d: '%s'\n",__FILE__,__LINE__,cudaGetErrorString(e));           \
   exit(0); \
 }                                                                 \
}
//���������

const int countThreads = 64; //��� �� �����
const int countBlocks = 64;

cudaError_t addWithCuda(long  long int *c, const long  long int *a, const long  long int *b, long  long int size,unsigned int countBlock,unsigned int countThread);

static void RunVectorSumm(long  long int sizeVector, int countBlock, int countThread);

//������� ������������ �� GPU
__global__ void addKernel(long  long int *c, const  long  long int *a, const  long  long int *b)
{
    int i = threadIdx.x;
    c[i] = a[i] + b[i];
}

int main()
{
	int x;
	setlocale(LC_ALL,"Russian");
	srand(time(NULL));
	//���� �� ����������� ������� �� 10 �� 24
	for (long  long int i = 1<<10; i < 10e7; i<<=1)
	{
		std::cout << "�����������: " << i << " ������: " << countBlocks << " �����: " << countThreads;
		RunVectorSumm(i, countBlocks, countThreads);
	}
		
	
    return 0;
}

void RunVectorSumm(long  long int sizeVector, int countBlock, int countThread)
{
	//������������� �������
	long  long int arraySize = sizeVector;
	long  long int *a  = new long  long int[arraySize];
	long  long int *b = new long  long int[arraySize];
	long  long int *c = new long  long int[arraySize];

	for (int i = 0;i < arraySize;i++)
	{
		a[i] = rand();
		b[i] = rand();
	}
	
	cudaError_t cudaStatus = addWithCuda(c, a, b, arraySize,countBlock,countThread);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "addWithCuda failed!");
		return;
	}
	//printf(" %d" + c[0]);
	
	/*printf("{");
	for (int i = 0; i < arraySize; i++)
	{
		printf(" %d" + c[i]);
	}
	printf("}");
	printf("\n");*/

	//������ ������� ���������� ��������� ��������� ����� ������� ��� ���������� ������ ������������ �������������� � ������������.
	cudaStatus = cudaDeviceReset();
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaDeviceReset failed!");
		return;
	}
}
// Helper function for using CUDA to add vectors in parallel.
cudaError_t addWithCuda(long  long int *c, const long  long int *a, const long  long int *b, long  long int size, unsigned int countBlock, unsigned int countThread)
{
	long  long int *dev_a = 0;
	long  long int *dev_b = 0;
	long  long int *dev_c = 0;
    cudaError_t cudaStatus;
	cudaEvent_t start, stop;
	float time;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start, 0);

	
    // Choose which GPU to run on, change this on a multi-GPU system.
    cudaStatus = cudaSetDevice(0);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
        goto Error;
    }

    // Allocate GPU buffers for three vectors (two input, one output)    .
    cudaStatus = cudaMalloc((void**)&dev_c, size * sizeof(long  long int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_a, size * sizeof(long  long int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_b, size * sizeof(long  long int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    // Copy input vectors from host memory to GPU buffers.
    cudaStatus = cudaMemcpy(dev_a, a, size * sizeof(long  long int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

	cudaCheckError(cudaMemcpy(dev_b, b, size * sizeof(long  long int), cudaMemcpyHostToDevice));
    
	
	//������ �������� Event
	
    
	//��������� ���������� �� GPU countBlock - ���������� ������(������) , countThread - ���������� �����
    addKernel<<<countBlock, countThread >>>(dev_c, dev_a, dev_b);
	cudaEventRecord(stop, 0);
    // Check for any errors launching the kernel
    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
        goto Error;
    }
    

	cudaCheckError(cudaDeviceSynchronize());
 
	cudaCheckError(cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(long  long int), cudaMemcpyDeviceToHost));
   
	
	//��������� �������� Event
	

	//����� ���������� ����������
	/*
	printf("{");
	for (int i = 0; i < size; i++)
	{
		printf(" %d", a[i]);

	}
	printf("} + ");
	printf("{");
	for (int i = 0; i < size; i++)
	{

		printf(" %d", b[i]);

	}
	printf("} = ");
	printf("{");
	for (int k = 0; k < size; k++)
	{
		printf(" %d", c[k]);
	}
	printf("}");*/
	
Error:
    cudaFree(dev_c);
    cudaFree(dev_a);
    cudaFree(dev_b);
    
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&time, start, stop);
	std::cout << std::endl;
	printf("����� ����������: %f ms\n", time);
    return cudaStatus;
}
