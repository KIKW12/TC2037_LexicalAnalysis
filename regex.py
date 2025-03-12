import re

def is_valid_pattern(text):
    """
    Check if the input text matches the regex pattern ^0*1(0|1|2)*002$
    
    Args:
        text (str): The string to check
        
    Returns:
        bool: True if the text matches the pattern, False otherwise
    """
    pattern = r'^0*1(0|1|2)*002$'
    return bool(re.match(pattern, text))

def main():
    # Test cases
    test_cases = [
        "1002",           # Valid: starts with 1, ends with 002
        "01002",          # Valid: starts with 0*1, ends with 002
        "0001002",        # Valid: starts with 0*1, ends with 002
        "10102002",       # Valid: has 1 followed by valid chars then 002
        "12102002",       # Valid: has 1 followed by valid chars then 002
        "1000002",        # Valid: has 1 followed by zeros, then 002
        "000001002",      # Valid: many leading zeros, then 1, then 002
        "10002",          # Valid: 1 followed by 00 then 2 (not the ending 002)
        "100212002",      # Valid: complex middle section with all allowed digits
        "1002002",        # Valid: pattern can have 002 in the middle too
        "100000000002",   # Valid: many zeros in the middle
        "121212002",      # Valid: alternating pattern in middle
        "1002",           # Valid: minimum valid string (already in list)
        "002",            # Invalid: doesn't start with 0*1
        "10023",          # Invalid: doesn't end with 002
        "21002",          # Invalid: doesn't start with 0*1
        "103002",         # Invalid: contains 3 which isn't allowed
        "",               # Invalid: empty string
        "1",              # Invalid: too short, doesn't end with 002
        "002002",         # Invalid: missing initial 1
        "0002",           # Invalid: missing 1 after leading zeros
        "1003",           # Invalid: wrong ending
        "100",            # Invalid: missing final 2
        "1456002",        # Invalid: contains digits not in [0,1,2]
        "10a02",          # Invalid: contains non-digit character
        "00102 ",         # Invalid: has trailing space
        " 1002"                # Invalid: empty string
    ]
    
    print("Testing strings against pattern ^0*1(0|1|2)*002$:\n")
    for test in test_cases:
        result = is_valid_pattern(test)
        print(f"'{test}': {'Valid' if result else 'Invalid'}")
    
    # Interactive mode
    print("\nEnter your own strings to test (type 'exit' to quit):")
    while True:
        user_input = input("> ")
        if user_input.lower() == 'exit':
            break
        result = is_valid_pattern(user_input)
        print(f"'{user_input}': {'Valid' if result else 'Invalid'}")

if __name__ == "__main__":
    main()