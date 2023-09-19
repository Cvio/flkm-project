import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { ProjectService } from '../../../../services/Project/CreateProject/project.service';

@Component({
  selector: 'app-fln-project-button',
  templateUrl: './fln-project-button.component.html',
  styleUrls: ['./fln-project-button.component.css'],
})
export class FlnProjectButtonComponent {
  constructor(private router: Router) {}
  createProject(): void {
    // This function will be called when the button is clicked.
    // Add logic here to initiate the project creation process.
    console.log('Button clicked! Start project creation.');
    this.router.navigate(['/create-project']);
  }
}
