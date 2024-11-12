import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/data/area_enum.dart';
import 'package:my_hotel_and_restaurants/data/sort_restaurant.dart';
import 'package:my_hotel_and_restaurants/view_model/search_view_model.dart';

class FilterRestaurantComponent extends StatefulWidget {
  final String title;
  final List<String> sortOptions;
  final int initialStarRating;
  final SearchViewModel searchViewModel;
  final VoidCallback? onTabHotel1; // Nullable callback
  final VoidCallback? onTabHotel2; // Nullable callback
  final VoidCallback onApply;
  final bool showPriceRange; // New parameter
  final bool showHotelButtons; // New parameter

  const FilterRestaurantComponent({
    super.key,
    required this.title,
    required this.sortOptions,
    this.onTabHotel1,
    this.onTabHotel2,
    this.initialStarRating = 4,
    required this.onApply,
    this.showPriceRange = true,
    this.showHotelButtons = true,
    required this.searchViewModel,
  });

  @override
  _FilterRestaurantComponentState createState() =>
      _FilterRestaurantComponentState();
}

class _FilterRestaurantComponentState extends State<FilterRestaurantComponent> {
  int _selectedSort = 0;
  int _selectedArea = 0;
  late int _selectedStar;
  TextEditingController textCategory = TextEditingController();
  TextEditingController areaText = TextEditingController();
  int indexHotelType = 0;
  @override
  void initState() {
    super.initState();
    _selectedStar = widget.initialStarRating;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: ColorData.myColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sort By',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: context.mediaQueryWidth * 0.4,
                height: 60,
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: 170,
                        child: CustomDropdown(
                            onChanged: (p0) {
                              print(p0);
                              setState(() {
                                _selectedSort =
                                    SortRestaurant.getIdFromName(p0)!;
                              });
                            },
                            hintText: "Sort",
                            items: SortRestaurant.getAreaNames(),
                            controller: textCategory),
                      )
                    ]),
              ),
              SizedBox(
                width: context.mediaQueryWidth * 0.4,
                height: 60,
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: 170,
                        child: CustomDropdown(
                            onChanged: (p0) {
                              setState(() {
                                _selectedArea = Area.getIdFromName(p0)!;
                              });
                            },
                            hintText: "Địa điểm",
                            items: Area.getAreaNames(),
                            controller: areaText),
                      )
                    ]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Restaurant Ranking',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStar = index + 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _selectedStar == index + 1
                        ? ColorData.myColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: _selectedStar == index + 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.star,
                        color: _selectedStar == index + 1
                            ? Colors.yellow
                            : Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              widget.searchViewModel.filter('', _selectedStar, _selectedArea, 0,
                  4000, _selectedSort, 0, 0);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorData.myColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'APPLY',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
