#[test_only]
/// Testing utilities for Aptos programs.
/// 
/// For examples, [read the tests](tests/).
module aptest::aptest {
    use aptos_framework::account;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin;
    use aptos_framework::system_addresses;

    struct Aptest has key {
        signer_cap: account::SignerCapability,
    }

    /// Sets up the aptest testing framework.
    public fun setup(
        resources: &signer,
        framework: &signer,
    ) {
        system_addresses::assert_core_resource(resources);
        system_addresses::assert_aptos_framework(framework);
        let (mint_cap, burn_cap) = aptos_coin::initialize(framework, resources);
        coin::destroy_mint_cap(mint_cap);
        coin::destroy_burn_cap(burn_cap);

        let (aptest, signer_cap) = account::create_resource_account(
            resources,
            b"aptest",
        );
        // derive the aptest address
        // std::debug::print(&std::signer::address_of(&aptest));
        move_to(&aptest, Aptest {
            signer_cap,
        });
    }

    /// Gets the signer for the `@aptest` address.
    public fun get_signer(): signer acquires Aptest {
        account::create_signer_with_capability(
            &borrow_global<Aptest>(@aptest).signer_cap
        )
    }
}