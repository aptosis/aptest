/// Helpers for creating accounts.

module aptest::account {
    use Std::Signer;

    use AptosFramework::Account;
    use AptosFramework::Coin;
    use AptosFramework::TestCoin::{Self, TestCoin};
    use AptosFramework::SystemAddresses;

    /// Mint/burn capabilities for TestCoin. Not needed.
    struct Trash has key {
        mint_cap: Coin::MintCapability<TestCoin>,
        burn_cap: Coin::BurnCapability<TestCoin>,
    }

    /// Initializes [TestCoin].
    public fun prepare(
        resources: &signer,
        framework: &signer,
    ) {
        SystemAddresses::assert_core_resource(resources);
        SystemAddresses::assert_core_framework(framework);
        let (mint_cap, burn_cap) = TestCoin::initialize(framework, resources);
        move_to(resources, Trash {
            mint_cap,
            burn_cap,
        });
    }

    /// Creates and funds an account.
    public(script) fun create(
        resources: &signer,
        recipient_addr: address,
        amount: u64
    ) {
        SystemAddresses::assert_core_resource(resources);
        Account::create_account(recipient_addr);
        if (amount > 0) {
            TestCoin::mint(resources, recipient_addr, amount);
        };
    }

    /// Creates and funds an account.
    public(script) fun setup(
        resources: &signer,
        recipient: &signer,
        initial_balance: u64
    ) {
        create(resources, Signer::address_of(recipient), initial_balance);
    }
}