import 'package:bloc/bloc.dart';

class CartCubit extends Cubit<int> {
  CartCubit() : super(0);
  void addToCart(int value) => emit(state + value);
  void removeFromCart() => emit(state - 1 > 0 ? state - 1 : 0);
}
