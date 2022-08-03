#[test_only]
/// Helpers for creating and managing accounts.
module aptest::acct {
    use std::signer;

    use aptos_framework::account;
    use aptos_framework::aptos_coin;
    use aptos_framework::system_addresses;

    /// Creates and funds an account.
    public entry fun create_for(
        resources: &signer,
        recipient_addr: address,
        amount: u64
    ) {
        system_addresses::assert_core_resource(resources);
        account::create_account(recipient_addr);
        if (amount > 0) {
            aptos_coin::mint(resources, recipient_addr, amount);
        };
    }

    /// Creates and funds an account.
    public entry fun create(
        resources: &signer,
        recipient: &signer,
        initial_balance: u64
    ) {
        create_for(resources, signer::address_of(recipient), initial_balance);
    }
}