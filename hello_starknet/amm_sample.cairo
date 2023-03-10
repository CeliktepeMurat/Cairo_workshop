%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.math import assert_le, assert_nn_le, unsigned_div_rem
from starkware.starknet.common.syscalls import get_caller_address, storage_read, storage_write

// The maximum amount of each token that belongs to the AMM.
const BALANCE_UPPER_BOUND = 2 ** 64;

// Ensure the user's balances are much smaller than the pool's balance.
const POOL_UPPER_BOUND = 2 ** 30;
const ACCOUNT_BALANCE_BOUND = 1073741;  // 2**30 // 1000.

const TOKEN_TYPE_A = 1;
const TOKEN_TYPE_B = 2;

@storage_var
func pool_balance(token_type: felt) -> (balance: felt) {
}

@storage_var
func account_balance(account_id: felt, token_type: felt) -> (balance: felt) {
}

func modify_account_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (account_id: felt, token_type: felt, amount: felt) {
    let (current_balance) = account_balance.read(
        account_id, token_type
    );

    tempvar new_balance =  current_balance + amount;

    assert_nn_le(new_balance, BALANCE_UPPER_BOUND - 1);

    account_balance.write(
        account_id = account_id,
        token_type = token_type, 
        value = new_balance
    );
    
    return ();
}

@view
func get_account_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (account_id: felt, token_type: felt) -> (balance: felt) {
    return account_balance.read(
        account_id, token_type
    );
}

func set_pool_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (token_type: felt, balance: felt) {
    assert_nn_le(balance, BALANCE_UPPER_BOUND - 1);

    pool_balance.write(
        token_type = token_type, 
        value = balance
    );
    
    return ();
}

@view
func get_pool_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (token_type: felt) -> (balance: felt) {
    return pool_balance.read(token_type);
}

@view
func get_opposite_token(token_type: felt) -> (t: felt){
    if (token_type == TOKEN_TYPE_A) {
        return (t = TOKEN_TYPE_B);
    } else {
        return (t = TOKEN_TYPE_A);
    }
} 

@external
func swap{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*, 
    range_check_ptr
} (token_from: felt, amount_from: felt) -> (amount_to: felt) {
    let (account_id) = get_caller_address();

    assert (token_from - TOKEN_TYPE_A) * (token_from - TOKEN_TYPE_B) = 0;

    assert_nn_le(amount_from, BALANCE_UPPER_BOUND - 1);

    let (account_from_balance) = get_account_balance(
        account_id = account_id,
        token_type = token_from
    );

    assert_le(amount_from, account_from_balance);

    let (token_to) = get_opposite_token(token_from);
    let (amount_to) = do_swap(
        account_id = account_id,
        token_from = token_from,
        token_to = token_to,
        amount_to_swap = amount_from
    );
    
    return (amount_to=amount_to);
}


func do_swap{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*, 
    range_check_ptr
} (account_id: felt, token_from: felt, token_to: felt, amount_to_swap: felt) -> (amount_to: felt) {
    alloc_locals;

    // Get the pool balances.
    let (local amm_from_balance) = get_pool_balance(token_type = token_from);
    let (local amm_to_balance) = get_pool_balance(token_type = token_to);

    // Calculate Swap amount
    let (local amount_to, _) = unsigned_div_rem(
        amm_to_balance * amount_to_swap,
        amm_from_balance + amount_to_swap
    );

    // update token from balances
    modify_account_balance(
        account_id = account_id,
        token_type = token_from,
        amount = -amount_to_swap
    );

    set_pool_balance(
        token_type = token_from,
        balance = amm_from_balance + amount_to_swap
    );

    //update token_to balances
    modify_account_balance(
        account_id = account_id,
        token_type = token_to,
        amount = amount_to
    );

    set_pool_balance(
        token_type = token_to,
        balance = amm_to_balance - amount_to
    );

    return (amount_to = amount_to);
}

@external
func init_pool{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*, 
    range_check_ptr
} (token_a: felt, token_b: felt) {
    assert_nn_le(token_a, BALANCE_UPPER_BOUND - 1);
    assert_nn_le(token_b, BALANCE_UPPER_BOUND - 1);

    set_pool_balance(
        token_type = TOKEN_TYPE_A,
        balance = token_a
    );

    set_pool_balance(
        token_type = TOKEN_TYPE_B,
        balance = token_b
    );

    return ();
}

@external
func add_demo_token{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(token_a_amount: felt, token_b_amount: felt) {
    let (account_id) = get_caller_address();

    // Make sure the account's balance is much smaller than
    // the pool init balance.
    assert_nn_le(token_a_amount, ACCOUNT_BALANCE_BOUND - 1);
    assert_nn_le(token_b_amount, ACCOUNT_BALANCE_BOUND - 1);

    modify_account_balance(
        account_id=account_id,
        token_type=TOKEN_TYPE_A,
        amount=token_a_amount,
    );

    modify_account_balance(
        account_id=account_id,
        token_type=TOKEN_TYPE_B,
        amount=token_b_amount,
    );

    return ();
}



