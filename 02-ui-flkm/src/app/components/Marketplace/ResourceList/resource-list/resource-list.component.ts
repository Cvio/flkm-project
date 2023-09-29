// resource-list.component.ts
import { Component, OnInit } from '@angular/core';
import { ResourceListService } from '../../../../services/Marketplace/ResourceList/resource-list.service';

@Component({
  selector: 'app-resource-list',
  templateUrl: './resource-list.component.html',
  styleUrls: ['./resource-list.component.css'],
})
export class ResourceListComponent implements OnInit {
  public resources: any[] = [];
  public error: string | null = null;

  constructor(private resourceListService: ResourceListService) {}

  ngOnInit(): void {
    this.loadResourcesByOwnerId('asdfasdf');

    this.resourceListService.getResourceList().subscribe(
      (data) => {
        console.log('Data Returned: ', data); // Log the returned data to the console
        this.resources = data;
      },
      (error) => {
        console.error('Error fetching resources: ', error); // Log errors to the console
        this.error = 'Error fetching resources!';
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
