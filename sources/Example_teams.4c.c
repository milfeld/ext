/*
* @@name:	teams.4c
* @@type:	C
* @@compilable:	yes
* @@linkable:	no
* @@expect:	success
*/
#define N 1024*1024
float dotprod(float B[], float C[])
{
    float sum = 0.0;
    int i;
    #pragma omp target map(to: B[0:N], C[0:N]) map(tofrom: sum)
    #pragma omp teams num_teams(8) thread_limit(16) reduction(+:sum)
    #pragma omp distribute parallel for reduction(+:sum) \
                dist_schedule(static, 1024) schedule(static, 64)
    for (i=0; i<N; i++)
        sum += B[i] * C[i];
    return sum;
}

/* This source has been updated with the
   map(tofrom: sum) clause on the target
   directive for correct execution within
   4.5 implementations.

   In 4.5 the sum scalar variable default
   behavior is firstprivate, in pre-4.5
   the default behavior is map(tofrom: sum).
*/
