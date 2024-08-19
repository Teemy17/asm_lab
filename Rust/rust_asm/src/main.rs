fn main() {
    extern "C" {
        fn asm_function(a: u32, b:u32) -> u32;
    }
    let x: u32 = 5;
    let y: u32 = 7;
    let result = unsafe {asm_function(x,y)};
    println!("The sum of {} and {} is {}", x, y, result);
}