import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class UploadResourceService {
  private apiUrl = 'http://localhost:3000/api'; // Replace with your API endpoint

  constructor(private http: HttpClient) {}

  uploadResource(formData: FormData): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/upload-resource`, formData);
  }
}
