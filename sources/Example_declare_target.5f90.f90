! @@name:	declare_target.5f
! @@type:	F-free
! @@compilable:	yes
! @@linkable:	no
! @@expect:	success
module my_global_array
!$omp declare target (N,Q)
integer, parameter :: N=10000, M=1024
real               :: Q(N,N)
contains
function P(k,i)
!$omp declare simd uniform(i) linear(k) notinbranch
!$omp declare target
real               :: P
integer,intent(in) :: k,i
   P=(Q(k,i) * Q(i,k))
end function
end module

function accum() result(tmp)
use my_global_array
real    :: tmp, tmp1
integer :: i
   tmp = 0.0e0
   !$omp target map(tofrom: tmp)
   !$omp parallel do private(tmp1) reduction(+:tmp)
   do i=1,N
      tmp1 = 0.0e0
      !$omp simd reduction(+:tmp1)
      do k = 1,M
         tmp1 = tmp1 + P(k,i)
      end do
      tmp = tmp + tmp1
   end do
   !$omp end target
end function

!  This source has been updated with the
 ! map(tofrom: tmp) clause on the target
 ! directive for correct execution within
 ! 4.5 implementations.
 !
 ! In 4.5 the tmp scalar variable default
 ! behavior is firstprivate, in pre-4.5
 ! the default behavior is map(tofrom: tmp).
!

