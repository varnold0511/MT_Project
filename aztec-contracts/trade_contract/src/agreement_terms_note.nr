use dep::aztec::{
    note::{note_header::NoteHeader, note_interface::NoteInterface, utils::compute_note_hash_for_consumption},
    oracle::{nullifier_key::get_nullifier_secret_key, get_public_key::get_public_key},
    log::emit_encrypted_log, hash::pedersen_hash, context::PrivateContext,
    protocol_types::{address::AztecAddress, traits::Empty}
};

global AGREEMENT_TERMS_SERIALIZED_LEN: Field = 9;

struct Agreement_Terms{
    ProductID: Field,
    PricePerUnit: Field,
    DeliverAmount: Field,
    TotalPrice: Field,
    DeliverDate: Field,
    randomness: Field,
    owner: AztecAddress,
    supplied_by: AztecAddress,
    demanded_by:AztecAddress,
    header: NoteHeader,
    }

impl Agreement_Terms{
    pub fn new(
        ProductID: Field,
        PricePerUnit: Field,
        DeliverAmount: Field,
        TotalPrice: Field,
        DeliverDate: Field,
        randomness: Field,
        owner: AztecAddress,
        supplied_by: AztecAddress,
        demanded_by: AztecAddress
    ) -> Self {
        Agreement_Terms {
            ProductID,
            PricePerUnit,
            DeliverAmount,
            TotalPrice,
            DeliverDate,
            randomness,
            owner,
            supplied_by,
            demanded_by,
            header: NoteHeader::empty()
            }
        }
    }

impl NoteInterface<AGREEMENT_TERMS_SERIALIZED_LEN> for Agreement_Terms {

        fn serialize_content(self) -> [Field; AGREEMENT_TERMS_SERIALIZED_LEN]{
            [self.ProductID as Field,
            self.PricePerUnit as Field,
            self.DeliverAmount as Field,
            self.TotalPrice as Field,
            self.DeliverDate as Field,
            self.randomness as Field,
            self.owner.to_field(),
            self.supplied_by.to_field(),
            self.demanded_by.to_field()]
        }

        fn deserialize_content(serialized_note: [Field; AGREEMENT_TERMS_SERIALIZED_LEN]) -> Self {
            Agreement_Terms {
            ProductID: serialized_note[0],
            PricePerUnit: serialized_note[1],
            DeliverAmount: serialized_note[2],
            TotalPrice: serialized_note[3],
            DeliverDate: serialized_note[4],
            randomness: serialized_note[5],
            owner: AztecAddress::from_field(serialized_note[6]),
            supplied_by: AztecAddress::from_field(serialized_note[7]),
            demanded_by: AztecAddress::from_field(serialized_note[8]),
            header: NoteHeader::empty()
            }
        }

        fn compute_note_content_hash(self) -> Field {
            pedersen_hash(self.serialize_content(), 0)
        }

        //In addition to deriving encryption keys, the privacy master key is used for deriving nullifier secrets.
        //Whenever a private note is consumed, a nullifier deterministically derived from it is emitted
        //Now, in order to preserve privacy, a third party should not be able to link a note commitment to its nullifier - this link is enforced by the note implementation.
        //Therefore, calculating the nullifier for a note requires a secret from its owner.

        fn compute_nullifier(self, context: &mut PrivateContext) -> Field {
            let note_hash_for_nullify = compute_note_hash_for_consumption(self);
            let secret = context.request_nullifier_secret_key(self.owner);
            pedersen_hash([
                note_hash_for_nullify,
                secret.low,
                secret.high,
            ],0)
        }

        fn compute_nullifier_without_context(self) -> Field {
            let note_hash_for_nullify = compute_note_hash_for_consumption(self);
            let secret = get_nullifier_secret_key(self.owner);
            pedersen_hash([
                note_hash_for_nullify,
                secret.high,
                secret.low,
            ],0)
        }


        fn set_header(&mut self, header: NoteHeader) {
            self.header = header;
        }

        fn get_header(note: Agreement_Terms) -> NoteHeader {
            note.header
        }

        // Broadcasts the note as an encrypted log on L1.
        fn broadcast(self, context: &mut PrivateContext, slot: Field) {
            let encryption_pub_key = get_public_key(self.owner);
            emit_encrypted_log(
                context,
                (*context).this_address(),
                slot,
                Self::get_note_type_id(),
                encryption_pub_key,
                self.serialize_content(),
            );
        }

        fn get_note_type_id() -> Field {
            // TODO(#4519): autogenerate
            // python -c "print(int(''.join(str(ord(c)) for c in 'Agreement_Terms')))"
            651031141011011091011101169584101114109115
        }
}