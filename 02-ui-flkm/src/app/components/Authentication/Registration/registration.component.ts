// registration.component.ts

import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { RegistrationService } from '../../../services/Authentication/Registration/registration.service';
import { Router } from '@angular/router';
import { Web3Service } from '../../../services/Web3/web3.service';

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

  public account!: string;

  constructor(
    private fb: FormBuilder,
    private registrationService: RegistrationService,
    private router: Router,
    private web3Service: Web3Service
  ) {}

  async ngOnInit() {
    const accounts = await this.web3Service.getAccounts();
    // this.account = accounts[0];
    this.account = '0xeB6B42BFA9BCB83a72453AA2ef4D414BB9848b08';
  }

  onSubmit() {
    if (this.registrationForm.valid) {
      this.registrationService
        .registerUser(this.registrationForm.value)
        .subscribe({
          next: (response) => {
            console.log('Registration successful:', response);
            // Instead of immediate redirection, show a message to check email
            this.registrationSuccess = true;
          },
          error: (error) => {
            console.error('Error registering user:', error);
            this.registrationError =
              'Error registering user. Please try again.';
          },
        });
    }
  }
}
