/// Helpers for creating and managing accounts.

module aptest::acct {
    use std::signer;

    use aptos_framework::account;
    use aptos_framework::coin;
    use aptos_framework::test_coin::{Self, TestCoin};
    use aptos_framework::system_addresses;

    /// Mint/burn capabilities for TestCoin. Not needed.
    struct Trash has key {
        mint_cap: coin::MintCapability<TestCoin>,
        burn_cap: coin::BurnCapability<TestCoin>,
    }

    /// Initializes [TestCoin].
    public fun prepare(
        resources: &signer,
        framework: &signer,
    ) {
        system_addresses::assert_core_resource(resources);
        system_addresses::assert_aptos_framework(framework);
        let (mint_cap, burn_cap) = test_coin::initialize(framework, resources);
        move_to(resources, Trash {
            mint_cap,
            burn_cap,
        });
    }

    /// Creates and funds an account.
    public entry fun create(
        resources: &signer,
        recipient_addr: address,
        amount: u64
    ) {
        system_addresses::assert_core_resource(resources);
        account::create_account(recipient_addr);
        if (amount > 0) {
            test_coin::mint(resources, recipient_addr, amount);
        };
    }

    /// Creates and funds an account.
    public entry fun setup(
        resources: &signer,
        recipient: &signer,
        initial_balance: u64
    ) {
        create(resources, signer::address_of(recipient), initial_balance);
    }
}