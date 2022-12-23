%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_nn
from starkware.starknet.common.messages import send_message_to_l1

const L1_CONTRACT_ADDRESS = (0x8359E4B0152ed5A731162D3c7B0D8D56edB165A0);

const MESSAGE_WITHDRAW = 0;

@storage_var
func balance(user: felt) -> (value: felt) {
}

@view
func get_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (user: felt) -> (balance: felt) {
    let (res) = balance.read(user=user);
    return (balance=res);
}

@external
func increase_balance{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*, 
    range_check_ptr
} (user: felt, amount: felt) {
    let (res) = balance.read(user=user);
    tempvar new_balance = res + amount;
    balance.write(user=user, value=new_balance);
    return ();
}

@external
func withdraw{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*, 
    range_check_ptr
} (user: felt, amount: felt) {
    assert_nn(amount);

    let (res) = balance.read(user=user);
    tempvar new_balance = res - amount;

    assert_nn(new_balance);

    balance.write(user=user, value=new_balance);

    let (payload: felt*) = alloc();
    assert payload[0] = MESSAGE_WITHDRAW;
    assert payload[1] = user;
    assert payload[2] = amount;
    send_message_to_l1(
        to_address=L1_CONTRACT_ADDRESS,
        payload_size=3,
        payload=payload,
    );

    return ();
}

@l1_handler
func deposit{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*, 
    range_check_ptr
} (from_address: felt, user: felt, amount: felt) {
    assert from_address = L1_CONTRACT_ADDRESS;

    let (res) = balance.read(user=user);
    
    tempvar new_balance = res + amount;
    balance.write(user=user, value=new_balance);
    
    return ();
}