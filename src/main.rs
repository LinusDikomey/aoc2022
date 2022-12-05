#![feature(iter_array_chunks, array_chunks, array_windows)]
#![allow(unused)]

use std::fs;

mod day3;
mod day4;
mod day5;

#[track_caller]
fn p() -> ! { panic!() }

fn main() {
    //day3::run(&fs::read_to_string("input/day3.txt").unwrap());
    //day4::run(&fs::read_to_string("input/day4.txt").unwrap());
    day5::run(&fs::read_to_string("input/day5.txt").unwrap());

}
