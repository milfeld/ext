! @@name:	teams.2f
! @@type:	F-free
! @@compilable:	yes
! @@linkable:	no
! @@expect:	success
function dotprod(B,C,N, block_size, num_teams, block_threads) result(sum)
implicit none
    real    :: B(N), C(N), sum
    integer :: N, block_size, num_teams, block_threads, i, i0
    sum = 0.0e0
    !$omp target map(to: B, C) map(tofrom: sum)
    !$omp teams num_teams(num_teams) thread_limit(block_threads) &
    !$omp&  reduction(+:sum)
    !$omp distribute
       do i0=1,N, block_size
          !$omp parallel do reduction(+:sum)
          do i = i0, min(i0+block_size,N)
             sum = sum + B(i) * C(i)
          end do
       end do
    !$omp end teams
    !$omp end target
end function

!  This source has been updated with the
 ! map(tofrom: sum) clause on the target
 ! directive for correct execution within
 ! 4.5 implementations.
 !
 ! In 4.5 the sum scalar variable default
 ! behavior is firstprivate, in pre-4.5
 ! the default behavior is map(tofrom: sum).
!
