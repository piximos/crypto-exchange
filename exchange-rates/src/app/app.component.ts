import { Component, OnInit } from '@angular/core';
import { ExchangeRateService } from './services/exchange-rate.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {
  public rates: {[key:string]:{name: string, unit: string, type: string, value: number}} = {};

  constructor (private exchange: ExchangeRateService){}

  ngOnInit(): void {
    this.getCurrentExchangeRate()
  }
  getCurrentExchangeRate() {
    this.exchange.getCurrentExchangeRate().subscribe((val:any) => {
      this.rates=val.rates
    })
  }


}
