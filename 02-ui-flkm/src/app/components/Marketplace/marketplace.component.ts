import { Component, OnInit } from '@angular/core';
import { ResourceListService } from '../../services/Marketplace/ResourceList/resource-list.service';
import { SharedService } from '../../services/Shared/shared.service';
import { MarketplaceService } from '../../services/Marketplace/marketplace.service';
import { UserService } from '../../services/User/UserData/user-data.service';
import { switchMap } from 'rxjs/operators';

@Component({
  selector: 'app-marketplace',
  templateUrl: './marketplace.component.html',
  styleUrls: ['./marketplace.component.css'],
})
export class MarketplaceComponent implements OnInit {
  public resources: any[] = [];
  public filteredResources: any[] = [];
  public error: string | null = null;
  public searchTerm: string = ''; // to hold the value of the search input
  ownerId: string | null = null;

  constructor(
    private resourceListService: ResourceListService,
    private sharedService: SharedService,
    private marketplaceService: MarketplaceService,
    private userService: UserService
  ) {}

  ngOnInit(): void {
    // Let's assume you fetch resources here and assign it to this.resources
    // this.filteredResources should be the one used in the template to display resources.
    this.filteredResources = [...this.resources];
  }
  // marketplace.component.ts
  filterResources(): void {
    const lowerCaseSearchTerm = this.searchTerm.toLowerCase();
    this.filteredResources = this.resources.filter((resource) =>
      resource.name.toLowerCase().includes(lowerCaseSearchTerm)
    );
  }

  loadResourcesByOwnerId(ownerId: string): void {
    this.resourceListService.getResourceListByOwner(ownerId).subscribe(
      (metadata) => {
        this.resources = metadata;
        this.filteredResources = [...this.resources];
      },
      (error) => {
        console.error('Error fetching resources:', error);
      }
    );
  }

  onSearch(): void {
    this.filterResources();
  }

  selectResource(resourceId: string): void {
    // Logic to associate the selected resource with the user's project.
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
    this.filteredResources.sort((a, b) => b.popularity - a.popularity);
  }

  sortResourcesByRecent(): void {
    this.filteredResources.sort(
      (a, b) =>
        new Date(b.dateAdded).getTime() - new Date(a.dateAdded).getTime()
    );
  }
}
