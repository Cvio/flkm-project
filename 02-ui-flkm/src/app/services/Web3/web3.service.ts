import { Injectable } from '@angular/core';
import Web3 from 'web3';

const contractArtifact = require('../../../../../build/contracts/ReputationNFT.json');

// smart contract ABI and address
const contractABI = contractArtifact.abi;

interface Window {
  ethereum?: any;
  web3?: any;
}

declare var window: Window;

@Injectable({
  providedIn: 'root',
})
export class Web3Service {
  public web3: Web3;
  //private contractAddress = '0xcFD44D960dFEE1B202CF9915b4350E856E81752f'; // Replace with your contract address
  private contractAddress = '0xF6A99e00959191ea6461025Fc0839aEd8ce93D21';
  private account: any[0] = '0xeB6B42BFA9BCB83a72453AA2ef4D414BB9848b08'; // Replace with your account address
  public contract: any;

  constructor() {
    if (window.ethereum) {
      this.web3 = new Web3(window.ethereum);
    } else if (window.web3) {
      this.web3 = new Web3(window.web3.currentProvider);
    } else {
      this.web3 = new Web3(Web3.givenProvider || 'ws://127.0.0.1:7545');
    }

    this.contract = new this.web3.eth.Contract(
      contractABI,
      this.contractAddress
    );
  }

  async getAccounts(): Promise<string[]> {
    return await this.web3.eth.getAccounts();
  }

  // New method to get contract instance
  getContractInstance(): any {
    return this.contract;
  }
  async mintNFT(userAddress: string, tokenURI: string): Promise<void> {
    const accounts = await this.getAccounts();
    const contract = this.getContractInstance();

    try {
      await contract.methods
        .mintNFT(userAddress, tokenURI)
        .send({ from: accounts[0] });
      console.log('NFT minted successfully');
    } catch (error) {
      console.error('Error minting NFT:', error);
    }
  }
  async fetchTokenURI(userAddress: string): Promise<string> {
    const contract = this.getContractInstance();
    try {
      const tokenId = await contract.methods
        .showUserReputationLevel(userAddress)
        .call();
      const tokenURI = await contract.methods.tokenURI(tokenId).call();
      return tokenURI;
    } catch (error) {
      console.error('Error fetching token URI:', error);
      return '';
    }
  }
}
