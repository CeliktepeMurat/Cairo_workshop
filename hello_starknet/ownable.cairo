%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func owner() -> (owner: felt) {
}

@constructor
func constructor{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
    }(owner: felt) {
        owner.write(owner);
        return();
}

@view
func get_owner{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
    } -> (address: felt) {
    let (owner) = owner.read();
    return(address=owner);
}
