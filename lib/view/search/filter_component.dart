import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/data/area_enum.dart';
import 'package:my_hotel_and_restaurants/data/sort_hotel.dart';
import 'package:my_hotel_and_restaurants/view/components/button_select_component.dart';
import 'package:my_hotel_and_restaurants/view_model/search_view_model.dart';

class FilterComponent extends StatefulWidget {
  final String title;
  final SearchViewModel searchViewModel;
  final List<String> sortOptions;
  final int initialStarRating;
  final String initialHotelType;
  final double initialMinPrice;
  final double initialMaxPrice;
  final VoidCallback? onTabHotel1; // Nullable callback
  final VoidCallback? onTabHotel2; // Nullable callback
  final VoidCallback onApply;
  final bool showPriceRange; // New parameter
  final bool showHotelButtons; // New parameter

  const FilterComponent({
    super.key,
    required this.title,
    required this.sortOptions,
    this.onTabHotel1,
    this.onTabHotel2,
    this.initialStarRating = 4,
    this.initialHotelType = 'Khách sạn',
    this.initialMinPrice = 100,
    this.initialMaxPrice = 500,
    required this.onApply,
    this.showPriceRange = true,
    this.showHotelButtons = true,
    required this.searchViewModel,
  });

  @override
  _FilterComponentState createState() => _FilterComponentState();
}

class _FilterComponentState extends State<FilterComponent> {
  int _selectedSort = 0;
  int areaId = 0;
  late double _currentMinPrice;
  late double _currentMaxPrice;
  late int _selectedStar;
  TextEditingController textCategory = TextEditingController();
  TextEditingController areaText = TextEditingController();
  List<String> listHotelType = [
    "Khách sạn",
    "Khách sạn căn hộ",
    "Khu nghỉ dưỡng"
  ];
  int indexHotelType = 0;
  @override
  void initState() {
    super.initState();
    _currentMinPrice = widget.initialMinPrice;
    _currentMaxPrice = widget.initialMaxPrice;
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
                            onChanged: (p1) {
                              setState(() {
                                _selectedSort = SortHotel.getIdFromName(p1)!;
                              });
                            },
                            hintText: "Sort",
                            items: SortHotel.getAreaNames(),
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
                                areaId = Area.getIdFromName(p0)!;
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
            'Hotel Ranking',
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
          SizedBox(
            width: context.mediaQueryWidth,
            height: context.mediaQueryWidth * 0.12,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: listHotelType.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: ButtonSelectComponent(
                    index: index,
                    hotelString: listHotelType[index],
                    selectedIndex: indexHotelType,
                    onTap: (p0) {
                      setState(() {
                        indexHotelType = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (widget.showPriceRange) ...[
            const Text(
              'Price Ranges',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RangeSlider(
              values: RangeValues(_currentMinPrice, _currentMaxPrice),
              min: 100,
              max: 4000,
              divisions: 10,
              activeColor: ColorData.myColor,
              labels: RangeLabels(
                '${_currentMinPrice.toStringAsFixed(0)}k',
                '${_currentMaxPrice.toStringAsFixed(0)}k',
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentMinPrice = values.start;
                  _currentMaxPrice = values.end;
                });
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_currentMinPrice.toStringAsFixed(0)}k'),
                Text('${_currentMaxPrice.toStringAsFixed(0)}k'),
              ],
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              widget.searchViewModel.filter(
                  "",
                  _selectedStar,
                  areaId,
                  _currentMinPrice.toInt(),
                  _currentMaxPrice.toInt(),
                  _selectedSort,
                  indexHotelType,
                  1);
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
