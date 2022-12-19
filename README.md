# Cairo_workshop

## Starknet Execution Commands

```
export STARKNET_NETWORK=alpha-goerli
```

```
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
```

```
starknet get_nonce --contract_address {CONTRACT_ADDRESS}
```

```
starknet-compile {CONTRACT_NAME}.cairo --output Compiled/{CONTRACT_NAME}.json --abi ABIs/{CONTRACT_NAME}_abi.json
```

```
starknet declare --contract Compiled/{CONTRACT_NAME}.json
```

```
starknet deploy --class_hash {CLASS_HASH}
```

```
starknet invoke \
 --address {CONTRACT_ADDRESS} \
 --abi ABIs/{CONTRACT_NAME}_abi.json \
 --function {FUNCTION_NAME} \
 --inputs {INPUTS}
```

```
starknet call \
 --address {CONTRACT_ADDRESS} \
 --abi ABIs/{CONTRACT_NAME}_abi.json \
 --function {FUNCTION_NAME}
```
