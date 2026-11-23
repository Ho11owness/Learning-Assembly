#include <stdio.h>
#include <stdint.h>
#include <string.h>

extern int utoa_u64(uint64_t value, char *buffer, uint64_t capacity);

typedef struct {
    uint64_t value;
    uint64_t capacity;
    const char *expected_string;
    int expected_status;
    int null_buffer;
} TestCase;

int main(void) {
    TestCase tests[] = {
	/// Basic conversions
	{0, 2, "0", 0, 0},
	{7, 2, "7", 0, 0},
	{42, 3, "42", 0, 0},
	{123, 4, "123", 0, 0},
	{1000, 5, "1000", 0, 0},

	/// Decimal boundaries
	{9, 2, "9", 0, 0},
	{10, 3, "10", 0, 0},
	{99, 3, "99", 0, 0},
	{100, 4, "100", 0, 0},
	{999, 4, "999", 0, 0},

	/// Large integers
	{9999999999999999999ULL, 20, "9999999999999999999", 0, 0},
        {10000000000000000000ULL, 21, "10000000000000000000", 0, 0},
        {UINT64_MAX, 21, "18446744073709551615", 0, 0},

	/// Buffer capacity errors
	{42, 0, NULL, 2, 0},
	{42, 2, NULL, 2, 0},
	{0, 1, NULL, 2, 0},
	{UINT64_MAX, 20, NULL, 2, 0},

	/// Larger than necessary buffer
	{42, 32, "42", 0, 0},

	/// NULL pointer
	{42, 10, NULL, 1, 1}
    };

    size_t count = sizeof(tests) / sizeof(tests[0]);
    size_t passed = 0;

    for (size_t i = 0; i < count; i++) {
	TestCase test = tests[i];
	char buffer[32];
	memset(buffer, 0xA5, sizeof(buffer));
        
	char *output = test.null_buffer ? NULL : buffer;

	int status = utoa_u64(
	    test.value,
	    output,
	    test.capacity
	);

	int success = (status == test.expected_status);

	if (success && status == 0) {
	    size_t length = strlen(test.expected_string) + 1;

	    if (memcmp(buffer, test.expected_string, length) != 0) {
		success = 0;
	    }
	}

	if (success && status != 0 && !test.null_buffer) {
	    for (size_t j = 0; j < sizeof(buffer); j++) {
		if ((unsigned char)buffer[j] != 0xA5) {
		    success = 0;
		}
	    }
	}

	printf("[%s] Test %zu\n", success ? "PASS" : "FAIL", i + 1);

	if (success) {
	    passed++;
	}
    }

    printf("\n%zu/%zu tests passed\n", passed, count);

    return passed == count ? 0 : 1;
}
