import { Component, OnInit } from '@angular/core';
import { ResourceListService } from '../../services/Marketplace/ResourceList/resource-list.service';
import { SharedService } from '../../services/Shared/shared.service';
import { MarketplaceService } from '../../services/Marketplace/marketplace.service';
import { UserService } from '../../services/User/UserData/user-data.service';

@Component({
  selector: 'app-marketplace',
  templateUrl: './marketplace.component.html',
  styleUrls: ['./marketplace.component.css'],
})
export class MarketplaceComponent implements OnInit {
  public resources: any[] = [];
  public error: string | null = null;

  constructor(
    private resourceListService: ResourceListService,
    private sharedService: SharedService,
    private marketplaceService: MarketplaceService,
    private userService: UserService
  ) {}

  ngOnInit(): void {
    const username = 'asdfasdf'; // Replace with actual username
    this.marketplaceService.getResourcesByUsername(username).subscribe(
      (data) => {
        this.resources = data;
      },
      (error) => {
        console.error('Error fetching resources:', error);
      }
    );
  }

  selectDataset(datasetId: string): void {
    this.sharedService.setSelectedDatasetId(datasetId);
  }
}
