#[test_only]
module aptest::examples {
    use aptos_framework::account;
    use aptos_framework::test_coin::TestCoin;

    use aptest::acct;
    use aptest::check;

    #[test(
        resources = @core_resources,
        framework = @aptos_framework,
        sender = @0xa11ce
    )]
    /// Test sending coins and initializing an account
    public entry fun test_create_account(
        resources: signer,
        framework: signer,
        sender: signer
    ) {
        acct::prepare(&resources, &framework);
        acct::setup(&resources, &sender, 1000);

        // account should not exist initially
        assert!(!account::exists_at(@0xb0b), 1);

        acct::create(&resources, @0xb0b, 1000);

        // balance should now be 1000
        check::address_balance<TestCoin>(@0xb0b, 1000);
    }

    #[test]
    #[expected_failure(abort_code = 1)]
    public entry fun test_fail() {
        check::eq(1, 2);
    }
}