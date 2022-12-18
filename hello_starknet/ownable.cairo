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
    }(owner_address: felt) {
        owner.write(owner_address);
        return();
}

@view
func get_owner{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
    } () -> (owner_address: felt) {
    let (owner_address) = owner.read();
    return(owner_address=owner_address);
}
