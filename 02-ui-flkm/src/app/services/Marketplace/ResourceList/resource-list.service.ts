import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class ResourceListService {
  private apiUrl = 'http://localhost:3000/api'; // Replace with your API endpoint

  constructor(private http: HttpClient) {}

  getResourceList(): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/resource-list`);
  }

  getResources(resourceId: string): Observable<any> {
    return this.http.get(`${this.apiUrl}/fetch-resources/${resourceId}`);
  }
}
