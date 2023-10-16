// resource-list.component.ts
import { Component, OnInit } from '@angular/core';
import { ResourceListService } from '../../../../services/Marketplace/ResourceList/resource-list.service';
import { UserService } from '../../../../services/User/UserData/user-data.service';
import { SharedService } from '../../../../services/Shared/shared.service';
import { Router } from '@angular/router';

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
    private userService: UserService,
    private sharedService: SharedService,
    private router: Router
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
      (metadata) => {
        this.resources = metadata;
      },
      (error) => {
        console.error('Error fetching resources:', error);
      }
    );
  }

  onDatasetSelected(datasetName: string): void {
    this.sharedService.setSelectedDatasetId(datasetName);
    this.router.navigate(['/create-project']);
  }

  applyFilter(filterType: string): void {
    switch (filterType) {
      case 'popular':
        this.sortResourcesByPopularity();
        break;
      case 'recent':
        this.sortResourcesByRecent();
        break;
      // Add more cases here
      default:
        break;
    }
  }

  sortResourcesByPopularity(): void {
    this.resources.sort((a, b) => b.popularity - a.popularity);
  }

  sortResourcesByRecent(): void {
    this.resources.sort((a, b) => {
      const dateA = new Date(a.createdAt).getTime();
      const dateB = new Date(b.createdAt).getTime();
      console.log(`Date A: ${dateA}, Date B: ${dateB}`);
      return dateB - dateA;
    });
    console.log('Sorted Resources:', this.resources);
  }

  // sortResourcesByRecent(): void {
  //   this.resources.sort(
  //     (a, b) =>
  //       new Date(b.dateAdded).getTime() - new Date(a.dateAdded).getTime()
  //   );
  // }

  onSortOptionChange(event: Event): void {
    const target = event.target as HTMLSelectElement;
    const value = target.value;
    this.applyFilter(value);
  }
}
