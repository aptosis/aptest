/// Defines assertions.

module aptest::check {
    use Std::ASCII;
    use Std::Signer;
    use Std::Debug;

    use AptosFramework::Coin;

    const EASSERT_EQ: u64 = 1;
    const EASSERT_BORROW_EQ: u64 = 2;

    public fun log(v: vector<u8>) {
        Debug::print(&ASCII::string(v));
    }

    public fun eq_address(a: &signer, b: address) {
        eq(Signer::address_of(a), b);
    }

    /// Checks two values are equal.
    ///
    /// TODO(igm): support custom errors
    public fun eq<T: copy + drop>(a: T, b: T) {
        if (a != b) {
            // TODO: remove when [Debug::print] supports strings
            // see: <https://github.com/move-language/move/pull/277/files>
            Debug::print(&@0xDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEAD);

            log(b"Assertion failed");
            log(b"Left:");
            Debug::print(&a);
            log(b"Right:");
            Debug::print(&b);
            Debug::print_stack_trace();
            abort EASSERT_EQ
        };
    }

    public fun borrow_eq<T>(a: &T, b: &T) {
        if (a != b) {
            // TODO: remove when [Debug::print] supports strings
            // see: <https://github.com/move-language/move/pull/277/files>
            Debug::print(&@0xDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEAD);

            log(b"Borrow assertion failed");
            log(b"Left:");
            Debug::print(a);
            log(b"Right:");
            Debug::print(b);
            Debug::print_stack_trace();
            abort EASSERT_BORROW_EQ
        };
    }

    public fun address_balance<CoinType>(user: address, amount: u64) {
        eq(Coin::balance<CoinType>(user), amount);
    }

    public fun balance<CoinType>(user: &signer, amount: u64) {
        address_balance<CoinType>(Signer::address_of(user), amount);
    }
}
