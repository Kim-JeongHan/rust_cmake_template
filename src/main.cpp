#include "utils.h"
#include "rust_math_lib.h"

int main() {
    int sum = add_numbers(15, 27);
    uint64_t fact = factorial(5);
    
    Utils::print_result("15 + 27", sum);
    Utils::print_result("5!", fact);
    
    return 0;
}
