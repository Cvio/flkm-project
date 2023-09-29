import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class MarketplaceService {
  private baseUrl = 'http://localhost:3000/api/resource-list';

  constructor(private http: HttpClient) {}

  getResourcesByUsername(username: string): Observable<any> {
    const url = `${this.baseUrl}/${username}`;
    return this.http.get<any>(url);
  }
}
