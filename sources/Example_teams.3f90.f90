! @@name:	teams.3f
! @@type:	F-free
! @@compilable:	yes
! @@linkable:	no
! @@expect:	success
function dotprod(B,C,N) result(sum)
   real    :: B(N), C(N), sum
   integer :: N, i
   sum = 0.0e0
   !$omp target teams map(to: B, C) map(tofrom: sum)
   !$omp distribute parallel do reduction(+:sum)
      do i = 1,N
         sum = sum + B(i) * C(i)
      end do
   !$omp end teams
   !$omp end target
end function

!  This source has been update with the
 ! map(tofrom: sum) clause on the target
 ! directive for correct execution within
 ! 4.5 implementations.
 !
 ! In 4.5 the sum scalar variable default
 ! behavior is firstprivate, in pre-4.5
 ! the default behavior is map(tofrom: sum).
!
