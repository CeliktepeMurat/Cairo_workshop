%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin


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