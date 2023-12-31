import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Web3Component } from './web3.component';

describe('Web3Component', () => {
  let component: Web3Component;
  let fixture: ComponentFixture<Web3Component>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [Web3Component]
    });
    fixture = TestBed.createComponent(Web3Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
