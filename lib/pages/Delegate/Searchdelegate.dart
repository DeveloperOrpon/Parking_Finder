import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_finder/controller/GarageController.dart';
import 'package:parking_finder/model/garage_model.dart';

class ParkingSearchDelegate extends SearchDelegate {
  GarageController garageController;

  List<String> cities = [];

  List<String> recentCities = [];

  ParkingSearchDelegate(this.garageController);

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.commit, size: 120),
            const SizedBox(height: 48),
            Text(
              query,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    cities = [];
    recentCities = [];
    for (GarageModel garageModel in garageController.activeGarageList) {
      cities.add(garageModel.city);
      recentCities.add(garageModel.division);
    }
    final suggestions = query.isEmpty
        ? recentCities
        : cities.where((city) {
            final cityLower = city.toLowerCase();
            final queryLower = query.toLowerCase();

            return cityLower.startsWith(queryLower);
          }).toList();

    return buildSuggestionsSuccess(suggestions);
  }

  Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final queryText = suggestion.substring(0, query.length);
          final remainingText = suggestion.substring(query.length);

          return ListTile(
            onTap: () {
              query = suggestion;
              Get.back();
            },
            leading: Icon(Icons.location_city),
            // title: Text(suggestion),
            title: RichText(
              text: TextSpan(
                text: queryText,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: remainingText,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
