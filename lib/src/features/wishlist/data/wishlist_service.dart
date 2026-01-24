import 'dart:async';
import 'models/wishlist_item_model.dart';

class WishlistService {
  final String userId;

  WishlistService({required this.userId});

  final List<WishlistItem> _wishlist = [];

  final StreamController<List<WishlistItem>> _wishlistController =
  StreamController<List<WishlistItem>>.broadcast();

  Stream<List<WishlistItem>> getWishlistStream() {
    Future.microtask(() {
      _wishlistController.add(List.unmodifiable(_wishlist));
    });
    return _wishlistController.stream;
  }

  void _emit() {
    _wishlistController.add(List.unmodifiable(_wishlist));
  }

  bool isInWishlist(String productId) {
    return _wishlist.any((item) => item.id == productId);
  }

  Future<void> addToWishlist(WishlistItem item) async {
    if (!isInWishlist(item.id)) {
      _wishlist.add(item);
      _emit();
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    _wishlist.removeWhere((item) => item.id == productId);
    _emit();
  }

  void clearWishlist() {
    _wishlist.clear();
    _emit();
  }

  void dispose() {
    _wishlistController.close();
  }
}
