// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    bool status;
    Data data;

    ProfileModel({
        required this.status,
        required this.data,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    Profile profile;
    List<dynamic> photos;

    Data({
        required this.profile,
        required this.photos,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        profile: Profile.fromJson(json["profile"]),
        photos: List<dynamic>.from(json["photos"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "profile": profile.toJson(),
        "photos": List<dynamic>.from(photos.map((x) => x)),
    };
}

class Profile {
    int id;
    dynamic userId;
    String name;
    String email;
    String password;
    String phone;
    String gender;
    DateTime dateOfBirth;
    dynamic age;
    dynamic maritalStatus;
    dynamic religion;
    dynamic caste;
    dynamic motherTongue;
    dynamic height;
    dynamic education;
    dynamic occupation;
    dynamic income;
    dynamic aboutMe;
    dynamic partner_preference;
    dynamic location;
    dynamic profilePhoto;
    bool isProfileCompleted;
    bool isVerified;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic bio;
    dynamic photos;
    dynamic country;
    dynamic state;
    dynamic city;
    dynamic livingStatus;
    dynamic smoke;
    dynamic drink;
    dynamic interest;
    dynamic qualification;
    dynamic performance;
    dynamic company;
    dynamic annualIncome;
    dynamic incomePrivate;
    dynamic fatherOccupation;
    dynamic motherOccupation;
    dynamic familyType;
    dynamic partnerAgeRange;
    dynamic partnerHeightRange;
    dynamic partnerEducation;
    dynamic partnerLocation;
    dynamic partnerNote;

    Profile({
        required this.id,
        required this.userId,
        required this.name,
        required this.email,
        required this.password,
        required this.phone,
        required this.gender,
        required this.dateOfBirth,
        required this.age,
        required this.maritalStatus,
        required this.religion,
        required this.caste,
        required this.motherTongue,
        required this.height,
        required this.education,
        required this.occupation,
        required this.income,
        required this.aboutMe,
        required this.partner_preference,
        required this.location,
        required this.profilePhoto,
        required this.isProfileCompleted,
        required this.isVerified,
        required this.createdAt,
        required this.updatedAt,
        required this.bio,
        required this.photos,
        required this.country,
        required this.state,
        required this.city,
        required this.livingStatus,
        required this.smoke,
        required this.drink,
        required this.interest,
        required this.qualification,
        required this.performance,
        required this.company,
        required this.annualIncome,
        required this.incomePrivate,
        required this.fatherOccupation,
        required this.motherOccupation,
        required this.familyType,
        required this.partnerAgeRange,
        required this.partnerHeightRange,
        required this.partnerEducation,
        required this.partnerLocation,
        required this.partnerNote,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        gender: json["gender"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        age: json["age"],
        maritalStatus: json["marital_status"],
        religion: json["religion"],
        caste: json["caste"],
        motherTongue: json["mother_tongue"],
        height: json["height"],
        education: json["education"],
        occupation: json["occupation"],
        income: json["income"],
        aboutMe: json["about_me"],
        partner_preference: json["partner_preference"],
        location: json["location"],
        profilePhoto: json["profile_photo"],
        isProfileCompleted: json["is_profile_completed"],
        isVerified: json["is_verified"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        bio: json["bio"],
        photos: json["photos"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        livingStatus: json["living_status"],
        smoke: json["smoke"],
        drink: json["drink"],
        interest: json["interest"],
        qualification: json["qualification"],
        performance: json["performance"],
        company: json["company"],
        annualIncome: json["annual_income"],
        incomePrivate: json["income_private"],
        fatherOccupation: json["father_occupation"],
        motherOccupation: json["mother_occupation"],
        familyType: json["family_type"],
        partnerAgeRange: json["partner_age_range"],
        partnerHeightRange: json["partner_height_range"],
        partnerEducation: json["partner_education"],
        partnerLocation: json["partner_location"],
        partnerNote: json["partner_note"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "gender": gender,
        "date_of_birth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "age": age,
        "marital_status": maritalStatus,
        "religion": religion,
        "caste": caste,
        "mother_tongue": motherTongue,
        "height": height,
        "education": education,
        "occupation": occupation,
        "income": income,
        "about_me": aboutMe,
        "partner_preference": partner_preference,
        "location": location,
        "profile_photo": profilePhoto,
        "is_profile_completed": isProfileCompleted,
        "is_verified": isVerified,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "bio": bio,
        "photos": photos,
        "country": country,
        "state": state,
        "city": city,
        "living_status": livingStatus,
        "smoke": smoke,
        "drink": drink,
        "interest": interest,
        "qualification": qualification,
        "performance": performance,
        "company": company,
        "annual_income": annualIncome,
        "income_private": incomePrivate,
        "father_occupation": fatherOccupation,
        "mother_occupation": motherOccupation,
        "family_type": familyType,
        "partner_age_range": partnerAgeRange,
        "partner_height_range": partnerHeightRange,
        "partner_education": partnerEducation,
        "partner_location": partnerLocation,
        "partner_note": partnerNote,
    };
}
