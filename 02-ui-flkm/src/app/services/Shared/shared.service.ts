import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class SharedService {
  private selectedDatasetId = new BehaviorSubject<string | null>(null);
  private selectedModelId = new BehaviorSubject<string | null>(null);

  setSelectedDatasetId(id: string): void {
    this.selectedDatasetId.next(id);
  }

  getSelectedDatasetId() {
    return this.selectedDatasetId.asObservable();
  }
  setSelectedModelId(id: string): void {
    this.selectedModelId.next(id);
  }

  getSelectedModelId() {
    return this.selectedModelId.asObservable();
  }
}
