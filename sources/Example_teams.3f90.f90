! @@name:	teams.3f
! @@type:	F-free
! @@compilable:	yes
! @@linkable:	no
! @@expect:	success
function dotprod(B,C,N) result(sum)
   real    :: B(N), C(N), sum
   integer :: N, i
   sum = 0.0e0
   !$omp target teams map(to: B, C) map(tofrom: sum) reduction(+:sum)
   !$omp distribute parallel do reduction(+:sum)
      do i = 1,N
         sum = sum + B(i) * C(i)
      end do
   !$omp end teams
   !$omp end target
end function

! Note:  The variable sum is now mapped with tofrom, for correct 
! execution with 4.5 (and pre-4.5) compliant compilers. See Devices Intro.
