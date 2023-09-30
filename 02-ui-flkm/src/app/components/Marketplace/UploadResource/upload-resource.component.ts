import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { UploadResourceService } from '../../../services/Marketplace/UploadResource/upload-resource.service';
import { UserService } from '../../../services/User/UserData/user-data.service';

@Component({
  selector: 'upload-resource-component',
  templateUrl: './upload-resource.component.html',
  styleUrls: ['./upload-resource.component.css'],
})
export class UploadResourceComponent implements OnInit {
  uploadResourceForm!: FormGroup;
  selectedFile: File | null = null;

  constructor(
    private formBuilder: FormBuilder,
    private uploadResourceService: UploadResourceService,
    private userService: UserService
  ) {}

  ngOnInit(): void {
    this.uploadResourceForm = this.formBuilder.group({
      name: ['', Validators.required],
      ownerId: ['', Validators.required], // ownerId should be part of form group initially
    });

    this.userService.getCurrentUserId().subscribe(
      (userId) => {
        console.log('userId: ', userId); // Now this should log the userId directly.
        if (userId) {
          this.uploadResourceForm.patchValue({ ownerId: userId });
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

  uploadResource(): void {
    if (this.uploadResourceForm.valid && this.selectedFile) {
      const formData = new FormData();
      formData.append('file', this.selectedFile);
      formData.append(
        'ownerId',
        this.uploadResourceForm.get('ownerId')?.value || ''
      );
      formData.append(
        'resourceAttributes',
        JSON.stringify(this.uploadResourceForm.value)
      );

      this.uploadResourceService.uploadResource(formData).subscribe(
        (response) => console.log('Resource uploaded successfully:', response),
        (error) => console.error('Error uploading resource:', error)
      );
    }
  }
}
