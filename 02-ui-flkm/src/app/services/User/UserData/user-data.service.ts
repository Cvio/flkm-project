import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Router, RouterLink } from '@angular/router';

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