import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class ModelListService {
  private apiUrl = 'http://localhost:3000/api'; // Replace with your API endpoint
  constructor(private http: HttpClient) {}

  getModelList(): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/model-list`);
  }

  getModelListByOwner(ownerId: string): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/model-list/${ownerId}`);
  }

  getModels(modelId: string): Observable<any> {
    return this.http.get(`${this.apiUrl}/fetch-models/${modelId}`);
  }
}
