// dashboard.component.ts

import { Component, OnInit } from '@angular/core';
import { UserService } from '../../../services/User/UserData/user-data.service'; // Import your data service
import { HttpClient } from '@angular/common/http'; // Import HttpClient
import { Router } from '@angular/router'; // Import Router

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css'],
})
export class DashboardComponent implements OnInit {
  userData: any;
  userName: string | undefined;
  userEmail: string | undefined;
  accountBalance: any;
  public noProjects: boolean = false;
  projectData: any;
  projectName: string | undefined;
  description: string | undefined;
  dataset: string | undefined;

  constructor(
    private UserService: UserService,
    private http: HttpClient,
    private router: Router
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
  }
  navigateToUploadResource(): void {
    this.router.navigate(['/upload-resource']); // Use the correct path to your Upload Resource component.
  }

  logout() {
    // Remove the token from localStorage
    localStorage.removeItem('authToken');

    // Use the Router service to navigate to the login page
    this.router.navigate(['/login']); // Replace 'login' with your actual login route
  }
}
