import { CardOtpPage } from "./../card-otp/card-otp";
import { NoticeHandlerProvider } from "./../../services/notice-handler/notice-handler";
import { Component, OnInit } from "@angular/core";
import { LoadingController } from "@ionic/angular";
import { FormBuilder, FormGroup, Validators } from "@angular/forms";
import { DatePipe } from "@angular/common";
import { Router, ActivatedRoute } from "@angular/router";

// import * as Ravepay from "ravepay";

/**
 * Generated class for the EnterCardDetailsPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@Component({
  selector: "page-enter-card-details",
  templateUrl: "./enter-card-details.html",
  styleUrls: ["./enter-card-details.scss"],
  providers: [DatePipe]
})
export class EnterCardDetailsPage implements OnInit {
  minYear: any;
  currentYear: any;
  maxYear: any;
  // SecretKey;
  // secure_link: string | null;
  rave: any;
  cardDetails: FormGroup;
  constructor(
    private route: Router,
    private navParams: ActivatedRoute,
    private fb: FormBuilder,
    private _alert: NoticeHandlerProvider,
    private _spin: LoadingController
  ) {
    // this.rave = new Ravepay(
    //   "FLWPUBK-8247b8fd71a635eca705bfa7247b0f05-X",
    //   "FLWSECK-4fea61350032b5097f1bcecb8c4567ea-X",
    //   false
    // );
    const today = new Date();
    this.minYear = today.getFullYear();
  }
  // FLWSECK-f1f3a0a129421d56df6c86d77f179829-X
  // FLWSECK-91c576f28e0302a3b44ec82dd1a34ac7-X
  // FLWPUBK-dcca427a3ab3306cf6f003184b373396-X
  ionViewDidLoad() {}
  ngOnInit() {
    // Validators.min( parseInt( new DatePipe('en-US').transform(Date.now(), 'yy')) ),Validators.max(99)
    this.cardDetails = this.fb.group({
      cardno: [
        null,
        [
          Validators.required,
          Validators.minLength(16),
          Validators.pattern("^[0-9]{16,}$")
        ]
      ],
      cvv: [null, [Validators.minLength(3)]],
      expirymonth: [
        null,
        [Validators.required, Validators.min(1), Validators.max(12)]
      ],
      expiryyear: [
        null,
        [Validators.required, Validators.pattern("^[0-9]{2,}$")]
      ],
      currency: ["NGN", []],
      country: ["NG", []],
      amount: [null, [Validators.required]],
      pin: [null, [Validators.required, Validators.minLength(4)]],
      suggested_auth: ["pin", []],
      email: [null, [Validators.required, Validators.email]],
      phonenumber: [
        null,
        [Validators.required, Validators.pattern("^[0-9]{11,}$")]
      ],
      firstname: [null, [Validators.required, Validators.minLength(2)]],
      lastname: [null, [Validators.required, Validators.minLength(2)]],
      IP: ["88.168.12.1", []],
      txRef: ["MC-" + Date.now(), []],
      meta: [
        {
          metaname: "FundAcct",
          metavalue: "" + Date.now()
        }
      ],
      redirect_url: "https://rave-webhook.herokuapp.com/receivepayment",
      device_fingerprint: ["69e6b7f0sb72037aa8428b70fbe03986c", []]
    });

    this.cardDetails.valueChanges.subscribe(changes => {});
  }

  get publicKey() {
    return "FLWPUBK-8247b8fd71a635eca705bfa7247b0f05-X";
  }
  get cardno() {
    return this.cardDetails.get("cardno");
  }

  get firstname() {
    return this.cardDetails.get("firstname");
  }

  get lastname() {
    return this.cardDetails.get("lastname");
  }

  get expirymonth() {
    return this.cardDetails.get("expirymonth");
  }

  get expiryyear() {
    return this.cardDetails.get("expiryyear");
  }

  get pin() {
    return this.cardDetails.get("pin");
  }

  get amount() {
    return this.cardDetails.get("amount");
  }

  get email() {
    return this.cardDetails.get("email");
  }

  get phonenumber() {
    return this.cardDetails.get("phonenumber");
  }

  get cvv() {
    return this.cardDetails.get("cvv");
  }

  async ravePay() {
    const loading = await this._spin.create({
      message: ""
    });
    await loading.present();
    this.expirymonth.value.toString();
    this.expiryyear.value.toString();
    await this.rave.Card.charge(this.cardDetails.value)
      .then(resp => {
        if (
          resp.body.status == "success" &&
          resp.body.data.chargeResponseCode == "02"
        ) {
          this.route.navigate(["CardOtpPage"], {
            queryParams: {
              amount: resp.body.data.amount,
              accountNumber: this.navParams.snapshot.params.accountNumber,
              appfee: resp.body.data.appfee,
              ref: resp.body.data.flwRef,
              pk: this.publicKey,
              otpMessage: resp.body.data.chargeResponseMessage
            }
          });
        } else {
          this._alert.notifyError(JSON.stringify(resp.body.message));
        }
        // console.log(resp.body.data);
      })
      .catch(err => {
        this._alert.notifyError(JSON.stringify(err.message));
      });
  }
}
