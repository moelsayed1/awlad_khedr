import 'dart:convert';

import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:flutter/material.dart';

import '../../../../constant.dart';
import 'package:http/http.dart' as http;

import '../../../../main.dart';

class TopRatedItem extends StatefulWidget {
  const TopRatedItem({super.key,});

  @override
  State<TopRatedItem> createState() => _TopRatedItemState();
}

class _TopRatedItemState extends State<TopRatedItem> {
  TopRatedModel? topRatedItem;
  bool isListLoaded = false;

  GetTopRatedItems() async {
    Uri uriToSend = Uri.parse(APIConstant.GET_TOP_RATED_ITEMS);
    final response = await http.get(uriToSend, headers: {"Authorization" : "Bearer $authToken"});
    if (response.statusCode == 200) {
      topRatedItem = TopRatedModel.fromJson(jsonDecode(response.body));
    }
    if (mounted) {
      setState(() {
        isListLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    GetTopRatedItems();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: isListLoaded
          ? ListView.separated(
              itemCount: topRatedItem?.products.length ?? 0,
              separatorBuilder: (BuildContext context, int index) => const SizedBox(
                width: 15,
              ),
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: 156,
                    height: 193,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).height * .15,
                          color: Colors.transparent,
                          child: topRatedItem?.products[index].imageUrl != null
                              ? Image.network(
                                  topRatedItem!.products[index].imageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  AssetsData.callCenter,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const Spacer(),
                        SingleChildScrollView(
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 16),
                              const SizedBox(width: 4),
                              const Text(
                                '4.5',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                child: Text(
                                  topRatedItem?.products[index].productName ?? '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: baseFont,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
