// resource-list.component.ts
import { Component, OnInit } from '@angular/core';
import { ResourceListService } from '../../../../services/Marketplace/ResourceList/resource-list.service';
import { UserService } from '../../../../services/User/UserData/user-data.service';

@Component({
  selector: 'app-resource-list',
  templateUrl: './resource-list.component.html',
  styleUrls: ['./resource-list.component.css'],
})
export class ResourceListComponent implements OnInit {
  public resources: any[] = [];
  public error: string | null = null;

  constructor(
    private resourceListService: ResourceListService,
    private userService: UserService
  ) {}

  ngOnInit(): void {
    this.userService.getCurrentUserId().subscribe(
      (ownerId) => {
        if (ownerId) {
          this.loadResourcesByOwnerId(ownerId); // Call the loadResourcesByOwnerId method with the received ownerId.
        } else {
          console.error('ownerId is undefined');
        }
      },
      (error) => {
        console.error('Error getting user ID:', error);
      }
    );
  }

  loadResourcesByOwnerId(ownerId: string): void {
    this.resourceListService.getResourceListByOwner(ownerId).subscribe(
      (data) => {
        this.resources = data;
      },
      (error) => {
        console.error('Error fetching resources:', error);
      }
    );
  }
}
