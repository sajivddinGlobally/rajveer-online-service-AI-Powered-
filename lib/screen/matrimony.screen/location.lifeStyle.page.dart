




import 'package:ai_powered_app/screen/matrimony.screen/interest.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/providers/profileGetDataProvider.dart';

final countryProvider = StateProvider<String?>((ref) => "India",); // Default to India
final statelistProvider = StateProvider<String?>((ref) => null);
final citylistProvider = StateProvider<String?>((ref) => null);
final livingStatuslistProvider = StateProvider<String?>((ref) => null);
final dietlistProvider = StateProvider<String?>((ref) => null);
final smokinglistProvider = StateProvider<String?>((ref) => null);
final drinkinglistProvider = StateProvider<String?>((ref) => null);

// Define state-to-city mappings for all Indian states and Union Territories
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
    "Zunheboto", "Mon", "Phek", "Peren", "Longleng,"
        "Kiphire"
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

class LocationLifestylePage extends ConsumerWidget {
  const LocationLifestylePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider);
    final country = ref.watch(countryProvider);
    final state = ref.watch(statelistProvider);
    final city = ref.watch(citylistProvider);
    final livingStatus = ref.watch(livingStatuslistProvider);
    final smoking = ref.watch(smokinglistProvider);
    final drinking = ref.watch(drinkinglistProvider);

    final countrylist = ["India"];
    final statelist = [
      "Andhra Pradesh",
      "Arunachal Pradesh",
      "Assam",
      "Bihar",
      "Chhattisgarh",
      "Goa",
      "Gujarat",
      "Haryana",
      "Himachal Pradesh",
      "Jharkhand",
      "Karnataka",
      "Kerala",
      "Madhya Pradesh",
      "Maharashtra",
      "Manipur",
      "Meghalaya",
      "Mizoram",
      "Nagaland",
      "Odisha",
      "Punjab",
      "Rajasthan",
      "Sikkim",
      "Tamil Nadu",
      "Telangana",
      "Tripura",
      "Uttar Pradesh",
      "Uttarakhand",
      "West Bengal",
      "Andaman and Nicobar Islands",
      "Chandigarh",
      "Dadra and Nagar Haveli and Daman and Diu",
      "Delhi",
      "Jammu and Kashmir",
      "Ladakh",
      "Lakshadweep",
      "Puducherry",
    ];
    final citylist = state != null && stateToCities.containsKey(state) ? stateToCities[state]! : <String>[];
    final livingStatuslist = ["With Parents", "Alone", "With Roommates"];
    final dietlist = ["Vegetarian", "Non-vegetarian", "Both"];
    final smokinglist = ["Yes", "No"];
    final drinkinglist = ["Yes", "No"];


    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (country != null && !countrylist.contains(country)) {
        ref.read(countryProvider.notifier).state = "India"; // Default to India
      }
      if (state != null && !statelist.contains(state)) {
        ref.read(statelistProvider.notifier).state = null;
      }
      if (city != null && !citylist.contains(city)) {
        ref.read(citylistProvider.notifier).state = null;
      }
    });
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(backgroundColor: const Color(0xFFFDF6F8)),
      body:
      profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ref.read(countryProvider) == null) {
              ref.read(countryProvider.notifier).state =
              "India"; // Default to India
            }
            if (ref.read(statelistProvider) == null) {
              ref.read(statelistProvider.notifier).state =
              statelist.contains(profile.data.profile.state)
                  ? profile.data.profile.state
                  : null;
            }
            if (ref.read(citylistProvider) == null) {
              ref.read(citylistProvider.notifier).state =
              citylist.contains(profile.data.profile.city)
                  ? profile.data.profile.city
                  : null;
            }
            if (ref.read(livingStatuslistProvider) == null) {
              ref.read(livingStatuslistProvider.notifier).state =
              livingStatuslist.contains(profile.data.profile.livingStatus)
                  ? profile.data.profile.livingStatus
                  : null;
            }
            if (ref.read(dietlistProvider) == null) {
              ref.read(dietlistProvider.notifier).state =
              dietlist.contains(profile.data.profile.drink)
                  ? profile.data.profile.drink
                  : null;
            }
            if (ref.read(smokinglistProvider) == null) {
              ref.read(smokinglistProvider.notifier).state =
              smokinglist.contains(profile.data.profile.smoke)
                  ? profile.data.profile.smoke
                  : null;
            }
            if (ref.read(drinkinglistProvider) == null) {
              ref.read(drinkinglistProvider.notifier).state =
              drinkinglist.contains(profile.data.profile.drink)
                  ? profile.data.profile.drink
                  : null;
            }
          });

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location & Lifestyle",
                    style: GoogleFonts.gothicA1(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF030016),
                    ),
                  ),
                  Text(
                    "Where Do You Live?",
                    style: GoogleFonts.gothicA1(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9A97AE),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  BuildDropDown(
                    hint: "Select Country",
                    items: countrylist,
                    value: country,
                    onChange: (value) {
                      ref.read(countryProvider.notifier).state =
                          value ?? "India";
                      // Reset state and city when country changes
                      ref.read(statelistProvider.notifier).state = null;
                      ref.read(citylistProvider.notifier).state = null;
                    },
                  ),
                  SizedBox(height: 15.h),
                  BuildDropDown(
                    hint: "Select State",
                    items: statelist,
                    value: state,
                    onChange: (value) {
                      ref.read(statelistProvider.notifier).state = value;
                      // Reset city when state changes
                      ref.read(citylistProvider.notifier).state = null;
                    },
                  ),
                  SizedBox(height: 15.h),
                  BuildDropDown(
                    hint: "Select City",
                    items: citylist,
                    value: city,
                    onChange:
                        (value) =>
                    ref.read(citylistProvider.notifier).state = value,
                  ),
                  SizedBox(height: 15.h),
                  BuildDropDown(
                    hint: "Select Living Status",
                    items: livingStatuslist,
                    value: livingStatus,
                    onChange:
                        (value) =>
                    ref.read(livingStatuslistProvider.notifier).state =
                        value,
                  ),
                  SizedBox(height: 15.h),
                  BuildDropDown(
                    hint: "Do you Smoke?",
                    items: smokinglist,
                    value: smoking,
                    onChange:
                        (value) =>
                    ref.read(smokinglistProvider.notifier).state =
                        value,
                  ),
                  SizedBox(height: 15.h),
                  BuildDropDown(
                    hint: "Do you Drink?",
                    items: drinkinglist,
                    value: drinking,
                    onChange:
                        (value) =>
                    ref.read(drinkinglistProvider.notifier).state =
                        value,
                  ),
                  SizedBox(height: 15.h),

                  SizedBox(height: 25.h),
                  GestureDetector(
                    onTap: () {
                      // Validate all fields before navigating
                      if (country == null ||
                          state == null ||
                          city == null ||
                          livingStatus == null ||
                          smoking == null ||
                          drinking == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all required fields"),
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const InterestPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 53.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: const Color(0xFF97144d),
                      ),
                      child: Center(
                        child: Text(
                          "Continue",
                          style: GoogleFonts.gothicA1(
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
          );
        },
      ),
    );
  }
}

// Custom dropdown widget
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
          borderSide: BorderSide(color: const Color(0xFF97144d), width: 2.w),
        ),
        hintText: value == null ? hint : null,
        hintStyle: GoogleFonts.gothicA1(
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
            style: GoogleFonts.gothicA1(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9A97AE), // Gray color for hint
              letterSpacing: -0.2,
            ),
          ),
        ),
        ...items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.gothicA1(
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
}