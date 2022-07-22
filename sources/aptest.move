#[test_only]
/// Testing utilities for Aptos programs.
/// 
/// For examples, [read the tests](tests/).
module aptest::aptest {
    use aptos_framework::coin;
    use aptos_framework::test_coin;
    use aptos_framework::system_addresses;

    /// Sets up the aptest testing framework.
    public fun setup(
        resources: &signer,
        framework: &signer,
    ) {
        system_addresses::assert_core_resource(resources);
        system_addresses::assert_aptos_framework(framework);
        let (mint_cap, burn_cap) = test_coin::initialize(framework, resources);
        coin::destroy_mint_cap(mint_cap);
        coin::destroy_burn_cap(burn_cap);
    }
}