import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class ModelUploadService {
  private apiUrl = 'http://localhost:3000/api/models/upload'; // Replace with your API URL

  constructor(private http: HttpClient) {}

  uploadModel(formData: FormData): Observable<any> {
    return this.http.post<any>(this.apiUrl, formData);
  }
}
