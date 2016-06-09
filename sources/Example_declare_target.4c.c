/*
* @@name:	declare_target.4c
* @@type:	C
* @@compilable:	yes
* @@linkable:	no
* @@expect:	success
*/
#define N 10000
#pragma omp declare target
float Q[N][N];
float Pfun(const int i, const int k)
{ return Q[i][k] * Q[k][i]; }
#pragma omp end declare target
float accum(int k)
{
    float tmp = 0.0;
    #pragma omp target update to(Q)
    #pragma omp target map(tofrom: tmp)
    #pragma omp parallel for reduction(+:tmp)
    for(int i=0; i < N; i++)
        tmp += Pfun(i,k);
    return tmp;
}
/* This source has been updated with the
   map(tofrom: tmp) clause on the target 
   directive for correct execution within
   4.5 implementations.

   In 4.5 the tmp scalar variable default
   behavior is firstprivate, in pre-4.5
   the default behavior is map(tofrom: tmp).
*/

