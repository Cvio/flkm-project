import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Router, RouterLink } from '@angular/router';
import { map } from 'rxjs/operators';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  constructor(private http: HttpClient, private router: Router) {}

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

  logOut() {
    localStorage.removeItem('authToken');
    this.router.navigate(['/api/login']);
  }
}
