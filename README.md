# Sleet Hello Contract

A simple NEAR smart contract written in Zig that demonstrates basic greeting functionality.

## Building the Contract

1. First, install [Zig](https://ziglang.org/learn/getting-started/#installing-zig) (v0.13.0 recommended)

2. Build the contract:
```bash
zig build-exe sleet_hello.zig -target wasm32-freestanding -O ReleaseSmall --export=get_greeting --export=set_greeting -fno-entry
```

This will create `sleet_hello.wasm` file.

## Deploying the Contract

1. Install [near-cli-rs](https://github.com/near/near-cli-rs)

2. Deploy the contract to your NEAR account:
```bash
near deploy --wasmFile sleet_hello.wasm --accountId YOUR_ACCOUNT.near
```

## Interacting with the Contract

### Get the current greeting
```bash
near view YOUR_ACCOUNT.near get_greeting
```

### Set a new greeting
```bash
near call YOUR_ACCOUNT.near set_greeting '{"message":"Your new greeting"}' --accountId YOUR_ACCOUNT.near
```

Replace `YOUR_ACCOUNT.near` with your actual NEAR account name in all commands.

## Contract Methods

### `get_greeting()`
Returns the current greeting stored in the contract. If no greeting is set, returns the default greeting "Hello from Sleet!".

### `set_greeting()`
Sets a new greeting. The greeting cannot be empty.


---

This conrtact is deployed to
hello.sleet.testnet and hello.sleet.near
if you want to interact with it.


copright 2025 by sleet.near