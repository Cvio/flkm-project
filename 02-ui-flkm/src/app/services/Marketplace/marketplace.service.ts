import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ResourceListService } from '../Marketplace/ResourceList/resource-list.service';

@Injectable({
  providedIn: 'root',
})
export class MarketplaceService {
  private baseUrl = 'http://localhost:3000/api/resource-list';

  constructor(private http: HttpClient) {}
}
