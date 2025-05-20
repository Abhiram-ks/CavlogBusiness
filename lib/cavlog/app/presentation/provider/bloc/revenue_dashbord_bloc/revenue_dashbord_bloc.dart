import 'package:barber_pannel/cavlog/app/data/models/booking_model.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_revenue_day_repo.dart';
import 'package:barber_pannel/cavlog/app/domain/usecases/date_formalting_usecase.dart';
import 'package:barber_pannel/cavlog/app/domain/usecases/revenue_filtering_usecase.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/revenue_dashbord_cubit/revenue_dashbord_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'revenue_dashbord_event.dart';
part 'revenue_dashbord_state.dart';

class RevenueDashbordBloc extends Bloc<RevenueDashbordEvent, RevenueDashbordState> {
  final FetchRevenueDayRepository bookingRepository;
  
  RevenueDashbordBloc(this.bookingRepository) : super(RevenueDashbordInitial()) {
    on<LoadRevenueData>(_revenueCalculation);
  }

  Future<void> _revenueCalculation(
    LoadRevenueData event, 
    Emitter<RevenueDashbordState> emit
  ) async {
    emit(RevenueDashbordLoading());

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? barberUid = prefs.getString('barberUid');
      
      if (barberUid == null) {
        emit(RevenuDahsbordFailure('Shop ID not found. Please log in again.'));
        return;
      }
      
      try {
        final DateTimeRange currentPeriodRange = RevenueDateCalculater.getDateRange(event.filter);
        final DateTime currentStartDate = currentPeriodRange.start;
        final DateTime currentEndDate = currentPeriodRange.end;
        
        final DateTimeRange previousPeriodRange = RevenueDateCalculater.getPreviousPeriodRange(event.filter);
        final DateTime previousStartDate = previousPeriodRange.start;
        final DateTime previousEndDate = previousPeriodRange.end;

        final List<BookingModel> previousBookings = await bookingRepository.fetchByDay(
          barberId: barberUid,
          startDate: previousStartDate,
          endDate: previousEndDate,
        ).first;
 
        final currentPeriodStream = bookingRepository.fetchByDay(
          barberId: barberUid,
          startDate: currentStartDate,
          endDate: currentEndDate,
        );
        
        await emit.forEach<List<BookingModel>>(
          currentPeriodStream,
          onData: (currentBookings) {
            final revenueUseCase = RevenueFilteringUsecase();
            
            final double totalEarnings = revenueUseCase.calculateEarningsForPeriod(currentBookings);
            final double percentageGrowth = calculateGrowthPercentageSync(
              currentBookings, 
              previousBookings
            );
            final bool isGrowthPositive = totalEarnings >= revenueUseCase.calculateEarningsForPeriod(previousBookings);
            final String completedSessions = revenueUseCase.totalBookings(currentBookings);
            final String workingHoursStr = revenueUseCase.calculateTotalWorkingHours(currentBookings);
          
            final topServiceData = revenueUseCase.extractTopServices(currentBookings);
            final List<double> segmentValues = (topServiceData['segmentValues'] as List<dynamic>).map((e) => e as double).toList();
            final List<String> topServices = (topServiceData['topServices'] as List<dynamic>).map((e) => e as String).toList();
            final List<String> topServicesAmount = (topServiceData['topServicesAmount'] as List<dynamic>).map((e) => e as String).toList();
            

            final graphData = RevenueGraphGenerator.generateGraphData(
              bookings: currentBookings,
              filter: event.filter,
            );
         
            return RevenuDahsbordLoaded(
              totalEarnings: totalEarnings,
              percentageGrowth: percentageGrowth,
              workingMinutes: workingHoursStr ,
              completedSessions: completedSessions,
              segmentValues: segmentValues,
              topServices: topServices,
              isGrowth: isGrowthPositive,
              topServicesAmount: topServicesAmount,
              graphLabels: (graphData['graphLabels'] as List<dynamic>).map((e) => e as String).toList(),
              graphValues: (graphData['graphValues'] as List<dynamic>).map((e) => e as double).toList(),
              maxY: graphData['maxY'],
              minY: graphData['minY'],
            );
          },
          onError: (error, stackTrace) {
            return RevenuDahsbordFailure('Failed to load revenue data: ${error.toString()}');
          },
        );
      } catch (e) {
        emit(RevenuDahsbordFailure('An error occurred: ${e.toString()}'));
      }
    } catch (e) {
      emit(RevenuDahsbordFailure('An error occurred: ${e.toString()}'));
    }
  }
  

  double calculateGrowthPercentageSync(List<BookingModel> currentBookings, List<BookingModel> previousBookings) {
    final revenueUseCase = RevenueFilteringUsecase();
    
    final double currentEarnings = revenueUseCase.calculateEarningsForPeriod(currentBookings);
    final double previousEarnings = revenueUseCase.calculateEarningsForPeriod(previousBookings);
    
    double percentageChange = 0.0;
    if (previousEarnings > 0) {
      percentageChange = ((currentEarnings - previousEarnings) / previousEarnings) * 100;
    } else if (currentEarnings > 0) {
      percentageChange = 100.0;
    }
    
    return percentageChange;
  }
}