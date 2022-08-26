#[test_only]
/// Helpers for creating and managing accounts.
module aptest::acct {
    use std::signer;

    use aptos_framework::aptos_account;
    use aptos_framework::aptos_coin;
    use aptos_framework::system_addresses;

    /// Creates and funds an account.
    public entry fun create_for(
        framework: &signer,
        recipient_addr: address,
        amount: u64
    ) {
        system_addresses::assert_aptos_framework(framework);
        aptos_account::create_account(recipient_addr);
        if (amount > 0) {
            aptos_coin::mint(framework, recipient_addr, amount);
        };
    }

    /// Creates and funds an account.
    public entry fun create(
        framework: &signer,
        recipient: &signer,
        initial_balance: u64
    ) {
        create_for(framework, signer::address_of(recipient), initial_balance);
    }
}