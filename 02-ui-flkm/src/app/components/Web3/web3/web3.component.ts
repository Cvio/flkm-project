import { Component, OnInit } from '@angular/core';
import { Web3Service } from '../../../services/Web3/web3.service';

@Component({
  selector: 'app-web3',
  templateUrl: './web3.component.html',
  styleUrls: ['./web3.component.css'],
})
export class Web3Component implements OnInit {
  public account!: string;

  constructor(private web3Service: Web3Service) {}

  async ngOnInit(): Promise<void> {
    const accounts = await this.web3Service.getAccounts();
    this.account = accounts[0];
  }
}
