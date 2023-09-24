// verify-email.service.ts
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class VerifyEmailService {
  private verifyEmailUrl = 'http://localhost:3000/api/verify-email'; // Update with your API endpoint

  constructor(private http: HttpClient) {}

  verifyEmail(token: string): Observable<any> {
    return this.http.post(this.verifyEmailUrl, { token });
  }
}
