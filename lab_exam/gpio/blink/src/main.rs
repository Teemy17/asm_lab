use std::thread;
use std::time::Duration;
use rppal::gpio::Gpio;
use rppal::system::DeviceInfo;

const GPIO_2: u8 = 2;

fn main() {
    let device_info = DeviceInfo::new();
    match device_info {
        Ok(info) => {
            println!("Running LED sequence on a {}.", info.model());
    }
        Err(e) => {
            panic!("Unable to get device info: {:?}", e);
        }
    }
    let gpio = Gpio::new().unwrap();
    let mut pin2 = gpio.get(GPIO_2).unwrap().into_output();
    loop {
        pin2.set_high();
        thread::sleep(Duration::from_millis(500));
        pin2.set_low();
        thread::sleep(Duration::from_millis(500));
    }
}