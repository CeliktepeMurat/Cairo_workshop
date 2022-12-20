%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import deploy

@storage_var
func salt() -> (value: felt) {
}

@event
func EmitOwnableDeployed(ownable: felt) {
}

@external
func deploy_ownable{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*, 
    range_check_ptr
} (owner_address: felt, ownable_class_hash: felt) {
    let (current_salt) = salt.read();
    let (deployed_contract_address) = deploy(
        class_hash = ownable_class_hash,
        contract_address_salt = current_salt,
        constructor_calldata_size = 1,
        constructor_calldata = cast(new (owner_address,), felt*),
        deploy_from_zero = FALSE,
    );

    salt.write(value=current_salt + 1);

    EmitOwnableDeployed.emit(
        ownable=deployed_contract_address
    );

    return ();
}
