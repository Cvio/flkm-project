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
  public error: string | null = null;
  ownerId: string | null = null;

  constructor(
    private resourceListService: ResourceListService,
    private sharedService: SharedService,
    private marketplaceService: MarketplaceService,
    private userService: UserService
  ) {}

  ngOnInit(): void {
    // this.userService
    //   .getCurrentUserId()
    //   .pipe(
    //     switchMap((userId) =>
    //       this.resourceListService.getResourceListByOwner(userId)
    //     )
    //   )
    //   .subscribe(
    //     (data) => {
    //       this.resources = data;
    //     },
    //     (error) => {
    //       console.error('Error:', error);
    //     }
    //   );
  }
}
