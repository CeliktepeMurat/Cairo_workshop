import os
import pytest

from starkware.starknet.testing.starknet import Starknet

CONTRACT_FILE = os.path.join(os.path.dirname(__file__), "../hello_starknet/simple_contract.cairo")

@pytest.mark.asyncio
async def test_increase_balance():
    starknet = await Starknet.empty()
    
    contract = await starknet.deploy(source=CONTRACT_FILE,)
    
    await contract.increase_balance(amount=1000).execute()
    await contract.increase_balance(amount=500).execute()
    
    execution_result = await contract.get_balance().call()
    assert execution_result.result == (1500,)