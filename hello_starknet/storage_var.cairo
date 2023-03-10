%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin

// A mapping from user to a pair (min, max)
@storage_var
func range(user: felt) -> (res: (felt, felt)) {
}


@external
func extend_range{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*, 
    range_check_ptr
    }(user: felt) {
    let (min_max) = range.read(user);
    range.write(user, (min_max[0] - 1, min_max[1] + 1));
    return ();
}

// ###################################################################################################

// Structs
struct User {
    first_name: felt,
    last_name: felt,
}

// A mapping from user to 1 if they voted and 0 if they didn't
@storage_var
func user_voted(user: User) -> (res: felt) {
}

@external
func vote{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    user: User
) {
    user_voted.write(user, 1);
    return ();
}

// ###################################################################################################

// Arrays
@external
func compare(
    a_len: felt, a: felt*, b_len: felt, b: felt*
) {
    assert a_len = b_len;
    if (a_len == 0) {
        return ();
    }

    assert a[0] = b[0];
    return compare(a_len=a_len - 1, a=&a[1], b_len=b_len - 1, b=&b[1]);
}

// ###################################################################################################


struct Point {
    x: felt,
    y: felt,
}

@view
func sum_points(points: (Point, Point)) -> (res: Point) {
    return (
        res = Point(
            x = points[0].x + points[1].x,
            y = points[0].y + points[1].y,
        )
    );
}

// ###################################################################################################

@external
func sum_points_array(
    a_len: felt, a: Point*
) -> (res : Point) {
    if(a_len == 0) {
        return (res = Point(x=0, y=0));
    }

    let (res) = sum_points_array(a_len = a_len -1, a = &a[1]);
    return (res = Point(x = res.x + [a].x, y = res.y + [a].y));
}


// ###################################################################################################

from starkware.starknet.common.syscalls import get_tx_info

@external
func get_tx_max_fee{syscall_ptr: felt*}() -> (res: felt){
    let (tx) = get_tx_info();
    return (res = tx.max_fee);
}

// ###################################################################################################

from starkware.starknet.common.syscalls import (
    get_block_number,
    get_block_timestamp,
)

struct X {
    blockNo: felt,
    blockTime: felt,
}

@external
func get_numbers{syscall_ptr: felt* }() -> (res: X){
    let (block_number) = get_block_number();
    let (block_timestamp) = get_block_timestamp();

    return (res = X(blockNo= block_number, blockTime= block_timestamp));
}

