import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class RegistrationService {
  private readonly BASE_URL = 'http://localhost:3000';

  constructor(private http: HttpClient) {}

  registerUser(userData: {
    username: string;
    email: string;
    password: string;
  }): Observable<any> {
    return this.http.post(`${this.BASE_URL}/register`, userData);
  }
}
