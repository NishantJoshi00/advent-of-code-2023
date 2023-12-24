
program solution
  implicit none

  integer :: count, i, j, ioState;
  integer, allocatable :: horizontal(:)
  integer, allocatable :: vertical(:)

  character(len=1024), allocatable :: input_array(:,:)
  character(len=1024) :: input;
  integer, allocatable :: sizes(:)

  allocate(input_array(256, 1024))
  allocate(sizes(256))
  allocate(horizontal(256))
  allocate(vertical(256))
  sizes(:) = 0
  horizontal(:) = 0
  vertical(:) = 0
  count = 1
  i = 1

  do while (1 == 1)
    read (*, "(A)", iostat=ioState) input
    if (ioState .ne. 0) then
      exit
    end if
    if (input == "") then
      sizes(count) = i - 1
      count = count + 1
      i = 1
      cycle
    end if

    input_array(count, i) = input
    i = 1 + i
  end do
  sizes(count) = i - 1


  do concurrent (i = 1:count)
    call solve(horizontal(i), vertical(i), input_array(i,:), sizes(i))
  end do

  print *, "-----------------------------------"
  print *, sum(horizontal) * 100 + sum(vertical)


  deallocate(input_array)
  deallocate(sizes)
  deallocate(horizontal)
  deallocate(vertical)
end program solution


subroutine solve(hwrite, vwrite, input, size)
  implicit none
  integer, intent(in) :: size
  integer, intent(out) :: vwrite, hwrite
  character(len=1024), intent(in) :: input(size)
  character(len=size) :: inputT(len(trim(input(1))))
  integer, dimension(len(trim(input(1)))-1) :: happlicative
  integer, dimension(size - 1) :: vapplicative
  logical :: rev_check
  integer :: i, j, mylen, mlen

  happlicative(:) = 0
  vapplicative(:) = 0
  mylen = len(trim(input(1)))

  do i = 1,mylen-1
    do j = 1, size
      mlen = MIN(i, mylen - i)
      if (rev_check(input(j)(i-mlen+1:i), input(j)(i+1:i+mlen), mlen)) then
        happlicative(i) = happlicative(i) + 1
      end if
      ! happlicative(i) = rev_check(input(j)(i-mlen+1:i), input(j)(i+1:i+mlen), mlen) + happlicative(i)
    end do
  end do

  do concurrent(i = 1:mylen)
    do concurrent (j = 1:size)
      inputT(i)(j:j) = input(j)(i:i)
    end do
  end do



  do i = 1,size-1
    do j = 1, mylen
      mlen = MIN(i, size - i)
      if (rev_check(inputT(j)(i-mlen+1:i), inputT(j)(i+1:i+mlen), mlen)) then
        vapplicative(i) = 1 + vapplicative(i) 
      end if
      ! vapplicative(i) = rev_check(inputT(j)(i-mlen+1:i), inputT(j)(i+1:i+mlen), mlen) + vapplicative(i)
    end do
  end do


  hwrite = FINDLOC(vapplicative, 1, DIM=1)

  vwrite = FINDLOC(happlicative, 1, DIM=1)

end subroutine solve

function rev_check(left, right, min_size) result(mirror)
  implicit none
  integer, intent(in) :: min_size
  character(len=min_size), intent(in) :: left, right
  integer :: i
  logical :: mirror

  mirror = .false.
  
  do i = 1, min_size
    if (left(i:i) .ne. right((min_size + 1 - i):(min_size + 1 - i))) then
      mirror = .true.
      exit
    end if
  end do
end function rev_check
