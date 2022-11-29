# ERC-20 Wrapper

https://github.com/yieldprotocol/mentorship2022/issues/3

## Objectives

1. Users can send a pre-specified ERC-20 token to a contract that also is an ERC-20, and that we will call Wrapper.
2. The Wrapper contract issues an equal number of Wrapper tokens to the sender.
3. At any point, a holder of Wrapper tokens can burn them to recover their initial deposit.

Two contracts will be required:

- ERC20 token that will be the currency
- ERC20 Wrapper that will store the currency and give Wrapper tokens to the users.

## Wrapper Contract Core Functions

`constructor()`

- instantiates ERC-20 token contract to be received

`deposit()`

- receives ERC-20 token from usere
- checks that the token is of the pre-specified address
- mints an equivalent number of wrapper tokens to sender

`redeem()`

- receives wrapper ERC-20 token from user
- sends original ERC-20 to user

### Extension

Ether is not an ERC-20 token. This forces all platforms to implement Ether as an edge case. Code a Wrapper that takes Ether as it's currency.
