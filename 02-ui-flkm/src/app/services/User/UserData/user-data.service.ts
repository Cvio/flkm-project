import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Router, RouterLink } from '@angular/router';
import { map } from 'rxjs/operators';
import Web3 from 'web3';
import { Web3Service } from '../../Web3/web3.service';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  private web3: Web3; // Web3 instance
  private contract: any; // contract variable

  constructor(
    private http: HttpClient,
    private router: Router,
    private web3Service: Web3Service
  ) {
    this.web3 = new Web3(Web3.givenProvider || 'ws://127.0.0.1:7545');
    // import smart contract
    const contractArtifact = require('../../../../../../build/contracts/ReputationNFT.json');
    // smart contract ABI and address
    const contractABI = contractArtifact.abi;
    const contractAddress = '0xcFD44D960dFEE1B202CF9915b4350E856E81752f';
    this.contract = new this.web3.eth.Contract(contractABI, contractAddress);
  }

  getUserData(): Observable<any> {
    // Retrieve the token from localStorage
    const token = localStorage.getItem('authToken');

    // Add the token to the request headers
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`, // attach the token as a Bearer token
    });

    // make an authenticated request to the /user-data endpoint
    return this.http.get<any>('http://localhost:3000/api/user-data', {
      headers,
    });
  }

  // Define a new method in your user-data.service.ts
  getCurrentUserId(): Observable<string | undefined> {
    return this.getUserData().pipe(
      map((response) => {
        console.log('UserData:', response); // Log the entire response object.
        console.log('User Id from response:', response.userData?._id); // Log the _id from the nested userData object.
        return response.userData?._id; // Accessing _id from the nested userData object.
      })
    );
  }

  getProjectData(): Observable<any> {
    // Retrieve the token from localStorage
    const token = localStorage.getItem('authToken');

    // Add the token to the request headers
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`, // attach the token as a Bearer token
    });

    return this.http.get<any>('http://localhost:3000/api/user-projects');
  }
  // async fetchUserReputation(userAddress: string): Promise<any> {
  //   return await this.contract.methods
  //     .showUserReputationLevel(userAddress)
  //     .call();
  // }

  // New method to fetch user reputation from blockchain
  async fetchUserReputation(userAddress: string): Promise<any> {
    const contract = await this.web3Service.getContractInstance(); // Assuming you have a method to get contract instance
    return await contract.methods.showUserReputationLevel(userAddress).call();
  }

  async mintNFT(cid: string): Promise<boolean> {
    try {
      const accounts = await this.web3Service.getAccounts();
      const userAddress = accounts[0]; // Assuming the user's address is the first one
      const contract = this.web3Service.getContractInstance();

      // Call the smart contract function to mint the NFT
      // Replace 'mintNFT' with the actual function name in your smart contract
      // and add any additional arguments that the function requires
      await contract.methods
        .mintNFT(userAddress, cid)
        .send({ from: userAddress });

      return true;
    } catch (error) {
      console.error('Error minting NFT:', error);
      return false;
    }
  }

  logOut() {
    localStorage.removeItem('authToken');
    this.router.navigate(['/api/login']);
  }
}
