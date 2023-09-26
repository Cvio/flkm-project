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

  constructor(private resourceListService: ResourceListService) {}

  ngOnInit(): void {
    this.resourceListService
      .getResourceList()
      .subscribe((data) => (this.resources = data));
  }
}
