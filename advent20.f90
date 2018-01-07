program advent20
    implicit none

    integer(kind = 16) :: i, result, j
    character(len = 100) :: line
    integer(kind = 16), dimension(1000) :: px, py, pz, oldpx
    integer(kind = 16), dimension(1000) :: vx, vy, vz, oldvx
    integer(kind = 16), dimension(1000) :: ax, ay, az
    logical, dimension(1000) :: removed
    logical :: all_moves_away
    integer(kind = 16) :: minA, maxA, minD, countRemoved

    minA = 2147483647
    open (unit = 1, file = "input20.txt")
    do i = 1, 1000
        !    do i = 1, 4
        read(1, '(a)') line
        call get_values(line, px(i), py(i), pz(i), vx(i), vy(i), vz(i), ax(i), ay(i), az(i))
        maxA = abs(ax(i)) * abs(ax(i)) + abs(ay(i)) * abs(ay(i)) + abs(az(i)) * abs(az(i))
        if (maxA < minA) then
            minA = maxA
            result = i - 1
        end if
        removed(i) = .false.
    end do
    close (1)

    print *, 'The answer of part one is ', result

    countRemoved = 0
    all_moves_away = .false.
    do while (.not. all_moves_away)
        call remove_colliding(px, py, pz, removed, countRemoved)
        call move(px, py, pz, vx, vy, vz, ax, ay, az, all_moves_away)
    end do
    print *, 'The answer of part two is ', 1000 - countRemoved

contains
    subroutine get_values(line, px, py, pz, vx, vy, vz, ax, ay, az)
        implicit none
        character(len = *), intent(in) :: line
        integer(kind = 16), intent(out) :: px, py, pz, vx, vy, vz, ax, ay, az
        integer(kind = 16) :: idx1, idx2

        idx2 = 4
        call get_one_value(line, idx2, ',', px, idx1)
        call get_one_value(line, idx1, ',', py, idx2)
        call get_one_value(line, idx2, '>', pz, idx1)
        call get_one_value(line, idx1 + 5, ',', vx, idx2)
        call get_one_value(line, idx2, ',', vy, idx1)
        call get_one_value(line, idx1, '>', vz, idx2)
        call get_one_value(line, idx2 + 5, ',', ax, idx1)
        call get_one_value(line, idx1, ',', ay, idx2)
        call get_one_value(line, idx2, '>', az, idx1)
    end subroutine get_values

    subroutine get_one_value(line, startIdx, breakChar, value, endIdx)
        implicit none
        character(len = *), intent(in) :: line, breakChar
        integer(kind = 16), intent(in) :: startIdx
        integer(kind = 16), intent(out) :: value, endIdx
        integer(kind = 16) :: idx

        idx = index(line(startIdx : 100), breakChar) - 2
        read(line(startIdx : startIdx + idx), '(I16)') value
        endIdx = startIdx + idx + 2
    end subroutine get_one_value

    subroutine remove_colliding(px, py, pz, removed, c)
        implicit none
        integer(kind = 16), dimension(:), intent(in) :: px, py, pz
        logical, dimension(:), intent(out) :: removed
        integer(kind=16), intent(inout) :: c
        integer(kind = 16) :: i, j
        logical :: r

        do i = 1, size(px)
            r = .false.
            do j = 1, size(px)
                if (i /= j .and. .not. removed(i) .and. .not. removed(j) .and. px(i) == px(j)) then
                    if (py(i) == py(j) .and. pz(i) == pz(j)) then
                        removed(j) = .true.
                        r = .true.
                        c = c + 1
                    end if
                end if
            end do
            if (r) then
                removed(i) = .true.
                c = c + 1
            end if
        end do
    end subroutine remove_colliding

    subroutine move(px, py, pz, vx, vy, vz, ax, ay, az, all_moves_away)
        implicit none
        integer(kind = 16), dimension(:), intent(in) :: ax, ay, az
        integer(kind = 16), dimension(:), intent(inout) :: px, py, pz, vx, vy, vz
        integer(kind = 16) :: i, d1, d2
        logical, intent(out) :: all_moves_away

        all_moves_away = .true.
        do i = 1, size(px)
            d1 = px(i) * px(i) + py(i) * py(i) + pz(i) * pz(i)
            vx(i) = vx(i) + ax(i)
            vy(i) = vy(i) + ay(i)
            vz(i) = vz(i) + az(i)
            px(i) = px(i) + vx(i)
            py(i) = py(i) + vy(i)
            pz(i) = pz(i) + vz(i)
            d2 = px(i) * px(i) + py(i) * py(i) + pz(i) * pz(i)
            if (d2 < d1) then
                all_moves_away = .false.
            end if
        end do
    end subroutine move
end program Advent20
