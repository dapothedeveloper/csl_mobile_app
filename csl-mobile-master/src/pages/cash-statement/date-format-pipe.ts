import { Pipe, PipeTransform} from '@angular/core';
import { DatePipe } from '@angular/common';

@Pipe({
    name: 'dateFormat'
  })
  export class DateFormatPipe extends DatePipe implements PipeTransform {
    transform(value: any, args?: string): any {
        
       return super.transform(value, args);
    }
  }