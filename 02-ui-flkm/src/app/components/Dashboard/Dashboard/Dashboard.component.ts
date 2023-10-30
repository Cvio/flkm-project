// dashboard.component.ts

import { Component, OnInit } from '@angular/core';
import { UserService } from '../../../services/User/UserData/user-data.service'; // Import your data service
import { HttpClient } from '@angular/common/http'; // Import HttpClient
import { Router } from '@angular/router'; // Import Router
import { Web3Service } from '../../../services/Web3/web3.service'; // Import Web3Service

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css'],
})
export class DashboardComponent implements OnInit {
  userData: any;
  userName: string | undefined;
  userEmail: string | undefined;
  userReputation: any;
  accountBalance: any;
  public noProjects: boolean = false;
  projectData: any;
  projectName: string | undefined;
  description: string | undefined;
  dataset: string | undefined;

  constructor(
    private UserService: UserService,
    private http: HttpClient,
    private router: Router,
    private web3Service: Web3Service
  ) {}

  ngOnInit(): void {
    this.UserService.getUserData().subscribe(
      (response) => {
        console.log('Response:', response);

        // Access the userData and userProjects properties of the response object.
        this.userData = response.userData;
        this.userName = this.userData.username;
        this.userEmail = this.userData.email;
        this.accountBalance = this.userData.hbarBalance;
        this.fetchUserReputation();

        this.projectData = response.userProjects;
        if (this.projectData && this.projectData.length > 0) {
          this.projectName = this.projectData[0].projectName;
          this.description = this.projectData[0].description;
          this.dataset = this.projectData[0].dataset;
          // You may want to handle multiple projects here.
        }
      },
      (error) => {
        console.error('Error fetching user data:', error);
      }
    );
    // Fetch user reputation
    const userAddress = '0xeB6B42BFA9BCB83a72453AA2ef4D414BB9848b08';
  }
  navigateToUploadResource(): void {
    this.router.navigate(['/upload-resource']); // Use the correct path to your Upload Resource component.
  }
  navigateToModelUpload(): void {
    this.router.navigate(['/model-upload']); // Use the correct path to your Model Upload component.
  }
  navigateToModelList(): void {
    this.router.navigate(['/model-list']); // Use the correct path to your Model List component.
  }
  navigateToMarketplace(): void {
    this.router.navigate(['/marketplace']); // Navigate to Marketplace. Adjust the path as per your routing configuration.
  }

  createProject(): void {
    // This function will be called when the button is clicked.
    // Add logic here to initiate the project creation process.
    console.log('Button clicked! Start project creation.');
    this.router.navigate(['/create-project']);
  }
  async fetchUserReputation() {
    try {
      const accounts = await this.web3Service.getAccounts();
      const userAddress = '0xeB6B42BFA9BCB83a72453AA2ef4D414BB9848b08';
      // const userAddress = accounts[0]; // Assuming the user's address is the first one
      const contract = this.web3Service.contract;

      // Call the smart contract function
      const reputation = await contract.methods
        .showUserReputationLevel(userAddress)
        .call();

      // Map the BigInt to the corresponding enum string
      this.userReputation = this.mapReputationToLevel(Number(reputation));
    } catch (error) {
      console.error('Error fetching user reputation:', error);
      this.userReputation = 'Error fetching reputation';
    }
  }

  mapReputationToLevel(reputation: number): string {
    const levels = [
      'Supplicant',
      'Initiate',
      'Mystic',
      'Luminary',
      'Oracle',
      'Prophet',
    ];
    return levels[reputation] || 'Unknown';
  }

  logout() {
    // Remove the token from localStorage
    localStorage.removeItem('authToken');

    // Use the Router service to navigate to the login page
    this.router.navigate(['/login']); // Replace 'login' with your actual login route
  }
}
