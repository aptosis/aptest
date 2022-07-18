#[test_only]
module aptest::examples {
    use AptosFramework::Account;
    use AptosFramework::TestCoin::TestCoin;

    use aptest::account;
    use aptest::check;

    #[test(
        resources = @CoreResources,
        framework = @AptosFramework,
        sender = @0xa11ce
    )]
    /// Test sending coins and initializing an account
    public(script) fun test_create_account(
        resources: signer,
        framework: signer,
        sender: signer
    ) {
        account::prepare(&resources, &framework);
        account::setup(&resources, &sender, 1000);

        // account should not exist initially
        assert!(!Account::exists_at(@0xb0b), 1);

        account::create(&resources, @0xb0b, 1000);

        // balance should now be 1000
        check::address_balance<TestCoin>(@0xb0b, 1000);
    }

    #[test]
    #[expected_failure(abort_code = 1)]
    public(script) fun test_fail() {
        check::eq(1, 2);
    }
}