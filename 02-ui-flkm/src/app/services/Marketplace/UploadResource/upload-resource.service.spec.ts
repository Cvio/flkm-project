import { TestBed } from '@angular/core/testing';

import { UploadResourceService } from './upload-resource.service';

describe('UploadResourceService', () => {
  let service: UploadResourceService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(UploadResourceService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
