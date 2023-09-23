import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RegistrationComponent } from './components/Authentication/Registration/registration.component';
import { LoginComponent } from './components/Authentication/Login/login.component';
import { DashboardComponent } from './components/Dashboard/Dashboard/dashboard.component';
import { CreateProjectComponent } from './components/Project/CreateProject/create-project/create-project.component';
import { FlnProjectButtonComponent } from './components/Project/CreateProject/fln-project-button/fln-project-button.component';
import { VerifyEmailComponent } from './components/Authentication/verify-email/verify-email.component';
import { RegistrationConfirmationComponent } from './components/Authentication/Registration/registration-confirmation/registration-confirmation.component';

@NgModule({
  declarations: [
    AppComponent,
    RegistrationComponent,
    LoginComponent,
    DashboardComponent,
    CreateProjectComponent,
    FlnProjectButtonComponent,
    VerifyEmailComponent,
    RegistrationConfirmationComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
  ],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
