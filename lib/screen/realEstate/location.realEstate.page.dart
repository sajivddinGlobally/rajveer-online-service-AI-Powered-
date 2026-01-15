/*

import 'package:ai_powered_app/screen/realEstate/upload.realEstate.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/providers/propertyDetail.dart';
final stateProvider = StateProvider<String?>((ref) => null);
final cityProvider = StateProvider<String?>((ref) => null);
final localAreaControllerProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);
final completeAddressControllerProvider =
Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);
final Map<String, List<String>> stateToCities = {
  // States
  "Andhra Pradesh": [
    "Visakhapatnam", "Vijayawada", "Guntur", "Nellore", "Kurnool",
    "Rajahmundry", "Tirupati", "Kakinada", "Anantapur", "Kadapa",
    "Eluru", "Ongole", "Chittoor", "Machilipatnam", "Srikakulam",
    "Vizianagaram", "Amaravati", "Tenali", "Proddatur", "Bhimavaram"
  ],
  "Arunachal Pradesh": [
    "Itanagar", "Naharlagun", "Pasighat", "Tawang", "Ziro",
    "Bomdila", "Tezu", "Roing", "Along", "Daporijo",
    "Yingkiong", "Khonsa", "Changlang", "Seppa", "Namsai"
  ],
  "Assam": [
    "Guwahati", "Silchar", "Dibrugarh", "Jorhat", "Nagaon",
    "Tinsukia", "Tezpur", "Bongaigaon", "Dhubri", "Diphu",
    "Karimganj", "Sivasagar", "Goalpara", "Barpeta", "Lakhimpur",
    "Hailakandi", "Golaghat", "Mangaldoi", "Kokrajhar", "Nalbari"
  ],
  "Bihar": [
    "Patna", "Gaya", "Bhagalpur", "Muzaffarpur", "Darbhanga",
    "Siwan", "Purnia", "Arrah", "Begusarai", "Katihar",
    "Munger", "Chapra", "Bettiah", "Saharsa", "Hajipur",
    "Sasaram", "Dehri", "Motihari", "Nawada", "Aurangabad"
  ],
  "Chhattisgarh": [
    "Raipur", "Bhilai", "Bilaspur", "Korba", "Durg",
    "Jagdalpur", "Raigarh", "Rajnandgaon", "Ambikapur", "Dhamtari",
    "Mahasamund", "Kanker", "Kawardha", "Janjgir", "Bemetara",
    "Balod", "Baloda Bazar", "Mungeli", "Surajpur", "Jashpur"
  ],
  "Goa": [
    "Panaji", "Margao", "Vasco da Gama", "Mapusa", "Ponda",
    "Bicholim", "Curchorem", "Sanguem", "Valpoi", "Canacona"
  ],
  "Gujarat": [
    "Ahmedabad", "Surat", "Vadodara", "Rajkot", "Gandhinagar",
    "Bhavnagar", "Jamnagar", "Junagadh", "Anand", "Bharuch",
    "Nadiad", "Mehsana", "Gandhidham", "Porbandar", "Navsari",
    "Surendranagar", "Morbi", "Godhra", "Palanpur", "Ankleshwar"
  ],
  "Haryana": [
    "Faridabad", "Gurgaon", "Hisar", "Rohtak", "Panipat",
    "Karnal", "Sonipat", "Yamunanagar", "Panchkula", "Ambala",
    "Bhiwani", "Sirsa", "Bahadurgarh", "Jind", "Thanesar",
    "Kaithal", "Rewari", "Palwal", "Fatehabad", "Kurukshetra"
  ],
  "Himachal Pradesh": [
    "Shimla", "Dharamshala", "Solan", "Mandi", "Kullu",
    "Manali", "Una", "Bilaspur", "Hamirpur", "Chamba",
    "Nahan", "Paonta Sahib", "Sundernagar", "Kangra", "Palampur"
  ],
  "Jharkhand": [
    "Ranchi", "Jamshedpur", "Dhanbad", "Bokaro", "Deoghar",
    "Hazaribagh", "Giridih", "Ramgarh", "Phusro", "Medininagar",
    "Dumka", "Jhumri Telaiya", "Chaibasa", "Sahibganj", "Godda",
    "Gumla", "Lohardaga", "Pakur", "Jamtara", "Latehar"
  ],
  "Karnataka": [
    "Bengaluru", "Mysore", "Mangalore", "Hubli", "Belgaum",
    "Davanagere", "Bellary", "Bijapur", "Gulbarga", "Shimoga",
    "Tumkur", "Udupi", "Hassan", "Raichur", "Chitradurga",
    "Kolar", "Bidar", "Gadag", "Bagalkot", "Haveri"
  ],
  "Kerala": [
    "Thiruvananthapuram", "Kochi", "Kozhikode", "Thrissur", "Kollam",
    "Kannur", "Palakkad", "Alappuzha", "Kottayam", "Malappuram",
    "Kasaragod", "Pathanamthitta", "Idukki", "Wayanad", "Ernakulam",
    "Ponnani", "Tirur", "Manjeri", "Neyyattinkara", "Kalamassery"
  ],
  "Madhya Pradesh": [
    "Bhopal", "Indore", "Gwalior", "Jabalpur", "Ujjain",
    "Sagar", "Dewas", "Satna", "Ratlam", "Rewa",
    "Katni", "Singrauli", "Burhanpur", "Khandwa", "Morena",
    "Bhind", "Chhindwara", "Guna", "Shivpuri", "Damoh"
  ],
  "Maharashtra": [
    "Mumbai", "Pune", "Nagpur", "Thane", "Nashik",
    "Aurangabad", "Solapur", "Kolhapur", "Amravati", "Navi Mumbai",
    "Sangli", "Malegaon", "Jalgaon", "Akola", "Latur",
    "Dhule", "Ahmednagar", "Chandrapur", "Parbhani", "Jalna"
  ],
  "Manipur": [
    "Imphal", "Thoubal", "Bishnupur", "Churachandpur", "Ukhrul",
    "Senapati", "Tamenglong", "Jiribam", "Kakching", "Moreh"
  ],
  "Meghalaya": [
    "Shillong", "Tura", "Nongpoh", "Jowai", "Williamnagar",
    "Nongstoin", "Baghmara", "Resubelpara", "Mawkyrwat", "Khliehriat"
  ],
  "Mizoram": [
    "Aizawl", "Lunglei", "Saiha", "Champhai", "Kolasib",
    "Serchhip", "Lawngtlai", "Mamit", "Hnahthial", "Saitual"
  ],
  "Nagaland": [
    "Kohima", "Dimapur", "Mokokchung", "Tuensang", "Wokha",
    "Zunheboto", "Mon", "Phek", "Peren", "Longleng", "Kiphire"
  ],
  "Odisha": [
    "Bhubaneswar", "Cuttack", "Rourkela", "Berhampur", "Sambalpur",
    "Puri", "Balasore", "Bargarh", "Bhadrak", "Baripada",
    "Jharsuguda", "Jeypore", "Angul", "Dhenkanal", "Keonjhar",
    "Rayagada", "Paralakhemundi", "Koraput", "Malkangiri", "Nabarangpur"
  ],
  "Punjab": [
    "Chandigarh", "Ludhiana", "Amritsar", "Jalandhar", "Patiala",
    "Bathinda", "Mohali", "Hoshiarpur", "Batala", "Pathankot",
    "Moga", "Firozpur", "Kapurthala", "Muktsar", "Faridkot",
    "Rupnagar", "Sangrur", "Gurdaspur", "Tarn Taran", "Fazilka"
  ],
  "Rajasthan": [
    "Jaipur", "Jodhpur", "Udaipur", "Kota", "Ajmer",
    "Bikaner", "Alwar", "Bhilwara", "Sikar", "Pali",
    "Sri Ganganagar", "Hanumangarh", "Jhunjhunu", "Bharatpur", "Dausa",
    "Nagaur", "Barmer", "Churu", "Jaisalmer", "Tonk"
  ],
  "Sikkim": [
    "Gangtok", "Namchi", "Gyalshing", "Mangan", "Pelling",
    "Ravangla", "Jorethang", "Singtam", "Rangpo", "Melli"
  ],
  "Tamil Nadu": [
    "Chennai", "Coimbatore", "Madurai", "Tiruchirappalli", "Salem",
    "Erode", "Tirunelveli", "Vellore", "Thoothukudi", "Dindigul",
    "Thanjavur", "Karur", "Namakkal", "Cuddalore", "Kanchipuram",
    "Nagapattinam", "Tiruvannamalai", "Pudukkottai", "Sivaganga", "Viluppuram"
  ],
  "Telangana": [
    "Hyderabad", "Warangal", "Nizamabad", "Karimnagar", "Khammam",
    "Ramagundam", "Mahbubnagar", "Nalgonda", "Adilabad", "Suryapet",
    "Siddipet", "Miryalaguda", "Jagtial", "Mancherial", "Wanaparthy"
  ],
  "Tripura": [
    "Agartala", "Udaipur", "Dharmanagar", "Ambassa", "Kailasahar",
    "Belonia", "Khowai", "Sonamura", "Teliamura", "Bishalgarh"
  ],
  "Uttar Pradesh": [
    "Lucknow", "Kanpur", "Varanasi", "Agra", "Meerut",
    "Allahabad", "Noida", "Ghaziabad", "Jhansi", "Aligarh",
    "Moradabad", "Bareilly", "Gorakhpur", "Faizabad", "Mathura",
    "Firozabad", "Saharanpur", "Muzaffarnagar", "Rampur", "Shahjahanpur"
  ],
  "Uttarakhand": [
    "Dehradun", "Haridwar", "Rishikesh", "Nainital", "Mussoorie",
    "Roorkee", "Haldwani", "Kashipur", "Rudrapur", "Pithoragarh",
    "Almora", "Chamoli", "Pauri", "Uttarkashi", "Tehri"
  ],
  "West Bengal": [
    "Kolkata", "Howrah", "Durgapur", "Siliguri", "Asansol",
    "Darjeeling", "Malda", "Jalpaiguri", "Kharagpur", "Burdwan",
    "Murshidabad", "Bankura", "Midnapore", "Cooch Behar", "Purulia",
    "Raiganj", "Balurghat", "Krishnanagar", "Berhampore", "Haldia"
  ],
  // Union Territories
  "Andaman and Nicobar Islands": [
    "Port Blair", "Car Nicobar", "Mayabunder", "Rangat", "Diglipur"
  ],
  "Chandigarh": ["Chandigarh"],
  "Dadra and Nagar Haveli and Daman and Diu": [
    "Daman", "Diu", "Silvassa"
  ],
  "Delhi": [
    "New Delhi", "Noida", "Gurgaon", "Faridabad", "Ghaziabad",
    "Dwarka", "Rohini", "Saket", "Janakpuri", "Pitampura"
  ],
  "Jammu and Kashmir": [
    "Srinagar", "Jammu", "Anantnag", "Baramulla", "Kathua",
    "Sopore", "Udhampur", "Bandipora", "Kupwara", "Pulwama"
  ],
  "Ladakh": ["Leh", "Kargil"],
  "Lakshadweep": ["Kavaratti", "Minicoy", "Andrott", "Agatti", "Kalpeni"],
  "Puducherry": ["Puducherry", "Karaikal", "Mahe", "Yanam"]
};

class LocationRealestatePage extends ConsumerStatefulWidget {
  final int? propertyId;
  const LocationRealestatePage(this.propertyId, {super.key});

  @override
  ConsumerState<LocationRealestatePage> createState() =>
      _LocationRealestatePageState();
}

class _LocationRealestatePageState
    extends ConsumerState<LocationRealestatePage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch property details if propertyId is not -1
    if (widget.propertyId != null && widget.propertyId != -1) {
      _fetchAndSetPropertyData();
    }
  }

  void _fetchAndSetPropertyData() async {
    final propertyId = widget.propertyId;
    if (propertyId == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final propertyDetail = await ref.read(
        propertyDetailProvider(propertyId).future,
      );
      final property = propertyDetail.property;
      if (property != null) {
        // Set the form fields with fetched data
        // Assuming property.location is in "City, State" format
        final locationParts = property.location?.split(", ");
        if (locationParts != null && locationParts.length == 2) {
          ref.read(stateProvider.notifier).state = locationParts[1];
          ref.read(cityProvider.notifier).state = property.location;
        }
        ref.read(localAreaControllerProvider).text = property.localArea ?? '';
        ref.read(completeAddressControllerProvider).text =
            property.completeAddress ?? '';
      } else {
        Fluttertoast.showToast(
          msg: "No property data found",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load property details: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.sp,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateList = stateToCities.keys.toList();
    final selectedState = ref.watch(stateProvider);
    final cityList = selectedState != null && stateToCities.containsKey(selectedState)
        ? stateToCities[selectedState]!
        : <String>[];
    final completeController = ref.watch(completeAddressControllerProvider);
    final localAreaController = ref.watch(localAreaControllerProvider);
    final selectedCity = ref.watch(cityProvider);

    void validateAndNavigate() {
      if (selectedState == null) {
        Fluttertoast.showToast(
          msg: "Please select State",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      if (selectedCity == null) {
        Fluttertoast.showToast(
          msg: "Please select City",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      if (localAreaController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "Please Enter Local Address",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      if (completeController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "Please Enter Complete Address",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => UploadRealestatePage(
            widget.propertyId, // Pass propertyId for further use
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(backgroundColor: const Color(0xFFF5F5F5)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                widget.propertyId != null && widget.propertyId != -1
                    ? "Update Location Details"
                    : "Location Details",
                style: GoogleFonts.inter(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF030016),
                  letterSpacing: -1.3,
                ),
              ),
              Text(
                widget.propertyId != null && widget.propertyId != -1
                    ? "Update details about your Location"
                    : "Tell us about your Location",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9A97AE),
                ),
              ),
              SizedBox(height: 15.h),
              _buildLabel("State"),
              SizedBox(height: 10.h),
              BuildDropDown(
                hint: "Select State",
                items: stateList,
                value: selectedState,
                onChange: (value) {
                  ref.read(stateProvider.notifier).state = value;
                  // Reset city when state changes
                  ref.read(cityProvider.notifier).state = null;
                },
              ),
              SizedBox(height: 15.h),
              _buildLabel("City"),
              SizedBox(height: 10.h),
              BuildDropDown(
                hint: "Select City",
                items: cityList,
                value: selectedCity != null && cityList.contains(selectedCity.split(", ")[0])
                    ? selectedCity.split(", ")[0]
                    : null,
                onChange: (value) {
                  if (value != null && selectedState != null) {
                    ref.read(cityProvider.notifier).state = "$value, $selectedState";
                  }
                },
              ),
              SizedBox(height: 15.h),
              _buildLabel("Locality Area"),
              SizedBox(height: 10.h),
              TextField(
                controller: localAreaController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: const BorderSide(
                      color: Color(0xFFDADADA),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: const BorderSide(
                      color: Color(0xFFDADADA),
                      width: 1.5,
                    ),
                  ),
                  hintText: "Enter Locality / Area",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF030016),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              _buildLabel("Complete Address"),
              SizedBox(height: 10.h),
              TextField(
                controller: completeController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: const BorderSide(
                      color: Color(0xFFDADADA),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: const BorderSide(
                      color: Color(0xFFDADADA),
                      width: 1.5,
                    ),
                  ),
                  hintText: "Enter Complete Address",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF030016),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: validateAndNavigate,
                child: Container(
                  width: 392.w,
                  height: 53.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: const Color(0xFF00796B),
                  ),
                  child: Center(
                    child: Text(
                      widget.propertyId != null &&
                          widget.propertyId != -1
                          ? "Update"
                          : "Continue",
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.gothicA1(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF030016),
      ),
    );
  }
}

class BuildDropDown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?) onChange;

  const BuildDropDown({
    super.key,
    required this.hint,
    required this.items,
    this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      icon: const Icon(Icons.keyboard_arrow_down),
      value: value != null && items.contains(value) ? value : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFF00796B), width: 2.w),
        ),
        hintText: value == null ? hint : null,
        hintStyle: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9A97AE),
          letterSpacing: -0.2,
        ),
      ),
      items: [
        DropdownMenuItem<String>(
          enabled: false,
          value: null,
          child: Text(
            hint,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9A97AE),
              letterSpacing: -0.2,
            ),
          ),
        ),
        ...items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF030016),
                letterSpacing: -0.2,
              ),
            ),
          );
        }).toList(),
      ],
      onChanged: (newValue) {
        if (newValue != null) {
          onChange(newValue);
        }
      },
    );
  }
}*/

