// import { Component, OnInit } from '@angular/core';
// import { UserService } from '../../services/Data/data.service';

// @Component({
//   selector: 'app-user-data',
//   templateUrl: './data.component.html',
//   styleUrls: ['./data.component.css'],
// })
// export class UserDataComponent implements OnInit {
//   userData: any;

//   constructor(private UserService: UserService) {}

//   ngOnInit(): void {
//     // Fetch user data
//     this.UserService.getUserData().subscribe(
//       (data) => {
//         this.userData = data;
//         // Handle the received user data
//       },
//       (error) => {
//         console.error('Error fetching user data:', error);
//         // Handle any errors that may occur during the request.
//       }
//     );
//   }
// }
