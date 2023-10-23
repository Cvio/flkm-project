import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { RegistrationComponent } from './components/Authentication/Registration/registration.component';
import { RegistrationConfirmationComponent } from './components/Authentication/Registration/RegistrationConfirmation/registration-confirmation.component';
import { VerifyEmailComponent } from './components/Authentication/VerifyEmail/verify-email.component';
import { LoginComponent } from './components/Authentication/Login/login.component';
import { DashboardComponent } from './components/Dashboard/Dashboard/dashboard.component';
import { CreateProjectComponent } from './components/Project/CreateProject/CreateProject/create-project.component';
import { UserWalletComponent } from './components/User/UserWallet/user-wallet.component';
import { ResourceListComponent } from './components/Marketplace/ResourceList/ResourceList/resource-list.component';
import { MarketplaceComponent } from './components/Marketplace/marketplace.component';
import { UploadResourceComponent } from './components/Marketplace/UploadResource/upload-resource.component';
import { ModelListComponent } from './components/Model/ModelList/model-list.component';
import { ModelUploadComponent } from './components/Model/ModelUpload/model-upload.component';

const routes: Routes = [
  { path: '', redirectTo: 'register', pathMatch: 'full' },
  { path: 'register', component: RegistrationComponent },
  { path: 'verify-email', component: VerifyEmailComponent },
  {
    path: 'registration-confirmation',
    component: RegistrationConfirmationComponent,
  },
  { path: 'login', component: LoginComponent },
  { path: 'dashboard', component: DashboardComponent },
  { path: 'create-project', component: CreateProjectComponent },
  { path: 'user-wallet', component: CreateProjectComponent },
  { path: 'marketplace', component: MarketplaceComponent },
  { path: 'resource-list', component: ResourceListComponent },
  { path: 'upload-resource', component: UploadResourceComponent },
  { path: 'model-list', component: ModelListComponent },
  { path: 'model-upload', component: ModelUploadComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
