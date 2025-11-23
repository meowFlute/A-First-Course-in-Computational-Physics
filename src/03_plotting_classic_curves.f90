!-------------------------------------------------------------------------------
! M. Scott Christensen (meowFlute)
!
! Plotting the classic curves of Table 1.1 from the book:
!   - Bifolium              (x**2 + y**2)**2 = a*(x**2)*y
!                           r = a*sin(theta)*(cos(theta)**2)
!   
!   - Cissoid of Diocles    (y**2)*(a-x) = x**3
!                           r = a*sin(theta)*tan(theta)
!
! originally written: Saturday 22 November 2025
!       last revised: Saturday 22 November 2025

program plot_classic_curves
    use, intrinsic :: iso_fortran_env
    use fplot_core
    implicit none
    
    ! Local Variables
    integer(int32), parameter :: npts = 1000
    real(real64), parameter :: pi = 2.0d0 * acos(0.0d0)
    real(real64) :: r(npts), theta(npts), a
    type(plot_polar) :: plt
    type(plot_data_2d) :: pd

    ! Bifolium Curve (polar coordinates)
    theta = linspace(-2.0d0*pi, 2.0d0*pi, npts)
    a = 10.0d0
    r = a * sin(theta) * (cos(theta)**2)

    call pd%define_data(theta, r)
    call pd%set_line_width(2.0)

    call plt%initialize()
    call plt%set_font_size(14)
    call plt%set_title("Bifolium Curve")
    ! call plt%set_autoscale(.false.)
    call plt%set_radial_limits([0.0d0, 6.0d0])
    call plt%push(pd)
    call plt%draw()

    ! Cissoid of Diocles curve (polar coordinates)
    r = a * sin(theta) * tan(theta)
    
end program
