use std::thread;
use std::time::Duration;
use rppal::gpio::Gpio;

const GPIO_LED: u8 = 2;
const GPIO_BUTTON:u8 = 17;

fn main() {
    let gpio = Gpio::new().expect("Failed to access GPIO");
    let mut led = gpio.get(GPIO_LED).expect("failed to get GPIO 2").into_output();

    let button = gpio.get(GPIO_BUTTON).expect("Failed to get GPIO 17").into_input_pulldown();

    let mut led_on = false;

    loop {
        if button.is_high() {
            led_on = !led_on;
            if led_on {
                led.set_high();
                println!("led is on");
            } else {
                led.set_low();
                println!("led is off");
            }
            while button.is_high() {
                thread::sleep(Duration::from_millis(10));
            }
        }
        thread::sleep(Duration::from_millis(10))
    }

}