import 'package:ai_powered_app/screen/realEstate/upload.realEstate.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/providers/propertyDetail.dart';

final stateProvider = StateProvider<String?>((ref) => null);
final cityProvider = StateProvider<String?>((ref) => null);
final localAreaControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);
final completeAddressControllerProvider =
    Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
    );

final Map<String, List<String>> stateToCities = {
  "Andhra Pradesh": [
    "Visakhapatnam",
    "Vijayawada",
    "Guntur",
    "Nellore",
    "Kurnool",
    "Rajahmundry",
    "Tirupati",
    "Kakinada",
    "Anantapur",
    "Kadapa",
    "Eluru",
    "Ongole",
    "Chittoor",
    "Machilipatnam",
    "Srikakulam",
    "Vizianagaram",
    "Amaravati",
    "Tenali",
    "Proddatur",
    "Bhimavaram",
  ],
  "Arunachal Pradesh": [
    "Itanagar",
    "Naharlagun",
    "Pasighat",
    "Tawang",
    "Ziro",
    "Bomdila",
    "Tezu",
    "Roing",
    "Along",
    "Daporijo",
    "Yingkiong",
    "Khonsa",
    "Changlang",
    "Seppa",
    "Namsai",
  ],
  "Assam": [
    "Guwahati",
    "Silchar",
    "Dibrugarh",
    "Jorhat",
    "Nagaon",
    "Tinsukia",
    "Tezpur",
    "Bongaigaon",
    "Dhubri",
    "Diphu",
    "Karimganj",
    "Sivasagar",
    "Goalpara",
    "Barpeta",
    "Lakhimpur",
    "Hailakandi",
    "Golaghat",
    "Mangaldoi",
    "Kokrajhar",
    "Nalbari",
  ],
  "Bihar": [
    "Patna",
    "Gaya",
    "Bhagalpur",
    "Muzaffarpur",
    "Darbhanga",
    "Siwan",
    "Purnia",
    "Arrah",
    "Begusarai",
    "Katihar",
    "Munger",
    "Chapra",
    "Bettiah",
    "Saharsa",
    "Hajipur",
    "Sasaram",
    "Dehri",
    "Motihari",
    "Nawada",
    "Aurangabad",
  ],
  "Chhattisgarh": [
    "Raipur",
    "Bhilai",
    "Bilaspur",
    "Korba",
    "Durg",
    "Jagdalpur",
    "Raigarh",
    "Rajnandgaon",
    "Ambikapur",
    "Dhamtari",
    "Mahasamund",
    "Kanker",
    "Kawardha",
    "Janjgir",
    "Bemetara",
    "Balod",
    "Baloda Bazar",
    "Mungeli",
    "Surajpur",
    "Jashpur",
  ],
  "Goa": [
    "Panaji",
    "Margao",
    "Vasco da Gama",
    "Mapusa",
    "Ponda",
    "Bicholim",
    "Curchorem",
    "Sanguem",
    "Valpoi",
    "Canacona",
  ],
  "Gujarat": [
    "Ahmedabad",
    "Surat",
    "Vadodara",
    "Rajkot",
    "Gandhinagar",
    "Bhavnagar",
    "Jamnagar",
    "Junagadh",
    "Anand",
    "Bharuch",
    "Nadiad",
    "Mehsana",
    "Gandhidham",
    "Porbandar",
    "Navsari",
    "Surendranagar",
    "Morbi",
    "Godhra",
    "Palanpur",
    "Ankleshwar",
  ],
  "Haryana": [
    "Faridabad",
    "Gurgaon",
    "Hisar",
    "Rohtak",
    "Panipat",
    "Karnal",
    "Sonipat",
    "Yamunanagar",
    "Panchkula",
    "Ambala",
    "Bhiwani",
    "Sirsa",
    "Bahadurgarh",
    "Jind",
    "Thanesar",
    "Kaithal",
    "Rewari",
    "Palwal",
    "Fatehabad",
    "Kurukshetra",
  ],
  "Himachal Pradesh": [
    "Shimla",
    "Dharamshala",
    "Solan",
    "Mandi",
    "Kullu",
    "Manali",
    "Una",
    "Bilaspur",
    "Hamirpur",
    "Chamba",
    "Nahan",
    "Paonta Sahib",
    "Sundernagar",
    "Kangra",
    "Palampur",
  ],
  "Jharkhand": [
    "Ranchi",
    "Jamshedpur",
    "Dhanbad",
    "Bokaro",
    "Deoghar",
    "Hazaribagh",
    "Giridih",
    "Ramgarh",
    "Phusro",
    "Medininagar",
    "Dumka",
    "Jhumri Telaiya",
    "Chaibasa",
    "Sahibganj",
    "Godda",
    "Gumla",
    "Lohardaga",
    "Pakur",
    "Jamtara",
    "Latehar",
  ],
  "Karnataka": [
    "Bengaluru",
    "Mysore",
    "Mangalore",
    "Hubli",
    "Belgaum",
    "Davanagere",
    "Bellary",
    "Bijapur",
    "Gulbarga",
    "Shimoga",
    "Tumkur",
    "Udupi",
    "Hassan",
    "Raichur",
    "Chitradurga",
    "Kolar",
    "Bidar",
    "Gadag",
    "Bagalkot",
    "Haveri",
  ],
  "Kerala": [
    "Thiruvananthapuram",
    "Kochi",
    "Kozhikode",
    "Thrissur",
    "Kollam",
    "Kannur",
    "Palakkad",
    "Alappuzha",
    "Kottayam",
    "Malappuram",
    "Kasaragod",
    "Pathanamthitta",
    "Idukki",
    "Wayanad",
    "Ernakulam",
    "Ponnani",
    "Tirur",
    "Manjeri",
    "Neyyattinkara",
    "Kalamassery",
  ],
  "Madhya Pradesh": [
    "Bhopal",
    "Indore",
    "Gwalior",
    "Jabalpur",
    "Ujjain",
    "Sagar",
    "Dewas",
    "Satna",
    "Ratlam",
    "Rewa",
    "Katni",
    "Singrauli",
    "Burhanpur",
    "Khandwa",
    "Morena",
    "Bhind",
    "Chhindwara",
    "Guna",
    "Shivpuri",
    "Damoh",
  ],
  "Maharashtra": [
    "Mumbai",
    "Pune",
    "Nagpur",
    "Thane",
    "Nashik",
    "Aurangabad",
    "Solapur",
    "Kolhapur",
    "Amravati",
    "Navi Mumbai",
    "Sangli",
    "Malegaon",
    "Jalgaon",
    "Akola",
    "Latur",
    "Dhule",
    "Ahmednagar",
    "Chandrapur",
    "Parbhani",
    "Jalna",
  ],
  "Manipur": [
    "Imphal",
    "Thoubal",
    "Bishnupur",
    "Churachandpur",
    "Ukhrul",
    "Senapati",
    "Tamenglong",
    "Jiribam",
    "Kakching",
    "Moreh",
  ],
  "Meghalaya": [
    "Shillong",
    "Tura",
    "Nongpoh",
    "Jowai",
    "Williamnagar",
    "Nongstoin",
    "Baghmara",
    "Resubelpara",
    "Mawkyrwat",
    "Khliehriat",
  ],
  "Mizoram": [
    "Aizawl",
    "Lunglei",
    "Saiha",
    "Champhai",
    "Kolasib",
    "Serchhip",
    "Lawngtlai",
    "Mamit",
    "Hnahthial",
    "Saitual",
  ],
  "Nagaland": [
    "Kohima",
    "Dimapur",
    "Mokokchung",
    "Tuensang",
    "Wokha",
    "Zunheboto",
    "Mon",
    "Phek",
    "Peren",
    "Longleng",
    "Kiphire",
  ],
  "Odisha": [
    "Bhubaneswar",
    "Cuttack",
    "Rourkela",
    "Berhampur",
    "Sambalpur",
    "Puri",
    "Balasore",
    "Bargarh",
    "Bhadrak",
    "Baripada",
    "Jharsuguda",
    "Jeypore",
    "Angul",
    "Dhenkanal",
    "Keonjhar",
    "Rayagada",
    "Paralakhemundi",
    "Koraput",
    "Malkangiri",
    "Nabarangpur",
  ],
  "Punjab": [
    "Chandigarh",
    "Ludhiana",
    "Amritsar",
    "Jalandhar",
    "Patiala",
    "Bathinda",
    "Mohali",
    "Hoshiarpur",
    "Batala",
    "Pathankot",
    "Moga",
    "Firozpur",
    "Kapurthala",
    "Muktsar",
    "Faridkot",
    "Rupnagar",
    "Sangrur",
    "Gurdaspur",
    "Tarn Taran",
    "Fazilka",
  ],
  "Rajasthan": [
    "Jaipur",
    "Jodhpur",
    "Udaipur",
    "Kota",
    "Ajmer",
    "Bikaner",
    "Alwar",
    "Bhilwara",
    "Sikar",
    "Pali",
    "Sri Ganganagar",
    "Hanumangarh",
    "Jhunjhunu",
    "Bharatpur",
    "Dausa",
    "Nagaur",
    "Barmer",
    "Churu",
    "Jaisalmer",
    "Tonk",
  ],
  "Sikkim": [
    "Gangtok",
    "Namchi",
    "Gyalshing",
    "Mangan",
    "Pelling",
    "Ravangla",
    "Jorethang",
    "Singtam",
    "Rangpo",
    "Melli",
  ],
  "Tamil Nadu": [
    "Chennai",
    "Coimbatore",
    "Madurai",
    "Tiruchirappalli",
    "Salem",
    "Erode",
    "Tirunelveli",
    "Vellore",
    "Thoothukudi",
    "Dindigul",
    "Thanjavur",
    "Karur",
    "Namakkal",
    "Cuddalore",
    "Kanchipuram",
    "Nagapattinam",
    "Tiruvannamalai",
    "Pudukkottai",
    "Sivaganga",
    "Viluppuram",
  ],
  "Telangana": [
    "Hyderabad",
    "Warangal",
    "Nizamabad",
    "Karimnagar",
    "Khammam",
    "Ramagundam",
    "Mahbubnagar",
    "Nalgonda",
    "Adilabad",
    "Suryapet",
    "Siddipet",
    "Miryalaguda",
    "Jagtial",
    "Mancherial",
    "Wanaparthy",
  ],
  "Tripura": [
    "Agartala",
    "Udaipur",
    "Dharmanagar",
    "Ambassa",
    "Kailasahar",
    "Belonia",
    "Khowai",
    "Sonamura",
    "Teliamura",
    "Bishalgarh",
  ],
  "Uttar Pradesh": [
    "Lucknow",
    "Kanpur",
    "Varanasi",
    "Agra",
    "Meerut",
    "Allahabad",
    "Noida",
    "Ghaziabad",
    "Jhansi",
    "Aligarh",
    "Moradabad",
    "Bareilly",
    "Gorakhpur",
    "Faizabad",
    "Mathura",
    "Firozabad",
    "Saharanpur",
    "Muzaffarnagar",
    "Rampur",
    "Shahjahanpur",
  ],
  "Uttarakhand": [
    "Dehradun",
    "Haridwar",
    "Rishikesh",
    "Nainital",
    "Mussoorie",
    "Roorkee",
    "Haldwani",
    "Kashipur",
    "Rudrapur",
    "Pithoragarh",
    "Almora",
    "Chamoli",
    "Pauri",
    "Uttarkashi",
    "Tehri",
  ],
  "West Bengal": [
    "Kolkata",
    "Howrah",
    "Durgapur",
    "Siliguri",
    "Asansol",
    "Darjeeling",
    "Malda",
    "Jalpaiguri",
    "Kharagpur",
    "Burdwan",
    "Murshidabad",
    "Bankura",
    "Midnapore",
    "Cooch Behar",
    "Purulia",
    "Raiganj",
    "Balurghat",
    "Krishnanagar",
    "Berhampore",
    "Haldia",
  ],
  "Andaman and Nicobar Islands": [
    "Port Blair",
    "Car Nicobar",
    "Mayabunder",
    "Rangat",
    "Diglipur",
  ],
  "Chandigarh": ["Chandigarh"],
  "Dadra and Nagar Haveli and Daman and Diu": ["Daman", "Diu", "Silvassa"],
  "Delhi": [
    "New Delhi",
    "Noida",
    "Gurgaon",
    "Faridabad",
    "Ghaziabad",
    "Dwarka",
    "Rohini",
    "Saket",
    "Janakpuri",
    "Pitampura",
  ],
  "Jammu and Kashmir": [
    "Srinagar",
    "Jammu",
    "Anantnag",
    "Baramulla",
    "Kathua",
    "Sopore",
    "Udhampur",
    "Bandipora",
    "Kupwara",
    "Pulwama",
  ],
  "Ladakh": ["Leh", "Kargil"],
  "Lakshadweep": ["Kavaratti", "Minicoy", "Andrott", "Agatti", "Kalpeni"],
  "Puducherry": ["Puducherry", "Karaikal", "Mahe", "Yanam"],
};

