%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func owner() -> (owner_address: felt):
end

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner_address: felt):
    owner.write(value=owner_address)
    return ()
end

@view
func get_owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} () -> (owner_address: felt):
    let (owner_address) = owner.read()
    return (owner_address)
end