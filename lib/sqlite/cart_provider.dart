import 'package:hey_voltz/api/dto/models.dart';
import 'package:hey_voltz/sqlite/db_helper.dart';
import 'package:hey_voltz/sqlite/models.dart';

class CartProvider {
  Future<List<CartItem>> getCartItems() async {
    List<CartItem> cartitems = [];
    await DBHelper.instance.getAllItems().then((value) {
      cartitems = value;
    }).catchError((err) {
      print('CartProvider getCartItems --> ' + err.runtimeType.toString());
    });
    return cartitems;
  }

  Future<bool> addToCart(Product product, {int quantity = 1}) async {
    CartItem cartItem = CartItem(
        id: product.id,
        name: product.name,
        image: product.images[0].url,
        price: product.price,
        quantity: quantity);
    return await DBHelper.instance.addToCart(cartItem);
  }

  Future<bool> updateCartItem(CartItem cartItem) async {
    return await DBHelper.instance.updateQuantity(cartItem: cartItem);
  }

  Future<bool> deleteCartItem(CartItem cartItem) async {
    return await DBHelper.instance.deleteCartItem(cartItem: cartItem);
  }

  Future<bool> clearCart() async {
    return await DBHelper.instance.truncateCart();
  }
}
