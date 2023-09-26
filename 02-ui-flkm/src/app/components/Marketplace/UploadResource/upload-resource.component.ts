import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { UploadResourceService } from '../../../services/Marketplace/UploadResource/upload-resource.service'; // Adjust the path accordingly

@Component({
  selector: 'upload-resource-component',
  templateUrl: './upload-resource.component.html',
  styleUrls: ['./upload-resource.component.css'],
})
export class UploadResourceComponent implements OnInit {
  uploadResourceForm!: FormGroup; // Using Non-null Assertion Operator
  selectedFile: File | null = null;

  constructor(
    private formBuilder: FormBuilder,
    private uploadResourceService: UploadResourceService
  ) {}

  ngOnInit(): void {
    this.uploadResourceForm = this.formBuilder.group({
      name: ['', Validators.required],
      // Add other form controls for resource attributes...
      // ...
    });
  }

  onFileSelected(event: any): void {
    this.selectedFile = event.target.files[0];
  }

  uploadResource(): void {
    if (this.uploadResourceForm.valid && this.selectedFile) {
      const formData = new FormData();
      formData.append('file', this.selectedFile);
      formData.append(
        'resourceAttributes',
        JSON.stringify(this.uploadResourceForm.value)
      );

      this.uploadResourceService.uploadResource(formData).subscribe(
        (response) => {
          console.log('Resource uploaded successfully:', response);
        },
        (error) => {
          console.error('Error uploading resource:', error);
        }
      );
    }
  }
}