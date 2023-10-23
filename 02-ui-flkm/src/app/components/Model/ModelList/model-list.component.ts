// model-list.component.ts

import { Component, OnInit } from '@angular/core';
import { ModelListService } from '../../../services/Model/ModelList/model-list.service';
import { MatDialog } from '@angular/material/dialog';
import { ModelUploadComponent } from '../ModelUpload/model-upload.component';

@Component({
  selector: 'app-model-list',
  templateUrl: './model-list.component.html',
  styleUrls: ['./model-list.component.css'],
})
export class ModelListComponent implements OnInit {
  models: any[] = [];

  constructor(
    private modelListService: ModelListService,
    public dialog: MatDialog
  ) {}

  ngOnInit(): void {
    this.fetchModels();
  }

  fetchModels() {
    // Existing code to fetch models
  }

  openUploadModelDialog(): void {
    const dialogRef = this.dialog.open(ModelUploadComponent, {
      width: '400px',
      data: {}, // You can pass data here if needed
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result) {
        // Refresh the model list
        this.fetchModels();
      }
    });
  }
}
