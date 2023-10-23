import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModelUploadService } from '../../../services/Model/ModelUpload/model-upload.service';
import { UserService } from '../../../services/User/UserData/user-data.service';

@Component({
  selector: 'app-model-upload',
  templateUrl: './model-upload.component.html',
  styleUrls: ['./model-upload.component.css'],
})
export class ModelUploadComponent implements OnInit {
  modelUploadForm!: FormGroup;
  selectedFile: File | null = null;
  successMessage: string | null = null;

  constructor(
    private formBuilder: FormBuilder,
    private modelUploadService: ModelUploadService,
    private userService: UserService
  ) {}

  ngOnInit(): void {
    this.modelUploadForm = this.formBuilder.group({
      name: ['', Validators.required],
      ownerId: ['', Validators.required],
    });

    this.userService.getCurrentUserId().subscribe(
      (userId) => {
        console.log('userId: ', userId); // Now this should log the userId directly.
        if (userId) {
          this.modelUploadForm.patchValue({ ownerId: userId });
        } else {
          console.error('userId is undefined');
        }
      },
      (error) => {
        console.error('Error getting user ID:', error);
      }
    );
  }

  onFileSelected(event: any): void {
    this.selectedFile = event.target.files[0];
  }

  uploadModel(): void {
    if (this.modelUploadForm.valid && this.selectedFile) {
      const formData = new FormData();
      formData.append('file', this.selectedFile);
      formData.append(
        'ownerId',
        this.modelUploadForm.get('ownerId')?.value || ''
      );
      formData.append(
        'modelAttributes',
        JSON.stringify(this.modelUploadForm.value)
      );

      this.modelUploadService.uploadModel(formData).subscribe(
        (response) => {
          console.log('Model uploaded successfully:', response);
          this.successMessage = 'Model uploaded successfully!';
        },
        (error) => {
          console.error('Error uploading model:', error);
          this.successMessage = 'Error uploading model!';
        }
      );
    }
  }
}
