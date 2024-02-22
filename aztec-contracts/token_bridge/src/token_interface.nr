//import relevant dependencies
use dep::aztec::protocol_types::{abis::function_selector::FunctionSelector, address::{AztecAddress, EthAddress}};
use dep::aztec::{context::{PrivateContext, PublicContext, Context}};

// Me: Helper function "token interface" that refers to a standardized set of rules and functions
// that define how a token behaves within Aztec ecosystem

struct Token {
  address: AztecAddress,
}

// constructs new struct, functions as constructor here
impl Token {
    pub fn at(address: AztecAddress) -> Self {
        Self { address }
    }

    // public function to mint tokens to a specific AztecAddress
    // by taking the ownership of the current `Token` instance (`self`) and the execution context, which is an object
    // that contains all kernel information for execution (more details provedied by Aztec on https://docs.aztec.network/developers/contracts/writing_contracts/functions/context)
    pub fn mint_public(self: Self, context: PublicContext, to: AztecAddress, amount: Field) {
        let _return_values = context.call_public_function(
            self.address,
            FunctionSelector::from_signature("mint_public((Field),Field)"),
            [to.to_field(), amount]
        );
    }

    // public function to burn tokens using similar logic as in the previous function
    // It additionally uses nonce, to ensure that the process occurs only once
    pub fn burn_public(
        self: Self,
        context: PublicContext,
        from: AztecAddress,
        amount: Field,
        nonce: Field
    ) {
        let _return_values = context.call_public_function(
            self.address,
            FunctionSelector::from_signature("burn_public((Field),Field,Field)"),
            [from.to_field(), amount, nonce]
        );
    }

    // Similar to public minting this function mints privatly by taking the secret_hash as an additional input
    pub fn mint_private(self: Self, context: PublicContext, amount: Field, secret_hash: Field) {
        let _return_values = context.call_public_function(
            self.address,
            FunctionSelector::from_signature("mint_private(Field,Field)"),
            [amount, secret_hash]
        );
    }

    pub fn burn(self: Self, context: &mut PrivateContext, from: AztecAddress, amount: Field, nonce: Field) {
        let _return_values = context.call_private_function(
            self.address,
            FunctionSelector::from_signature("burn((Field),Field,Field)"),
            [from.to_field(), amount, nonce]
        );
    }
}