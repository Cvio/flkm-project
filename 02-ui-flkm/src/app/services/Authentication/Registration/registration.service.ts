import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class RegistrationService {
  // update registrationUrl to match your API endpoint
  private registrationUrl = 'http://localhost:3000/register';

  constructor(private http: HttpClient) {}

  registerUser(userData: any): Observable<any> {
    const headers = new HttpHeaders({ 'Content-Type': 'application/json' });
    return this.http.post(this.registrationUrl, userData, { headers });
  }
}
