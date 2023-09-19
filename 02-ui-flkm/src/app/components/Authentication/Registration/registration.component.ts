import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { RegistrationService } from '../../../services/Authentication/Registration/registration.service';

@Component({
  selector: 'app-registration',
  templateUrl: './registration.component.html',
  styleUrls: ['./registration.component.css'],
})
export class RegistrationComponent {
  registrationForm: FormGroup = this.fb.group({
    username: ['', Validators.required],
    email: ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(6)]],
  });

  registrationSuccess: boolean = false;
  registrationError: string | null = null;

  constructor(
    private fb: FormBuilder,
    private registrationService: RegistrationService,
    private router: Router
  ) {}

  registerUser() {
    if (this.registrationForm.valid) {
      this.registrationService
        .registerUser(this.registrationForm.value)
        .subscribe({
          next: (response) => {
            console.log('Registration successful:', response);
            this.registrationSuccess = true;
            // After successful registration
            this.router.navigate(['/verify-email']);
          },
          error: (error) => {
            console.error('Error registering user:', error);
            this.registrationError = error.error.message;
          },
        });
    }
  }
}
