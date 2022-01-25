import 'package:flutter/material.dart';
import 'package:hey_voltz/api/api_service.dart';
import 'package:hey_voltz/api/dto/models.dart';
import 'package:hey_voltz/helpers/prefs.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/widgets/toasty.dart';
import 'package:provider/provider.dart';

import 'widget/appbar.dart';
import 'widget/searchbox.dart';

class StoreFragment extends StatefulWidget {
  StoreFragment({
    Key? key,
  }) : super(key: key);

  @override
  _StoreFragmentState createState() => _StoreFragmentState();
}

class _StoreFragmentState extends State<StoreFragment> {
  final TextEditingController _controller = TextEditingController();

  List<Product> products = [];

  String category = '';
  String? token;

  //States
  bool isApiLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  fetchProducts() async {
    token ??= await fetchPersistedToken();
    String name = _controller.text.trim();

    setState(() {
      isApiLoading = true;
    });

    products.clear();

    print(name);

    await Provider.of<ApiService>(context, listen: false)
        .fetchProducts(token!, name, category)
        .then((response) {
      print(response.statusCode);
      if (response.isSuccessful) {
        for (var item in response.body) {
          var product = Product.fromJson(item);
          products.add(product);
        }
        setState(() {
          isApiLoading = false;
        });
      } else {
        Toasty(context).showToastErrorMessage(
            message: 'Could not fetch items due to server error');
        setState(() {
          isApiLoading = true;
        });
      }
    }).catchError((err) {
      Toasty(context).showToastErrorMessage(
          message: 'Could not fetch items due to app error');
      //ignore:avoid_print
      print('MarketPlace err --> ' + err.runtimeType.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        children: [
          //Appbar
          buildAppBarForMarketplace(deviceWidth),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SearchBox
                    SearchBox(
                      deviceWidth: deviceWidth,
                      controller: _controller,
                      onTap: () => fetchProducts(),
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: List.generate(products.length, (index) {
                        return Material(
                          elevation: 2,
                          child: Container(
                            height: 250,
                            width: (deviceWidth - 55) / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  height: 150,
                                  width: deviceWidth,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            products[index].images[0].url),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: deviceWidth,
                                    height: 100,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          products[index].name,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          products[index].name,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Text(
                                              '₦${products[index].name}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                            const Text(
                                              'View',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: colorAccent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    //ListOfProducts
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
