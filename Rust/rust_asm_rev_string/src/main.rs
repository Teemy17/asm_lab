extern "C" {
    fn reverse_string(s: *mut u8, len: usize);
}
fn main() {
    let mut s = String::from("Hello Assembly");
    unsafe { reverse_string(s.as_mut_ptr(), s.len());}
    println!("The reversed string is: {}", s)
}
