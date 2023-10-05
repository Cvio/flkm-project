import { Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';
import { Component, OnInit, NgModule, OnDestroy } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms'; // for using forms
import { ProjectService } from '../../../../services/Project/CreateProject/project.service';
import { SharedService } from '../../../../services/Shared/shared.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-create-project',
  templateUrl: './create-project.component.html',
  styleUrls: ['./create-project.component.css'],
})
export class CreateProjectComponent implements OnInit, OnDestroy {
  projectForm: FormGroup;
  projectData: any; // Variable to store project data
  createError: string | null = null;
  selectedDataset: string | null = null;
  private destroy$ = new Subject<void>();

  constructor(
    private formBuilder: FormBuilder,
    private projectService: ProjectService,
    private router: Router,
    private sharedService: SharedService
  ) {
    this.projectForm = this.formBuilder.group({
      projectName: ['', Validators.required],
      // Add more form controls for other project details
    });
  }
  ngOnInit(): void {
    this.projectForm = this.formBuilder.group({
      projectName: ['', Validators.required],
      description: [''],
      dataset: [''], // add validation and handling for file upload if needed
      modelType: ['classification'], // default to classification, other options: regression, clustering
      learningRate: [0.01],
      privacySettings: [''],
      participants: [''],
      startDate: [''],
      endDate: [''],
      accessControl: [''],
      dataPreprocessing: [''],
      evaluationMetrics: ['accuracy'], // default to accuracy, other options: precision, recall, f1-score, auc, rmse, mae, r2
      acceptanceCriteria: [0.8], // default to 0.8, other options: 0.9, 0.95
      ownerId: [''],
    });

    this.sharedService
      .getSelectedDatasetId()
      .pipe(takeUntil(this.destroy$))
      .subscribe((id) => {
        if (id) {
          this.projectForm.patchValue({
            dataset: id,
          });
          this.selectedDataset = id;
        }
      });
  }
  createProject(): void {
    if (this.projectForm.valid) {
      const projectDetails = this.projectForm.value;

      // Use an observer to handle the API call response
      const projectCreationObserver = {
        next: (response: any) => {
          this.projectData = response;
          // Handle a successful project creation response
          this.router.navigate(['/dashboard']);
        },
        error: (error: any) => {
          console.error('Error creating project:', error);
          // Handle errors (e.g., display an error message)
        },
      };

      // Make an API call to your backend service to create the project
      this.projectService
        .createProject(projectDetails)
        .subscribe(projectCreationObserver);
    }
  }
  navigateToMarketplace(): void {
    // Assuming that the route to the marketplace component is '/marketplace'
    this.router.navigate(['/marketplace']);
  }

  onSubmit(): void {
    // You can call createProject() when the user submits the form
    this.createProject();
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }
}
