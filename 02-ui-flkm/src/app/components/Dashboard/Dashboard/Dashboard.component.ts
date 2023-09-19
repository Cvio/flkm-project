// dashboard.component.ts

import { Component, OnInit } from '@angular/core';
import { DataService } from '../../../services/Data/data.service'; // Import your data service
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

  projectData: any;
  projectName: string | undefined;
  description: string | undefined;
  dataset: string | undefined;

  constructor(
    private dataService: DataService,
    private http: HttpClient,
    private router: Router
  ) {}

  ngOnInit(): void {
    // Retrieve user data from the backend

    this.dataService.getUserData().subscribe((data) => {
      console.log('Response Data:', data);
      this.userData = data;
      this.userName = this.userData.username;
      this.userEmail = this.userData.email;
      this.accountBalance = this.userData.hbarBalance;
    });

    this.dataService.getProjectData().subscribe((data) => {
      console.log('Response Data:', data);
      this.projectData = data;
      this.projectName = this.projectData[0].projectName;
      this.description = this.projectData[0].description;
      this.dataset = this.projectData[0].dataset;
    });
  }

  logout() {
    // Remove the token from localStorage
    localStorage.removeItem('authToken');

    // Use the Router service to navigate to the login page
    this.router.navigate(['/login']); // Replace 'login' with your actual login route
  }
}
