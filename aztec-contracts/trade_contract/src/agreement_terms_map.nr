use dep::aztec::context::{PrivateContext, PublicContext, Context};
use dep::aztec::protocol_types::address::AztecAddress;
use dep::std::option::Option;
use dep::aztec::hash::pedersen_hash;

use crate::agreement_terms_set::Agreement_termsSet;

struct AgreementTermsMap{
    context: Context,
    storage_slot: Field,
}

impl AgreementTermsMap{
    pub fn new(
        context: Context,
        storage_slot: Field,
    ) -> Self {
        assert(storage_slot != 0, "Storage slot 0 not allowed. Storage slots must start from 1.");
        Self {
            context,
            storage_slot,
        }
    }

    // allow changes in ownership?
    pub fn at(self, owner: AztecAddress) -> Agreement_termsSet{
        let derived_storage_slot = self.slot_for(owner);
        Agreement_termsSet::new(self.context, owner, derived_storage_slot)
    }

    pub fn slot_for(self, owner: AztecAddress) -> Field {
        pedersen_hash([self.storage_slot, owner.to_field()], 0)
    }
}