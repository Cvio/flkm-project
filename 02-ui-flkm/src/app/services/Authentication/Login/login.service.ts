import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { Router } from '@angular/router';

@Injectable({
  providedIn: 'root',
})
export class LoginService {
  // Update loginUrl to match your API endpoint for login
  private loginUrl = 'http://localhost:3000/login';

  constructor(private http: HttpClient, private router: Router) {}

  loginUser(userData: any): Observable<any> {
    const headers = new HttpHeaders({ 'Content-Type': 'application/json' });
    return this.http.post(this.loginUrl, userData, { headers }).pipe(
      map((response: any) => {
        this.router.navigate(['/dashboard']);

        return response;
      })
    );
  }
}
