%builtins output

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word

func array_sum(arr: felt*, size: felt) -> felt {
    if (size == 0) {
        return 0;
    }

    let sum_of_the_rest = array_sum(arr = arr + 2, size = size - 2);
    return [arr] + sum_of_the_rest;
}

func main{output_ptr: felt*}() {
    const ARRAY_SIZE = 6;

    // Allocate an array.
    let (ptr) = alloc();

    // Populate some values in the array.
    assert [ptr] = 2;
    assert [ptr + 1] = 3;
    assert [ptr + 2] = 4;
    assert [ptr + 3] = 5;
    assert [ptr + 4] = 6;
    assert [ptr + 5] = 7;

    // Call array_sum to compute the sum of the elements.
    let sum = array_sum(arr=ptr, size=ARRAY_SIZE);

    // Write the sum to the program output.
    serialize_word(sum);

    return ();
}