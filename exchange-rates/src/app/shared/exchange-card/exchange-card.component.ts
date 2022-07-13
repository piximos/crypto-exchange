import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-exchange-card',
  templateUrl: './exchange-card.component.html',
  styleUrls: ['./exchange-card.component.scss']
})
export class ExchangeCardComponent implements OnInit {

  @Input() name: string = "";
  @Input() abreviation: string = "";
  @Input() exchangeValue: string | number = "";
  @Input() type: string = "";
  @Input() unit: string = "";

  constructor() { }

  ngOnInit(): void {
  }

}
