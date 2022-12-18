%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_nn

// let (caller_address) = get_caller_address()

@storage_var
func balance(user: felt) -> (res: felt) {
}

@external
func increaseBalance{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*, 
    range_check_ptr
    } (amount: felt) {
    with_attr error_message("Amount must be positive") {
        assert_nn(amount);
    }

    let (user) = get_caller_address();

    let (old_balance) = balance.read(user=user);
    balance.write(user, old_balance + amount);
    return();

}

@view
func getBalance{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*, 
    range_check_ptr
    } (user: felt) -> (res: felt) {
    let (res) = balance.read(user=user);
    return(res=res);
}

// Account address: 0x01299285af0a9efd5386225e075d6cc9be2f021def500512b75f576de6055b6e
// Public key: 0x04442e4625843145eab0d9197a36b22f6c38297aed80a2f36c8e3b97898af90d