import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { LoginService } from '../../../services/Authentication/Login/login.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
})
export class LoginComponent implements OnInit {
  loginForm: FormGroup = this.fb.group({
    username: ['', Validators.required],
    password: ['', Validators.required],
  });
  loginError: string | null = null;
  loginSuccess = false;
  loginResponse: any;

  constructor(
    private fb: FormBuilder,
    private loginService: LoginService,
    private router: Router
  ) {}

  ngOnInit(): void {}
  //sar sar
  onSubmit() {
    if (this.loginForm.valid) {
      this.loginService.loginUser(this.loginForm.value).subscribe(
        (response) => {
          const token = response.token;

          // Save the token in localStorage
          localStorage.setItem('authToken', token);

          console.log('User logged in successfully:', response);
          this.loginSuccess = true; // Set loginSuccess to true
          this.loginResponse = response; // Store the response
          this.loginError = null; // Reset loginError
          // Handle success, set token, navigate, etc.
          // Navigate to the dashboard upon successful login
          this.router.navigate(['/dashboard']);
        },
        (error) => {
          console.error('Error logging in:', error);
          this.loginSuccess = false; // Set loginSuccess to false
          this.loginResponse = error; // Store the response
          this.loginError = 'Invalid username or password.'; // Set loginError
        }
      );
    }
  }
}
