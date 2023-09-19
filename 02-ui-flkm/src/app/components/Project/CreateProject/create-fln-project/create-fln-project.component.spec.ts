import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CreateFlnProjectComponent } from './create-fln-project.component';

describe('CreateFlnProjectComponent', () => {
  let component: CreateFlnProjectComponent;
  let fixture: ComponentFixture<CreateFlnProjectComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [CreateFlnProjectComponent]
    });
    fixture = TestBed.createComponent(CreateFlnProjectComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
