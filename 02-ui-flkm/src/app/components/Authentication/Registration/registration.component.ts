import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { RegistrationService } from '../../../services/Authentication/Registration/registration.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-registration',
  templateUrl: './registration.component.html',
  styleUrls: ['./registration.component.css'],
})
export class RegistrationComponent implements OnInit {
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

  ngOnInit(): void {}

  onSubmit() {
    if (this.registrationForm.valid) {
      this.registrationService
        .registerUser(this.registrationForm.value)
        .subscribe({
          next: (response) => {
            console.log('Registration successful:', response);
            // After successful registration
            this.router.navigate(['/verify-email']);
          },
          error: (error) => {
            console.error('Error registering user:', error);
          },
        });
    }
  }
}
