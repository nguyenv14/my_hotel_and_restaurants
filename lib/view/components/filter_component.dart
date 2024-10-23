import 'package:flutter/material.dart';

class HotelFilterComponent extends StatefulWidget {
  final String title;
  final List<String> sortOptions;
  final int initialStarRating;
  final String initialHotelType;
  final double initialMinPrice;
  final double initialMaxPrice;
  final VoidCallback onApply;

  const HotelFilterComponent({
    Key? key,
    required this.title,
    required this.sortOptions,
    this.initialStarRating = 4,
    this.initialHotelType = 'Khách sạn',
    this.initialMinPrice = 100,
    this.initialMaxPrice = 500,
    required this.onApply,
  }) : super(key: key);

  @override
  _HotelFilterComponentState createState() => _HotelFilterComponentState();
}

class _HotelFilterComponentState extends State<HotelFilterComponent> {
  late String _selectedSort;
  late double _currentMinPrice;
  late double _currentMaxPrice;
  late int _selectedStar;
  late String _selectedHotelType;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.sortOptions.first;
    _currentMinPrice = widget.initialMinPrice;
    _currentMaxPrice = widget.initialMaxPrice;
    _selectedStar = widget.initialStarRating;
    _selectedHotelType = widget.initialHotelType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Sort By',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: _selectedSort,
            icon: Icon(Icons.arrow_downward),
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                _selectedSort = newValue!;
              });
            },
            items: widget.sortOptions
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Text(
            'Hotel Ranking',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStar = index + 1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        _selectedStar == index + 1 ? Colors.pink : Colors.white,
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
                      Icon(
                        Icons.star,
                        color: _selectedStar == index + 1
                            ? Colors.white
                            : Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHotelTypeButton('Khách sạn'),
              _buildHotelTypeButton('Khu nghỉ dưỡng'),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Price Ranges',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          RangeSlider(
            values: RangeValues(_currentMinPrice, _currentMaxPrice),
            min: 100,
            max: 1000,
            divisions: 10,
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
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_currentMinPrice.toStringAsFixed(0)}k'),
              Text('${_currentMaxPrice.toStringAsFixed(0)}k'),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: widget.onApply,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'APPLY',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelTypeButton(String type) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedHotelType = type;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor:
            _selectedHotelType == type ? Colors.pink : Colors.white,
        side: BorderSide(color: Colors.pink),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: _selectedHotelType == type ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
