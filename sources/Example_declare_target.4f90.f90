! @@name:	declare_target.4f
! @@type:	F-free
! @@compilable:	yes
! @@linkable:	no
! @@expect:	success
module my_global_array
!$omp declare target (N,Q)
integer, parameter :: N=10
real               :: Q(N,N)
contains
function Pfun(i,k)
!$omp declare target
real               :: Pfun
integer,intent(in) :: i,k
   Pfun=(Q(i,k) * Q(k,i))
end function
end module

function accum(k) result(tmp)
use my_global_array
real    :: tmp
integer :: i, k
   tmp = 0.0e0
   !$omp target map(tofrom: tmp)
   !$omp parallel do reduction(+:tmp)
   do i=1,N
      tmp = tmp + Pfun(k,i)
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
