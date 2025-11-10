!-------------------------------------------------------------------------------
! M. Scott Christensen (meowFlute)
!
! average.f90 computes the average of two numbers typed in at the keyboard and
! write the answer
!
! originally written: Monday 10 November 2025
!       last revised: Monday 10 November 2025

! this was so Fortran-77... we want something more portable
! DOUBLE PRECISION first, second, average

! this iso_fortan_env module does the trick
use iso_fortran_env     ! this makes it so we can use more modern iso types
implicit none           ! this makes it so implicit declarations don't work

! it declares numeric constants for the number of bytes for each type
real(kind=real64) temp, total, average
integer(kind=int8) num_entries, i

write(*,' (A)', advance='no') 'How many numbers would you like to enter? Enter &
    &choice here (less than 255): '
read(*,*) num_entries
write(*,*) ! newline character

total = 0.d0

DO i = 1, num_entries
    write(*,' (A, I0, A)', advance='no') 'input number ', i, ': '
    read(*,*) temp
    total = total + temp
END DO

average = total / dble(num_entries)

write(*,*) ! newline character
write(*,*) 'The average of the above numbers is:', average

end
