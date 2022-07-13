import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ExchangeCardComponent } from './exchange-card/exchange-card.component';



@NgModule({
  declarations: [
    ExchangeCardComponent
  ],
  imports: [
    CommonModule
  ],
  exports: [
    ExchangeCardComponent
  ]
})
export class SharedModule { }
