#[unsafe(no_mangle)]
pub extern "C" fn add_numbers(a: i32, b: i32) -> i32 {
    a + b
}

#[unsafe(no_mangle)]
pub extern "C" fn factorial(n: u32) -> u64 {
    if n <= 1 {
        1
    } else {
        (1..=n as u64).product()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add_numbers() {
        assert_eq!(add_numbers(2, 3), 5);
        assert_eq!(add_numbers(-1, 1), 0);
    }

    #[test]
    fn test_factorial() {
        assert_eq!(factorial(0), 1);
        assert_eq!(factorial(1), 1);
        assert_eq!(factorial(5), 120);
        assert_eq!(factorial(10), 3628800);
    }
}