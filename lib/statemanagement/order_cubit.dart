import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../vo/order_item.dart';

class OrderCubit extends Cubit<List<OrderItem>> {
  final Logger logger = Logger();

  OrderCubit() : super([]);

  bool addOrderItem(OrderItem newItem, int selectedQty) {
    logger.d('Attempting to add item: ${newItem.itemId}, selectedQty: $selectedQty');

    // Check if the item already exists in the list
    int existingIndex = state.indexWhere((item) => item.itemId == newItem.itemId);
    logger.d('Existing index for item ${newItem.itemId}: $existingIndex');

    if (existingIndex != -1) {
      int existingQty = state[existingIndex].qty;
      logger.d('Existing quantity for item ${newItem.itemId}: $existingQty');

      // Item already exists, update the quantity
      if (existingQty + selectedQty > 1000) {
        // Cannot exceed max limit (1000)
        logger.w('Cannot add item ${newItem.itemId}. Maximum limit of 1000 exceeded.');
        return false;
      }

      int newQty = existingQty + selectedQty;
      logger.d('Updating quantity for item ${newItem.itemId} to $newQty');
      updateOrderQty(newItem, newQty);
      return true;
    } else {
      // Item doesn't exist, add it to the list
      newItem.qty = selectedQty;
      state.add(newItem);
      logger.d('Adding new item ${newItem.itemId} with quantity $selectedQty');
      emit(List.from(state));
      return true;
    }
  }

  void removeOrderItem(OrderItem itemToRemove) {
    final index = state.indexWhere((item) => item.itemId == itemToRemove.itemId);
    if (index != -1) {
      state.removeAt(index);
      logger.d('Removed item ${itemToRemove.itemId} from the order');
      emit(List.from(state));
    } else {
      logger.w('Item ${itemToRemove.itemId} not found in the order');
    }
  }

  void updateOrderQty(OrderItem itemToUpdate, int newQty) {
    final index = state.indexWhere((item) => item.itemId == itemToUpdate.itemId);
    if (index != -1) {
      state[index].qty= newQty;
      logger.d('Updated quantity for item ${itemToUpdate.itemId} to $newQty');
      emit(List.from(state));
    } else {
      logger.w('Item ${state[index].itemId} not found in the order');
    }
  }
}
