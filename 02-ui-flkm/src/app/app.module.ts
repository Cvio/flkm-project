import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RegistrationComponent } from './components/Authentication/Registration/registration.component';
import { LoginComponent } from './components/Authentication/Login/login.component';
import { DashboardComponent } from './components/Dashboard/Dashboard/dashboard.component';
import { CreateProjectComponent } from './components/Project/CreateProject/CreateProject/create-project.component';
import { FlnProjectButtonComponent } from './components/Project/CreateProject/fln-project-button/fln-project-button.component';
import { VerifyEmailComponent } from './components/Authentication/VerifyEmail/verify-email.component';
import { RegistrationConfirmationComponent } from './components/Authentication/Registration/RegistrationConfirmation/registration-confirmation.component';
import { UserWalletComponent } from './components/User/UserWallet/user-wallet.component';
import { ResourceListComponent } from './components/Marketplace/ResourceList/ResourceList/resource-list.component';
import { MarketplaceComponent } from './components/Marketplace/marketplace.component';
import { UploadResourceComponent } from './components/Marketplace/UploadResource/upload-resource.component';

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
    UserWalletComponent,
    ResourceListComponent,
    MarketplaceComponent,
    UploadResourceComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
  ],
  exports: [ResourceListComponent],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
