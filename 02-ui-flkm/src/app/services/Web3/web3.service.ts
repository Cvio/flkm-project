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
  private contractAddress = '0xcFD44D960dFEE1B202CF9915b4350E856E81752f'; // Replace with your contract address
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
}
