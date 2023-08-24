const String collectionServiceCost = 'ServiceCost';
const String couponFieldVat = 'vat';
const String couponFieldCommission = 'commissionParking';
const String couponFieldCouponList = 'couponList';

class ServiceCost {
  String vat;
  String commissionParking;

  ServiceCost({
    required this.vat,
    required this.commissionParking,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      couponFieldVat: vat,
      couponFieldCommission: commissionParking,
    };
  }

  factory ServiceCost.fromMap(Map<String, dynamic> map) => ServiceCost(
        vat: map[couponFieldVat],
        commissionParking: map[couponFieldCommission],
      );
}
