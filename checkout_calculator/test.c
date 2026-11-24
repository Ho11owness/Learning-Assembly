// Output
// 10000, 20, 10: PASSED
// 5000, 0, 21: PASSED
// 2000, 50, 0: PASSED
// 100, 100, 20: PASSED
// 100, 33, 10: PASSED
// 9999, 15, 8: PASSED
// 0, 50, 20: PASSED
// PASSED: 7/7

#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

typedef struct {
    uint64_t price;
    uint64_t discountPercent;
    uint64_t taxPercent;
    uint64_t expectedPrice;
} TestCase;

extern uint64_t checkout_total(uint64_t price, uint64_t discountPercent, uint64_t taxPercent);

int main(void) {
    TestCase tests[] = {
    {10000, 20, 10, 8800},
	{5000, 0, 21, 6050},
	{2000, 50, 0, 1000},
	{100, 100, 20, 0},
	{100, 33, 10, 73},
	{9999, 15, 8, 9180},
	{0, 50, 20, 0}
    };

    size_t count = sizeof(tests) / sizeof(tests[0]);
    size_t passed = 0;

    for (size_t i = 0; i < count; i++) {
	    TestCase test = tests[i];

	    uint64_t totalPrice = checkout_total(test.price, test.discountPercent, test.taxPercent);

	if (totalPrice == test.expectedPrice) {
	    passed++;
	    printf("%" PRIu64 ", %" PRIu64 ", %" PRIu64 ": PASSED\n", test.price, test.discountPercent, test.taxPercent);
    } else {
	    printf("%" PRIu64 ", %" PRIu64 ", %" PRIu64 ": FAILED -> Expected %" PRIu64 " but got %" PRIu64 "\n", test.price, test.discountPercent, test.taxPercent, test.expectedPrice, totalPrice);
	    }
    }

    printf("PASSED: %zu/%zu\n", passed, count);

    return passed == count ? 0 : 1;
}
