import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FlnProjectButtonComponent } from './fln-project-button.component';

describe('FlnProjectButtonComponent', () => {
  let component: FlnProjectButtonComponent;
  let fixture: ComponentFixture<FlnProjectButtonComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [FlnProjectButtonComponent],
    });
    fixture = TestBed.createComponent(FlnProjectButtonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
