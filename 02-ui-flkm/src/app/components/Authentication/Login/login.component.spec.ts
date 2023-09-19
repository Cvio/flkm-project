import { ComponentFixture, TestBed } from '@angular/core/testing';
import { FormBuilder, ReactiveFormsModule } from '@angular/forms';
import { LoginComponent } from './login.component';
import { LoginService } from './login.service'; // Update the path
import { of, throwError } from 'rxjs';

describe('LoginComponent', () => {
  let component: LoginComponent;
  let fixture: ComponentFixture<LoginComponent>;
  let mockLoginService: jasmine.SpyObj<LoginService>;

  beforeEach(async () => {
    mockLoginService = jasmine.createSpyObj('LoginService', ['loginUser']);

    await TestBed.configureTestingModule({
      declarations: [LoginComponent],
      imports: [ReactiveFormsModule],
      providers: [
        FormBuilder,
        { provide: LoginService, useValue: mockLoginService },
      ],
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(LoginComponent);
    component = fixture.componentInstance;
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  // Add more test cases to cover different component behaviors

  it('should handle successful login', () => {
    mockLoginService.loginUser.and.returnValue(
      of({ message: 'Login successful' })
    );

    // Call component's onSubmit method with valid form data
    component.loginForm.setValue({
      email: 'test@example.com',
      password: 'password',
    });
    component.onSubmit();

    // Expect loginSuccess to be true
    expect(component.loginSuccess).toBeTrue();
    expect(component.loginError).toBeNull();
  });

  it('should handle login error', () => {
    const errorMessage = 'Login failed';
    mockLoginService.loginUser.and.returnValue(
      throwError({ message: errorMessage })
    );

    // Call component's onSubmit method with valid form data
    component.loginForm.setValue({
      email: 'test@example.com',
      password: 'password',
    });
    component.onSubmit();

    // Expect loginSuccess to be false and loginError to contain error message
    expect(component.loginSuccess).toBeFalse();
    expect(component.loginError).toBe(
      `An error occurred during login: ${errorMessage}`
    );
  });
});
