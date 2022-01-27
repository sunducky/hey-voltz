import 'dart:io';

import 'package:hey_voltz/api/dto/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models.dart';

class DBHelper {
  DBHelper._privateConstructor();

  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'voltz.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE cart (
      id INTEGER PRIMARY KEY,      
      name TEXT,
      quantity INTEGER,
      image TEXT,
      price DOUBLE
    )
    ''');
  }

  //READ
  ///Fetch All items
  Future<List<CartItem>> getAllItems() async {
    List<CartItem> cartitems = [];
    _database ??= await instance.database;

    List<Map<String, dynamic>> maps = await _database!.query('cart');

    for (var item in maps) {
      CartItem cartItem = CartItem.fromJson(item);
      cartitems.add(cartItem);
    }

    return cartitems;
  }

  //CREATE
  ///Adds a product item to cart table
  ///and increases quantity if it exists in table
  Future<bool> addToCart(CartItem cartItem) async {
    _database ??= await instance.database;
    //Check if item exists in db
    var item = await _database!
        .query('cart', where: 'id = ?', whereArgs: [cartItem.id]);
    if (item.isNotEmpty) {
      //Meaning item exists. Just increase quantity
      CartItem x = CartItem.fromJson(item.first);
      cartItem.quantity = cartItem.quantity + x.quantity;
      return await updateQuantity(cartItem: cartItem);
    } else {
      //Item does not exist. dd to caart
      int id = await _database!.insert('cart', cartItem.toJson());
      return id > 0;
    }
  }

  //UPDATE
  ///Updates quantity
  Future<bool> updateQuantity({required CartItem cartItem}) async {
    _database ??= await instance.database;

    int count = await _database!.update('cart', cartItem.toJson(),
        where: 'id = ?', whereArgs: [cartItem.id]);
    return count > 0;
  }

  //DELETE
  Future<bool> deleteCartItem({required CartItem cartItem}) async {
    _database ??= await instance.database;
    int count = await _database!
        .delete('cart', where: 'id = ?', whereArgs: [cartItem.id]);
    return count > 0;
  }
}
