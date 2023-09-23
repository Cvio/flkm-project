import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { VerifyEmailService } from '../../../services/Authentication/verify-email.service';

@Component({
  selector: 'app-verify-email',
  templateUrl: './verify-email.component.html',
  styleUrls: ['./verify-email.component.css'],
})
export class VerifyEmailComponent implements OnInit {
  isVerified: boolean = false;
  error: string | null = null;

  constructor(
    private route: ActivatedRoute,
    private verifyEmailService: VerifyEmailService
  ) {}

  ngOnInit(): void {
    this.route.queryParams.subscribe((params) => {
      const token = params['token'];
      if (token) {
        this.verifyEmailService.verifyEmail(token).subscribe({
          next: (response) => {
            console.log('Email verification successful:', response);
            this.isVerified = true;
          },
          error: (error) => {
            console.error('Error verifying email:', error);
            this.error = 'Error verifying email. Please try again later.';
          },
        });
      } else {
        this.error =
          'Invalid verification token. Please check your email and try again.';
      }
    });
  }

  // Example: Handler to resend verification email.
  onResendEmail() {
    // Call service to resend verification email.
  }
}
