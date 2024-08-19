fn main() {
    cc::Build::new()
        .file("src/asm_code.s")
        .compile("asm_code");
    println!("cargo:rustc-link-lib=static=asm_code");
    println!("cargo:rustc-link-search=native={}", std::env::var("OUT_DIR").unwrap());
}
