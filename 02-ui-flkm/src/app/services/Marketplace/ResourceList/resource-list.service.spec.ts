import { TestBed } from '@angular/core/testing';

import { ResourceListService } from './resource-list.service';

describe('ResourceListService', () => {
  let service: ResourceListService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ResourceListService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
