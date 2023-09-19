// project.service.ts
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class ProjectService {
  private baseUrl = 'http://localhost:3000'; // Replace with your API base URL

  constructor(private http: HttpClient) {}

  // Define the createProject method
  createProject(projectData: any): Observable<any> {
    const headers = new HttpHeaders({ 'Content-Type': 'application/json' });
    return this.http.post(`${this.baseUrl}/create-project`, projectData, {
      headers,
    });
  }

  // Add more methods for other project-related operations as needed
}
