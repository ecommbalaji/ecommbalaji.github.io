import 'package:bloc/bloc.dart';

class CartCubit extends Cubit<int> {
  CartCubit() : super(0);
  void addToCart(int value) => emit(state + value);
  void removeFromCart(int value) => emit(state - value > 0 ? state - value : 0);
}
