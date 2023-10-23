import { TestBed } from '@angular/core/testing';

import { ModelUploadService } from './model-upload.service';

describe('ModelUploadService', () => {
  let service: ModelUploadService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ModelUploadService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
