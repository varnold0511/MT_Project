import { expect, jest } from "@jest/globals";
import {
    PXE,
    AccountWallet,
    AztecAddress,
    DebugLogger,
    createDebugLogger,
    createPXEClient,
    ContractFunctionInteraction,
    Fr, CompleteAddress, Point, waitForPXE, sleep, DeployMethod
} from "@aztec/aztec.js";

import { getInitialTestAccountsWallets } from "@aztec/accounts/testing"
//import { fieldToHexString } from "./Trade";


import {TradeContract} from "./fixtures/Trade";

import { mnemonicToAccount } from "viem/accounts";
import {type} from "node:os";



const {
  PXE_URL = "http://localhost:8080",
  ETHEREUM_HOST = "http://localhost:8545",
} = process.env;
const MNEMONIC = "test test test test test test test test test test test junk";
const hdAccount = mnemonicToAccount(MNEMONIC);



describe('TradeContract Tests', () => {
    jest.setTimeout(90_000);

    let logger: DebugLogger;
    let wallet: AccountWallet;
    let wallet2: AccountWallet;
    let tradeContractWallet1: TradeContract;
    let tradeContractWallet2: TradeContract;

    const deployedContractAddress = "0x2ff64cc5775964354160877bcbc680f80e29251f73e30a8501f271f4744e69a3";
    let contractAddress: AztecAddress = AztecAddress.fromString('0x2fd4503a9b855a852272945df53d7173297c1469cceda31048b85118364b09a3'); // Adjust this as per the actual format
    let contractAddress2: AztecAddress = AztecAddress.fromString("0x054ae9af363c6388cc6242c6eb0ed8a5860c15290744c81ecd5109434f9bb8b1");
    let pxe: PXE;

    // Before each test, set up the environment
    beforeEach(async () => {
        logger = createDebugLogger("aztec:canary_uniswap");
        // Create a new wallet instance
        const pxe =  createPXEClient(PXE_URL);
        await waitForPXE(pxe);
        const wallets =  await getInitialTestAccountsWallets(pxe);
        const wallet = wallets[0];
        const wallet2 = wallets[1];
        //wallets that interacts with the smart contract
        tradeContractWallet1 = await TradeContract.at(AztecAddress.fromString("0x2ff64cc5775964354160877bcbc680f80e29251f73e30a8501f271f4744e69a3"), wallet);
        tradeContractWallet2 = await TradeContract.at(AztecAddress.fromString("0x2ff64cc5775964354160877bcbc680f80e29251f73e30a8501f271f4744e69a3"), wallet2);
        logger = logger;
        console.log("Contract deployed");
        console.log("Wallet 1 address is " + wallet.getAddress());
        console.log("Wallet 2 address is " + wallet2.getAddress());
        //console.log("Wallet 2 address is " + wallet2.getAddress().toString());
    });

    it('should store a product', async () => {

        // wallet 1 stores product
        //const supplier1 = AztecAddress.fromString(wallet.getAddress());
        const suppliedProduct = 123n; // Product ID
        const store1 = await tradeContractWallet1.methods.storeProduct(suppliedProduct).send();
        console.log("Stored Product1 " + suppliedProduct);

        // wallet 2 stores product
        //const supplier2 = contractAddress2; // Assuming the supplier's address is the contract address
        const suppliedProduct2 = 456n; // Product ID or information
        const store2 = await tradeContractWallet2.methods.storeProduct(suppliedProduct2).send();
        console.log("Stored Product2 " + suppliedProduct2);

        //time required to proccess the storing
        await sleep(30000)

        //wallet 2 is interested in product supplied by wallet 1
        const Products = await tradeContractWallet2.methods.seeProducts(suppliedProduct).view();
        console.log(Products.suppliedProduct + " : " + Products.supplier);

    });


    it('Send Notes', async () => {

        //wallet 2 demands the product from wallet 1 with following terms:
        const ProductID = 123n;
        const PricePerUnit = 120n;
        const DeliverAmount=  3100n;
        const TotalPrice = 10300n;
        const DeliverDate = 2025n; //new Date('2025-01-01').getTime();
        const randomness = 12n;
        const supplied_by = AztecAddress.fromString("0x2fd4503a9b855a852272945df53d7173297c1469cceda31048b85118364b09a3");

        const AgreementTerms = await tradeContractWallet2.methods.agreement_terms_demanded(ProductID, PricePerUnit,
            DeliverAmount, TotalPrice, DeliverDate, randomness, supplied_by).send();
        console.log("Demander asked " + supplied_by + " for following amount "+ DeliverAmount + " of product " + ProductID + " for " + PricePerUnit  + " per Unit");

        await sleep(60000)

        //wallet 1 access the stored notes to see wether there are some demands
        const Terms1 = await tradeContractWallet2.methods.readDemands(supplied_by).view();
        console.log(Terms1);

    });
});