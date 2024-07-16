import 'package:flutter_bloc/flutter_bloc.dart';

import '../vo/order_item.dart';

class OrderCubit extends Cubit<List<OrderItem>> {
  OrderCubit() : super([]);

  bool addOrderItem(OrderItem newItem, int selectedQty) {
    // Check if the item already exists in the list
    int existingIndex = state.indexWhere((item) => item.itemId == newItem.itemId);

    int selQty = selectedQty; //for debug
    if (existingIndex != -1) {
      int existingQty = state[existingIndex].qty;
      // Item already exists, update the quantity
      if( existingQty + selQty > 100){
        //cannot exceed max limit (100)
        return false;
      }

      int newQty = existingQty + selQty;
      updateOrderQty(state[existingIndex], newQty);
      return true;
    } else {
      // Item doesn't exist, add it to the list
      newItem.qty = selectedQty;
      state.add(newItem);
      emit(List.from(state));
      return true;
    }
  }

  void removeOrderItem(OrderItem itemToRemove) {
    final index = state.indexWhere((item) => item.itemId == itemToRemove.itemId);
    state.removeAt(index);
    emit(List.from(state));
  }

  void updateOrderQty(OrderItem itemToUpdate, int newQty) {
    final index = state.indexWhere((item) => item.itemId == itemToUpdate.itemId);
   // final index = state.indexOf(itemToUpdate);
    if (index != -1) {
      state[index].qty = newQty;
      emit(List.from(state));
    }
  }
}