class LocationRealestatePage extends ConsumerStatefulWidget {
  final int? propertyId;
  const LocationRealestatePage(this.propertyId, {super.key});

  @override
  ConsumerState<LocationRealestatePage> createState() =>
      _LocationRealestatePageState();
}

class _LocationRealestatePageState
    extends ConsumerState<LocationRealestatePage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.propertyId != null && widget.propertyId != -1) {
      _fetchAndSetPropertyData();
    }
  }

  void _fetchAndSetPropertyData() async {
    final propertyId = widget.propertyId;
    if (propertyId == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final propertyDetail = await ref.read(
        propertyDetailProvider(propertyId).future,
      );
      final property = propertyDetail.property;
      if (property != null) {
        final locationParts = property.location?.split(", ");
        if (locationParts != null && locationParts.length == 2) {
          ref.read(stateProvider.notifier).state = locationParts[1];
          ref.read(cityProvider.notifier).state = property.location;
        }
        ref.read(localAreaControllerProvider).text = property.localArea ?? '';
        ref.read(completeAddressControllerProvider).text =
            property.completeAddress ?? '';
      } else {
        Fluttertoast.showToast(
          msg: "No property data found",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load property details: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.sp,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateList = stateToCities.keys.toList();
    final selectedState = ref.watch(stateProvider);
    final cityList =
        selectedState != null && stateToCities.containsKey(selectedState)
            ? stateToCities[selectedState]!
            : <String>[];
    final completeController = ref.watch(completeAddressControllerProvider);
    final localAreaController = ref.watch(localAreaControllerProvider);
    final selectedCity = ref.watch(cityProvider);
    final isUpdateMode = widget.propertyId != null && widget.propertyId != -1;

    void validateAndNavigate() {
      // if (isUpdateMode) {
      //   Fluttertoast.showToast(
      //     msg: "Location updates are not allowed",
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 12.sp,
      //   );
      //   return;
      // }

      if (selectedState == null) {
        Fluttertoast.showToast(
          msg: "Please select State",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      if (selectedCity == null) {
        Fluttertoast.showToast(
          msg: "Please select City",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      if (localAreaController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "Please Enter Local Address",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      if (completeController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "Please Enter Complete Address",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => UploadRealestatePage(widget.propertyId),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(backgroundColor: const Color(0xFFF5F5F5)),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        isUpdateMode
                            ? "View Location Details"
                            : "Location Details",
                        style: GoogleFonts.inter(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF030016),
                          letterSpacing: -1.3,
                        ),
                      ),
                      Text(
                        isUpdateMode
                            ? "Location details (read-only)"
                            : "Tell us about your Location",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9A97AE),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      _buildLabel("State"),
                      SizedBox(height: 10.h),
                      BuildDropDown(
                        hint: "Select State",
                        items: stateList,
                        value: selectedState,
                        onChange:
                            isUpdateMode
                                ? null
                                : (value) {
                                  ref.read(stateProvider.notifier).state =
                                      value;
                                  ref.read(cityProvider.notifier).state = null;
                                },
                      ),
                      SizedBox(height: 15.h),
                      _buildLabel("City"),
                      SizedBox(height: 10.h),
                      BuildDropDown(
                        hint: "Select City",
                        items: cityList,
                        value:
                            selectedCity != null &&
                                    cityList.contains(
                                      selectedCity.split(", ")[0],
                                    )
                                ? selectedCity.split(", ")[0]
                                : null,
                        onChange:
                            isUpdateMode
                                ? null
                                : (value) {
                                  if (value != null && selectedState != null) {
                                    ref.read(cityProvider.notifier).state =
                                        "$value, $selectedState";
                                  }
                                },
                      ),
                      SizedBox(height: 15.h),
                      _buildLabel("Locality Area"),
                      SizedBox(height: 10.h),
                      TextField(
                        controller: localAreaController,
                        enabled: !isUpdateMode,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 20.w,
                            right: 20.w,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFDADADA),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF00796B),
                              width: 2,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFDADADA),
                              width: 1.5,
                            ),
                          ),
                          hintText: "Enter Locality / Area",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9A97AE),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      _buildLabel("Complete Address"),
                      SizedBox(height: 10.h),
                      TextField(
                        controller: completeController,
                        enabled: !isUpdateMode,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 20.w,
                            right: 20.w,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFDADADA),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF00796B),
                              width: 2,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFDADADA),
                              width: 1.5,
                            ),
                          ),
                          hintText: "Enter Complete Address",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9A97AE),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      GestureDetector(
                        onTap: validateAndNavigate,
                        child: Container(
                          width: 392.w,
                          height: 53.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color:
                                // isUpdateMode
                                //     ? Colors.grey
                                //     :
                              const Color(0xFF00796B),
                          ),
                          child: Center(
                            child: Text(
                              // isUpdateMode ? "Update (Disabled)" :
                              "Continue",
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.gothicA1(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF030016),
      ),
    );
  }
}

class BuildDropDown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?)? onChange; // Made onChange nullable

  const BuildDropDown({
    super.key,
    required this.hint,
    required this.items,
    this.value,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      icon: const Icon(Icons.keyboard_arrow_down),
      value: value != null && items.contains(value) ? value : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFF00796B), width: 2.w),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
        ),
        hintText: value == null ? hint : null,
        hintStyle: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9A97AE),
          letterSpacing: -0.2,
        ),
      ),
      items: [
        DropdownMenuItem<String>(
          enabled: false,
          value: null,
          child: Text(
            hint,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9A97AE),
              letterSpacing: -0.2,
            ),
          ),
        ),
        ...items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF030016),
                letterSpacing: -0.2,
              ),
            ),
          );
        }).toList(),
      ],
      onChanged: onChange,
    );
  }
}
