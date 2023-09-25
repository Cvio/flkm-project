import { Injectable } from '@angular/core';
import Web3 from 'web3';

@Injectable({
  providedIn: 'root',
})
export class WalletService {
  private web3: Web3;

  constructor() {
    this.web3 = new Web3(new Web3.providers.HttpProvider('YOUR_ETH_NODE_URL'));
  }

  async getBalance(walletAddress: string): Promise<string> {
    const balanceWei = await this.web3.eth.getBalance(walletAddress);
    const balanceEther = this.web3.utils.fromWei(balanceWei, 'ether');
    return balanceEther;
  }
}
