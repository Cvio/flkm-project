// model-list.component.ts

import { Component, OnInit } from '@angular/core';
import { ModelListService } from '../../../services/Model/ModelList/model-list.service';
import { MatDialog } from '@angular/material/dialog';
import { ModelUploadComponent } from '../ModelUpload/model-upload.component';
import { UserService } from '../../../services/User/UserData/user-data.service';
import { SharedService } from '../../../services/Shared/shared.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-model-list',
  templateUrl: './model-list.component.html',
  styleUrls: ['./model-list.component.css'],
})
export class ModelListComponent implements OnInit {
  public models: any[] = [];
  public error: string | null = null;

  constructor(
    private modelListService: ModelListService,
    public dialog: MatDialog,
    private userService: UserService,
    private sharedService: SharedService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.userService.getCurrentUserId().subscribe(
      (ownerId) => {
        if (ownerId) {
          this.loadModelsByOwnerId(ownerId); // Call the loadModelsByOwnerId method with the received ownerId.
        } else {
          console.error('ownerId is undefined');
        }
      },
      (error) => {
        console.error('Error getting user ID:', error);
      }
    );
  }

  loadModelsByOwnerId(ownerId: string): void {
    this.modelListService.getModelListByOwner(ownerId).subscribe(
      (metadata) => {
        this.models = metadata;
      },
      (error) => {
        console.error('Error fetching models:', error);
      }
    );
  }

  onModelSelected(modelName: string): void {
    this.sharedService.setSelectedModelId(modelName);
    this.router.navigate(['/create-project']);
  }

  applyFilter(filterType: string): void {
    switch (filterType) {
      case 'popular':
        this.sortModelsByPopularity();
        break;
      case 'recent':
        this.sortModelsByRecent();
        break;
      // Add more cases here
      default:
        break;
    }
  }

  sortModelsByPopularity(): void {
    this.models.sort((a, b) => b.popularity - a.popularity);
  }

  sortModelsByRecent(): void {
    this.models.sort((a, b) => {
      const dateA = new Date(a.createdAt).getTime();
      const dateB = new Date(b.createdAt).getTime();
      console.log(`Date A: ${dateA}, Date B: ${dateB}`);
      return dateB - dateA;
    });
    console.log('Sorted models:', this.models);
  }

  onSortOptionChange(event: Event): void {
    const target = event.target as HTMLSelectElement;
    const value = target.value;
    this.applyFilter(value);
  }
}
