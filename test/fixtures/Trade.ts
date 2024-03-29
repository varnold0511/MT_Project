
/* Autogenerated file, do not edit! */

/* eslint-disable */
import {
  AztecAddress,
  AztecAddressLike,
  CompleteAddress,
  Contract,
  ContractArtifact,
  ContractBase,
  ContractFunctionInteraction,
  ContractInstanceWithAddress,
  ContractMethod,
  DeployMethod,
  EthAddress,
  EthAddressLike,
  FieldLike,
  Fr,
  FunctionSelectorLike,
  loadContractArtifact,
  NoirCompiledContract,
  Point,
  PublicKey,
  Wallet,
  WrappedFieldLike,
} from '@aztec/aztec.js';
import TradeContractArtifactJson from '../../../aztec-contracts/trade_contract/target/Trade-Trade.json' assert { type: 'json' };
export const TradeContractArtifact = loadContractArtifact(TradeContractArtifactJson as NoirCompiledContract);

/**
 * Type-safe interface for contract Trade;
 */
export class TradeContract extends ContractBase {
  
  private constructor(
    instance: ContractInstanceWithAddress,
    wallet: Wallet,
  ) {
    super(instance, TradeContractArtifact, wallet);
  }
  

  
  /**
   * Creates a contract instance.
   * @param address - The deployed contract's address.
   * @param wallet - The wallet to use when interacting with the contract.
   * @returns A promise that resolves to a new Contract instance.
   */
  public static async at(
    address: AztecAddress,
    wallet: Wallet,
  ) {
    return Contract.at(address, TradeContract.artifact, wallet) as Promise<TradeContract>;
  }

  
  /**
   * Creates a tx to deploy a new instance of this contract.
   */
  public static deploy(wallet: Wallet, ) {
    return new DeployMethod<TradeContract>(Point.ZERO, wallet, TradeContractArtifact, TradeContract.at, Array.from(arguments).slice(1));
  }

  /**
   * Creates a tx to deploy a new instance of this contract using the specified public key to derive the address.
   */
  public static deployWithPublicKey(publicKey: PublicKey, wallet: Wallet, ) {
    return new DeployMethod<TradeContract>(publicKey, wallet, TradeContractArtifact, TradeContract.at, Array.from(arguments).slice(2));
  }
  

  
  /**
   * Returns this contract's artifact.
   */
  public static get artifact(): ContractArtifact {
    return TradeContractArtifact;
  }
  

  /** Type-safe wrappers for the public methods exposed by the contract. */
  public methods!: {
    
    /** readDemands(address: struct) */
    readDemands: ((address: AztecAddressLike) => ContractFunctionInteraction) & Pick<ContractMethod, 'selector'>;

    /** compute_note_hash_and_nullifier(contract_address: struct, nonce: field, storage_slot: field, note_type_id: field, serialized_note: array) */
    compute_note_hash_and_nullifier: ((contract_address: AztecAddressLike, nonce: FieldLike, storage_slot: FieldLike, note_type_id: FieldLike, serialized_note: FieldLike[]) => ContractFunctionInteraction) & Pick<ContractMethod, 'selector'>;

    /** constructor() */
    constructor: (() => ContractFunctionInteraction) & Pick<ContractMethod, 'selector'>;

    /** storeProduct(suppliedProduct: field) */
    storeProduct: ((suppliedProduct: FieldLike) => ContractFunctionInteraction) & Pick<ContractMethod, 'selector'>;

    /** agreement_terms_demanded(ProductID: field, PricePerUnit: field, DeliverAmount: field, TotalPrice: field, DeliverDate: field, randomness: field, supplied_by: struct) */
    agreement_terms_demanded: ((ProductID: FieldLike, PricePerUnit: FieldLike, DeliverAmount: FieldLike, TotalPrice: FieldLike, DeliverDate: FieldLike, randomness: FieldLike, supplied_by: AztecAddressLike) => ContractFunctionInteraction) & Pick<ContractMethod, 'selector'>;

    /** seeProducts(suppliedProduct: field) */
    seeProducts: ((suppliedProduct: FieldLike) => ContractFunctionInteraction) & Pick<ContractMethod, 'selector'>;
  };
}
