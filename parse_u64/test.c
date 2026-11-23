#include <stdint.h>
#include <inttypes.h>
#include <stdio.h>

// Our Assembly function
extern int parse_u64(const char *text, uint64_t *out);

// Structure representing one test
typedef struct {
    const char *input;
    int expected_status;
    uint64_t expected_value;
    int null_output;
} TestCase;

int main(void) {
    const uint64_t INITIAL_VALUE = 999;

    TestCase tests[] = {
        {"00042", 0, 42, 0},
        {"4294967296", 0, 4294967296ULL, 0},
        {"18446744073709551614", 0, UINT64_MAX - 1, 0},
        {"18446744073709551617", 2, 0, 0},
        {"999999999999999999999", 2, 0, 0},
        {"", 1, 0, 0},
        {"-42", 1, 0, 0},
        {"+42", 1, 0, 0},
        {"12 3", 1, 0, 0},
        {"123\n", 1, 0, 0},
        {"000", 0, 0, 0},

        // NULL pointer tests
        {NULL, 1, 0, 0},
        {"42", 1, 0, 1}
    };

    int failed = 0;
    int count = sizeof(tests) / sizeof(tests[0]);

    for (int i = 0; i < count; i++) {
        uint64_t result = INITIAL_VALUE;

        // Choose whether to pass a valid output pointer
        uint64_t *out = tests[i].null_output ? NULL : &result;

        int status = parse_u64(tests[i].input, out);

        // Determine the expected output value
        uint64_t expected = INITIAL_VALUE;

        if (tests[i].expected_status == 0) {
            expected = tests[i].expected_value;
        }

        // Safe description for NULL inputs
        const char *input_name =
            tests[i].input ? tests[i].input : "NULL";

        const char *suffix =
            tests[i].null_output ? " (NULL output)" : "";

        // Verify status and output memory
        if (status == tests[i].expected_status &&
            result == expected) {
            printf("PASS: %s%s\n", input_name, suffix);
        } else {
            printf("FAIL: %s%s\n", input_name, suffix);

            printf("  Status: expected %d, got %d\n",
                   tests[i].expected_status, status);

            printf("  Value: expected %" PRIu64
                   ", got %" PRIu64 "\n",
                   expected, result);

            failed++;
        }
    }

    printf("\n%d/%d tests passed\n", count - failed, count);

    return failed > 0 ? 1 : 0;
}

