use dep::std::option::Option;
use dep::aztec::{
  context::Context,
  state_vars::set::Set,
  log::emit_encrypted_log,
};

use dep::protocol_types::address::AztecAddress;

use dep::aztec::note::{
    note_getter_options::{NoteGetterOptions},
    note_getter::{get_notes, view_notes},
};
use dep::aztec::oracle::{
    get_public_key::get_public_key,
};

use crate::agreement_terms_note::{Agreement_Terms, AgreementTermsSerializationMethods, AGREEMENT_TERMS_SERIALIZED_LEN};

struct Agreement_termsSet{
    context: Context,
    owner: AztecAddress,
    set: Set<Agreement_Terms, AGREEMENT_TERMS_SERIALIZED_LEN>
}

impl Agreement_termsSet{

    pub fn new(context: Context, owner: AztecAddress, storage_slot: Field) -> Self {
    assert(storage_slot != 0, "Storage slot 0 not allowed. Storage slots must start from 1.");
    let set = Set {
        context,
        storage_slot,
        note_interface: AgreementTermsSerializationMethods
        };
    Agreement_termsSet {
        context,
        owner,
        set,
        }
    }


    pub fn add(self, AgreementTerms: &mut Agreement_Terms, broadcast: bool) {
        self.set.insert(AgreementTerms, broadcast);

        let context = self.context.private.unwrap();
        let a_contract_address = context.this_address();
        let encryption_pub_key = get_public_key(self.owner); //left out self.owner.address due to new update 17
        let encrypted_data = AgreementTerms.serialize();
        let broadcast = false; //no need to broadcast to L1

        emit_encrypted_log(
                context,
                a_contract_address,
                self.set.storage_slot,
                encryption_pub_key,
                encrypted_data,
        );
    }

    pub fn remove(self: Self, AgreementTerms_id: Field) {
        let options = NoteGetterOptions::new().select(0, AgreementTerms_id).set_limit(1);
        let maybe_notes = self.set.get_notes(options);
        if maybe_notes[0].is_some() {
                let note = maybe_notes[0].unwrap_unchecked();
                self.set.remove(note);
            }
    }

    pub fn get_AgreementTerms(self: Self, AgreementTerms_id: Field) -> Agreement_Terms {
            let options = NoteGetterOptions::new().select(0, AgreementTerms_id).set_limit(1);
            let maybe_notes = self.set.get_notes(options);
            maybe_notes[0].unwrap_unchecked()
        }
}


