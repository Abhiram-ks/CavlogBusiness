import 'package:bloc/bloc.dart';


enum RevenueFilter {today,weekly, mothely, yearly}
class RevenueDashbordCubit extends Cubit<RevenueFilter> {
  RevenueDashbordCubit() : super(RevenueFilter.today);
  void setFilter(RevenueFilter filter) => emit(filter);
}
