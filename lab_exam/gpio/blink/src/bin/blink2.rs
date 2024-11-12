use std::thread;
use std::time::Duration;
use rppal::gpio::Gpio;

const GPIO_LED1: u8 = 2;
const GPIO_LED2: u8 = 3;
const GPIO_LED3: u8 = 4;
const GPIO_BUTTON: u8 = 17;

fn main() {
    let gpio = Gpio::new().expect("Failed to access GPIO");
    let mut led1 = gpio.get(GPIO_LED1).expect("failed to get GPIO 2").into_output();
    let mut led2 = gpio.get(GPIO_LED2).expect("failed to get gpio 3").into_output();
    let mut led3 = gpio.get(GPIO_LED3).expect("Failed to get gpio 4").into_output();

    let button = gpio.get(GPIO_BUTTON).expect("Failed to get GPIO 17").into_input_pulldown();

    let mut state = 0;

    led1.set_low();
    led2.set_low();
    led3.set_low();

    loop {
        if button.is_high() {
            state += 1;
            if state > 4 {
                state = 1;
            }
            led1.set_low();
            led2.set_low();
            led3.set_low();

            match state {
                1 => led1.set_high(),
                2 => led2.set_high(),
                3 => led3.set_high(),
                4 => led2.set_high(),
                0 => led1.set_high(),
                _ => {}
            }

            while button.is_high() {
                thread::sleep(Duration::from_millis(10));
            }
        }

        thread::sleep(Duration::from_millis(10));
    }
}