import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { WithdrawCashPage } from './withdraw-cash';

@NgModule({
  declarations: [
    WithdrawCashPage,
  ],
  imports: [
    IonicPageModule.forChild(WithdrawCashPage),
  ],
})
export class WithdrawCashPageModule {}
