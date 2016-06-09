/*
* @@name:	teams.3c
* @@type:	C
* @@compilable:	yes
* @@linkable:	no
* @@expect:	success
*/
float dotprod(float B[], float C[], int N)
{
   float sum = 0;
   int i;
   #pragma omp target teams map(to: B[0:N], C[0:N]) \
                            map(tofrom: sum) reduction(+:sum)
   #pragma omp distribute parallel for reduction(+:sum)
   for (i=0; i<N; i++)
      sum += B[i] * C[i];
   return sum;
}

/* This source has been update with the
   map(tofrom: sum) clause on the target
   directive for correct execution within
   4.5 implementations.

   In 4.5 the sum scalar variable default
   behavior is firstprivate, in pre-4.5
   the default behavior is map(tofrom: sum).
*/
