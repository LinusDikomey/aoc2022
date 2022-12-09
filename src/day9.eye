use std.list.List
use std.panic
use std.print
use std.println

Dir :: enum { L R U D }

main :: fn {
    println("Day 9:")
    input := std.file.read_to_string("src/input/day9.txt")
    lines := input.trim().lines()
    cmds := List.new()
    i := 0
    while i < lines.len {
        l := lines.get(i)
        dir := match l.slice(0, 1) {
            "L": .L,
            "R": .R,
            "U": .U,
            "D": .D,
            _: panic("Invalid input")
        }
        amount := l.slice(2, l.len).parse() as i32
        cmds.push((dir, amount))
        i += 1
    }
    part_1 := a(cmds)
    std.c.printf("\tPart 1: %d".ptr, part_1)
}

abs :: fn(x i32) -> i32: if x < 0: -x else x
sign :: fn(x i32) -> i32: if x > 0: 1 else if x < 0: -1 else 0

follow :: fn(hx i32, hy i32, tx i32, ty i32, visited *[[bool; 2000]; 2000]) -> (i32, i32) {
    while abs(hx - tx) > 1 or abs(hy - ty) > 1 {
        tx += sign(hx - tx)
        ty += sign(hy - ty)

        std.c.printf("Setting %d, %d\n".ptr, tx, tx)
        visited^[tx + 1000][ty + 1000] = true
    }
    ret (tx, ty)
}

count_visited :: fn(v *[[bool; 2000]; 2000]) -> u32 {
    c := 0
    x := 0
    y := 0
    while x < 2000 {
        # nested while was broken
        if v^[x][y]: c += 1
        x += 1
        if x == 2000 and y < 1999 {
            x = 0
            y += 1
        }
    }
    ret c
}

a :: fn(cmds List[(Dir, i32)]) -> u32 {
    visited: *[[bool; 2000]; 2000] = std.c.malloc(2000*2000) as _
    # tuple here was broken
    (head_x, head_y) := (0, 0)
    tail := (0, 0)
    i := 0
    while i < cmds.len {
        std.c.printf("Setting %d, %d\n".ptr, tail.0, tail.1)
        visited^[tail.0 + 1000][tail.1 + 1000] = true
        (d, a): (Dir, i32) = cmds.get(i)
        match d {
            .L: head_x -= a,
            .R: head_x += a,
            .U: head_y += a,
            .D: head_y -= a,
        }
        tail = follow(head_x, head_y, tail.0, tail.1, visited)
        i += 1
    }
    std.c.printf("Final head: %d, %d\n".ptr, head_x, head_y)

    ret count_visited(visited)
}
