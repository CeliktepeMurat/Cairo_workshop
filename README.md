# Cairo_workshop

## Starknet Execution Commands

export STARKNET_NETWORK=alpha-goerli

export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount

starknet get_nonce --contract_address 0x01299285af0a9efd5386225e075d6cc9be2f021def500512b75f576de6055b6e

starknet-compile proxy_contract.cairo --output Compiled/proxy_contract.json --abi ABIs/proxy_contract_abi.json

starknet declare --contract Compiled/proxy_contract.json

starknet deploy --class_hash 0x5a18eb74734727740a1b751044b3300b3525aec0714c6046a007918937dbf56

starknet invoke \
 --address 0x001fd00de0b4cc53c5025bd57746584a7791e9660dd905119057f29e362a7a9b \
 --abi ABIs/proxy_contract_abi.json \
 --function call_increase_balance \
 --inputs 0x07a4b36b17474dcfb1e224934030cdf3ba0b3e9082349c412b158c3ec36750dd 1000

starknet call \
 --address 0x00670ad02c0892d43344df213da7e09651ef5db9ee420d84aa1cf64fd4eaec16 \
 --abi ABIs/proxy_contract_abi.json \
 --function get_my_balance

starknet invoke \
 --address 0x00670ad02c0892d43344df213da7e09651ef5db9ee420d84aa1cf64fd4eaec16 \
 --abi ABIs/proxy_contract_abi.json \
 --function increase_my_balance \
 --inputs 0x399998c787e0a063c3ac1d2abac084dcbe09954e3b156d53a8c43a02aa27d35 12321
