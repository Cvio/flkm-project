import { Component } from '@angular/core';
import { ModelUploadService } from '../../../services/Model/ModelUpload/model-upload.service';

@Component({
  selector: 'app-model-upload',
  templateUrl: './model-upload.component.html',
  styleUrls: ['./model-upload.component.css'],
})
export class ModelUploadComponent {
  modelFile: File | null = null;

  constructor(private modelUploadService: ModelUploadService) {}

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input.files) {
      this.modelFile = input.files[0];
    }
  }

  onUpload(): void {
    if (this.modelFile) {
      const formData = new FormData();
      formData.append('modelFile', this.modelFile);
      formData.append('name', 'Model Name'); // Replace with actual name
      formData.append('version', '1.0'); // Replace with actual version
      formData.append('description', 'Description'); // Replace with actual description
      formData.append('ownerId', 'ownerId'); // Replace with actual ownerId

      this.modelUploadService.uploadModel(formData).subscribe(
        (result) => {
          console.log('Upload successful', result);
        },
        (err) => {
          console.log('Upload failed', err);
        }
      );
    }
  }
}
