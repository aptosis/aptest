#[test_only]
module aptest::examples {
    use aptos_framework::account;
    use aptos_framework::aptos_coin::AptosCoin;

    use aptest::aptest;
    use aptest::acct;
    use aptest::check;

    #[test(
        framework = @aptos_framework,
        sender = @0xa11ce
    )]
    /// Test sending coins and initializing an account
    public entry fun test_create_account(
        framework: signer,
        sender: signer
    ) {
        aptest::setup(&framework);
        acct::create(&framework, &sender, 1000);

        // account should not exist initially
        assert!(!account::exists_at(@0xb0b), 1);

        acct::create_for(&framework, @0xb0b, 1000);

        // balance should now be 1000
        check::address_balance<AptosCoin>(@0xb0b, 1000);
    }

    #[test]
    #[expected_failure(abort_code = 1)]
    public entry fun test_fail() {
        check::eq(1, 2);
    }
}