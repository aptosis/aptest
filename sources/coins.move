#[test_only]
/// Helpers for coins.
module aptest::coins {
    use aptos_framework::coin;
    use aptos_framework::string;
    use aptos_framework::type_info;

    use aptest::aptest;

    /// Random structs which can be used for testing coins.
    struct A { }
    struct B { }
    struct C { }
    struct D { }
    struct E { }
    struct F { }

    struct CapabilityStore<phantom CoinType> has key {
        mint_cap: coin::MintCapability<CoinType>,
        burn_cap: coin::BurnCapability<CoinType>,
    }

    /// Initializes a coin.
    public entry fun initialize<CoinType>() {
        let (mint_cap, burn_cap) = coin::initialize<CoinType>(
            &aptest::get_signer(),
            string::utf8(type_info::struct_name(&type_info::type_of<CoinType>())),
            string::utf8(type_info::struct_name(&type_info::type_of<CoinType>())),
            1,
            false,
        );
        move_to(&aptest::get_signer(), CapabilityStore {
            mint_cap,
            burn_cap,
        });
    }

    /// Mints coins.
    public entry fun mint_to<CoinType>(to: address, amount: u64) acquires CapabilityStore {
        let mint_cap = &borrow_global<CapabilityStore<CoinType>>(@aptest).mint_cap;
        coin::deposit(to, coin::mint<CoinType>(amount, mint_cap));
    }
}