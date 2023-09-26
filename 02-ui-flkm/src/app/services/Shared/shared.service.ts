import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class SharedService {
  private selectedDatasetId = new BehaviorSubject<string | null>(null);

  setSelectedDatasetId(id: string): void {
    this.selectedDatasetId.next(id);
  }

  getSelectedDatasetId() {
    return this.selectedDatasetId.asObservable();
  }
}
