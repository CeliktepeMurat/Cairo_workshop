# a mapping fro user to a pair (min, max)
@storage_var
func range(user: felt) -> (res: (felt, felt)):
end

@external
func extend_range{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (user: felt):
    let (min_max) = range.read(user)
    range.write(user, (min_max[0] -1, min_max[1] + 1))
    return ()
end

###################################################################################################

struct User:
    member first_name: felt
    member last_name: felt
end

@storage_var
func user_voted(user: felt) -> (res: felt):
end

@external
func vote{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (user: User):
    user_voted.write(user, 1)
    return ()
end

###################################################################################################

@external
func compare_arrays(a_len: felt, a: felt*, b_len: felt, b: felt*):
    assert a_len = b_len
    if a_len == 0
        return ()
    end
    assert a[0] = b[0]
    return compare_arrays(a_len=a_len-1, a=&a[1], b_len=b_len-1, b=&)b[1])
end

