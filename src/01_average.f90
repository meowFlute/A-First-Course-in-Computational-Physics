!-------------------------------------------------------------------------------
! M. Scott Christensen (meowFlute)
!
! average.f90 computes the average of two numbers typed in at the keyboard and
! write the answer
!
! originally written: Monday 10 November 2025
!       last revised: Monday 10 November 2025

read(*,*) first
read(*,*) second

average = ( first + second ) / 2

write(*,*) average

end
