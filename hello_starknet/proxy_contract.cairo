%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin

@contract_interface
namespace IBalanceContract {
    func increase_balance(amount: felt){
    }
    func get_balance() -> (res: felt){
    }
}

@storage_var
func balance() -> (res: felt) {
}

@external
func increase_my_balance{syscall_ptr: felt*, range_check_ptr}(
    class_hash: felt, amount: felt
) {
    IBalanceContract.library_call_increase_balance(
        class_hash = class_hash, 
        amount= amount
    );
    
    return();
}


@external
func call_increase_balance{
    syscall_ptr: felt*, 
    range_check_ptr
} (contract_address: felt, amount: felt) {

    IBalanceContract.increase_balance(
        contract_address = contract_address, 
        amount= amount
    );

    return();
}

@view
func call_get_balance{
    syscall_ptr: felt*, 
    range_check_ptr
} (contract_address: felt) -> (res: felt) {
    
    let (res) = IBalanceContract.get_balance(
        contract_address = contract_address
    );

    return(res=res);
}

@view
func get_my_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}() -> (res: felt) {
    let (res) = balance.read();
    return (res=res);
}

// ###################################################################################

from starkware.starknet.common.syscalls import (
    get_contract_address,
)

let (contract_address) = get_contract_address(); // similar to address(this) in solidity