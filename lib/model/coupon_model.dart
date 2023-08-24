const String collectionCoupon = 'CouponList';
const String couponFieldId = 'id';
const String couponFieldCode = 'code';
const String couponFieldDiscount = 'discount';

class CouponCode {
  String id;
  String code;
  String discount;

  CouponCode({required this.id, required this.code, required this.discount});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      couponFieldId: id,
      couponFieldCode: code,
      couponFieldDiscount: discount,
    };
  }

  factory CouponCode.fromMap(Map<String, dynamic> map) => CouponCode(
        id: map[couponFieldId],
        code: map[couponFieldCode],
        discount: map[couponFieldDiscount],
      );
}
