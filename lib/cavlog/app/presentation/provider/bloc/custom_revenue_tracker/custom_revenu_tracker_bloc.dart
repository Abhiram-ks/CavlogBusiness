import 'package:barber_pannel/cavlog/app/data/models/booking_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/repositories/fetch_revenue_day_repo.dart';
import '../../../../domain/usecases/revenue_filtering_usecase.dart';
part 'custom_revenu_tracker_event.dart';
part 'custom_revenu_tracker_state.dart';

class CustomRevenuTrackerBloc extends Bloc<CustomRevenuTrackerEvent, CustomRevenuTrackerState> {
    final FetchRevenueDayRepository bookingRepository;
  CustomRevenuTrackerBloc(this.bookingRepository) : super(CustomRevenuTrackerInitial()) {
    on<RequstforTrackingRevenue>(_revenueCalculation);
  }

  Future<void> _revenueCalculation(
    RequstforTrackingRevenue event, 
    Emitter<CustomRevenuTrackerState> emit
  )async {
   emit(CustomRevenuTrackerLoading());

   try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');
      
      if (barberUid == null) {
        emit(CustomRevenuTrackerFailure('Shop ID not found. Please log in again.'));
        return;
      }
      try {
        final timeRengeBookings =  bookingRepository.fetchByDay(barberId: barberUid, startDate: event.startTime, endDate: event.endTime);

        await emit.forEach<List<BookingModel>>(
          timeRengeBookings, 
          onData: (bookings) {
            if (bookings.isEmpty) {
               return CustomRevenuTrackerEmptys();
            }

            final revenueUseCase = RevenueFilteringUsecase();
            final double totalEarnings = revenueUseCase.calculateEarningsForPeriod(bookings);
            final String completedSessions = revenueUseCase.totalBookings(bookings);
             final String workingHoursStr = revenueUseCase.calculateTotalWorkingHours(bookings);
            final topServiceData = revenueUseCase.extractTopServices(bookings);
            final List<double> segmentValues = (topServiceData['segmentValues'] as List<dynamic>).map((e) => e as double).toList();
            final List<String> topServices = (topServiceData['topServices'] as List<dynamic>).map((e) => e as String).toList();
            final List<String> topServicesAmount = (topServiceData['topServicesAmount'] as List<dynamic>).map((e) => e as String).toList();
            
             
            final graphData = RevenueGraphGeneratorCustom.generateGraphDataFromRangeCustom(bookings: bookings, startDate: event.startTime, endDate: event.endTime);

            return CustomRevenuTrackerLoaded(
              totalEarnings: totalEarnings, 
              workingMinutes: workingHoursStr,
              completedSessions: completedSessions, 
              segmentValues: segmentValues, 
              topServices: topServices, 
              topServicesAmount: topServicesAmount, 
              graphValues: (graphData['graphValues'] as List<dynamic>).map((e) => e as double).toList(), 
              graphLabels: (graphData['graphLabels'] as List<dynamic>).map((e) => e as String).toList(), 
              maxY: graphData['maxY'], 
              minY: graphData['minY']);
          }, onError: (error, stackTrace) {
            return CustomRevenuTrackerFailure('Failed to load revenue data: ${error.toString()}');
          },
          );
          
      } catch (e) {
         emit(CustomRevenuTrackerFailure('An error occurred: ${e.toString()}'));
      }
   } catch (e) {
     emit(CustomRevenuTrackerFailure('An error occurred: ${e.toString()}'));
   }
  }
}
