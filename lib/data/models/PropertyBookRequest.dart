import 'dart:convert';

BookingRequest bookingRequestFromJson(String str) =>
    BookingRequest.fromJson(json.decode(str));

String bookingRequestToJson(BookingRequest data) =>
    json.encode(data.toJson());

class BookingRequest {
  int userId;
  int propertyId;
  String date;
  String time;

  BookingRequest({
    required this.userId,
    required this.propertyId,
    required this.date,
    required this.time,
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) => BookingRequest(
    userId: json["user_id"],
    propertyId: json["property_id"],
    date: json["date"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "property_id": propertyId,
    "date": date,
    "time": time,
  };
}
