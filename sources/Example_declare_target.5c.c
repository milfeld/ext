/*
* @@name:	declare_target.5c
* @@type:	C
* @@compilable:	yes
* @@linkable:	no
* @@expect:	success
*/
#define N 10000
#define M 1024
#pragma omp declare target
float Q[N][N];
#pragma omp declare simd uniform(i) linear(k) notinbranch
float P(const int i, const int k)
{
  return Q[i][k] * Q[k][i];
}
#pragma omp end declare target

float accum(void)
{
  float tmp = 0.0;
  int i, k;
#pragma omp target map(tofrom: tmp)
#pragma omp parallel for reduction(+:tmp)
  for (i=0; i < N; i++) {
    float tmp1 = 0.0;
#pragma omp simd reduction(+:tmp1)
    for (k=0; k < M; k++) {
      tmp1 += P(i,k);
    }
    tmp += tmp1;
  }
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
