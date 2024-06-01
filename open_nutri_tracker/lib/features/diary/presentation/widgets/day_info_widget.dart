import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opennutritracker/core/domain/entity/intake_entity.dart';
import 'package:opennutritracker/core/domain/entity/tracked_day_entity.dart';
import 'package:opennutritracker/core/domain/entity/user_activity_entity.dart';
import 'package:opennutritracker/core/presentation/widgets/activity_vertial_list.dart';
import 'package:opennutritracker/core/presentation/widgets/delete_dialog.dart';
import 'package:opennutritracker/core/utils/custom_icons.dart';
import 'package:opennutritracker/features/add_meal/presentation/add_meal_type.dart';
import 'package:opennutritracker/features/home/presentation/widgets/intake_vertical_list.dart';
import 'package:opennutritracker/generated/l10n.dart';

class DayInfoWidget extends StatelessWidget {
  final DateTime selectedDay;
  final TrackedDayEntity? trackedDayEntity;
  final List<UserActivityEntity> userActivities;
  final List<IntakeEntity> breakfastIntake;
  final List<IntakeEntity> lunchIntake;
  final List<IntakeEntity> dinnerIntake;
  final List<IntakeEntity> snackIntake;
  final Function(IntakeEntity intake, TrackedDayEntity? trackedDayEntity)
      onDeleteIntake;
  final Function(UserActivityEntity userActivityEntity,
      TrackedDayEntity? trackedDayEntity) onDeleteActivity;

  const DayInfoWidget(
      {super.key,
      required this.selectedDay,
      required this.trackedDayEntity,
      required this.userActivities,
      required this.breakfastIntake,
      required this.lunchIntake,
      required this.dinnerIntake,
      required this.snackIntake,
      required this.onDeleteIntake,
      required this.onDeleteActivity});

  @override
  Widget build(BuildContext context) {
    final trackedDay = trackedDayEntity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(DateFormat.yMMMMEEEEd().format(selectedDay),
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        const SizedBox(height: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            trackedDay == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(S.of(context).nothingAddedLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.7))),
                  )
                : const SizedBox(),
            trackedDay != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 0.0,
                          margin: const EdgeInsets.all(0.0),
                          color: trackedDayEntity
                              ?.getRatingDayTextBackgroundColor(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: Text(
                              _getCaloriesTrackedDisplayString(trackedDay),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: trackedDayEntity
                                          ?.getRatingDayTextColor(context),
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(_getMacroTrackedDisplayString(trackedDay),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.7)))
                      ],
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 8.0),
            ActivityVerticalList(
                day: selectedDay,
                title: S.of(context).activityLabel,
                userActivityList: userActivities,
                onItemLongPressedCallback: onActivityItemLongPressed),
            IntakeVerticalList(
              day: selectedDay,
              title: S.of(context).breakfastLabel,
              listIcon: Icons.bakery_dining_outlined,
              addMealType: AddMealType.breakfastType,
              intakeList: breakfastIntake,
              onItemLongPressedCallback: onIntakeItemLongPressed,
            ),
            IntakeVerticalList(
              day: selectedDay,
              title: S.of(context).lunchLabel,
              listIcon: Icons.lunch_dining_outlined,
              addMealType: AddMealType.lunchType,
              intakeList: lunchIntake,
              onItemLongPressedCallback: onIntakeItemLongPressed,
            ),
            IntakeVerticalList(
              day: selectedDay,
              title: S.of(context).dinnerLabel,
              listIcon: Icons.dinner_dining_outlined,
              addMealType: AddMealType.dinnerType,
              intakeList: dinnerIntake,
              onItemLongPressedCallback: onIntakeItemLongPressed,
            ),
            IntakeVerticalList(
              day: selectedDay,
              title: S.of(context).snackLabel,
              listIcon: CustomIcons.food_apple_outline,
              addMealType: AddMealType.snackType,
              intakeList: snackIntake,
              onItemLongPressedCallback: onIntakeItemLongPressed,
            ),
            const SizedBox(height: 16.0)
          ],
        )
      ],
    );
  }

  String _getCaloriesTrackedDisplayString(TrackedDayEntity trackedDay) {
    int caloriesTracked;
    if (trackedDay.caloriesTracked.isNegative) {
      caloriesTracked = 0;
    } else {
      caloriesTracked = trackedDay.caloriesTracked.toInt();
    }

    return '$caloriesTracked/${trackedDay.calorieGoal.toInt()} kcal';
  }

  String _getMacroTrackedDisplayString(TrackedDayEntity trackedDay) {
    final carbsTracked = trackedDay.carbsTracked?.floor().toString() ?? '?';
    final fatTracked = trackedDay.fatTracked?.floor().toString() ?? '?';
    final proteinTracked = trackedDay.proteinTracked?.floor().toString() ?? '?';

    final carbsGoal = trackedDay.carbsGoal?.floor().toString() ?? '?';
    final fatGoal = trackedDay.fatGoal?.floor().toString() ?? '?';
    final proteinGoal = trackedDay.proteinGoal?.floor().toString() ?? '?';

    return 'Carbs: $carbsTracked/${carbsGoal}g, Fat: $fatTracked/${fatGoal}g, Protein: $proteinTracked/${proteinGoal}g';
  }

  void onIntakeItemLongPressed(
      BuildContext context, IntakeEntity intakeEntity) async {
    final shouldDeleteIntake = await showDialog<bool>(
        context: context, builder: (context) => const DeleteDialog());

    if (shouldDeleteIntake != null) {
      onDeleteIntake(intakeEntity, trackedDayEntity);
    }
  }

  void onActivityItemLongPressed(
      BuildContext context, UserActivityEntity activityEntity) async {
    final shouldDeleteActivity = await showDialog<bool>(
        context: context, builder: (context) => const DeleteDialog());

    if (shouldDeleteActivity != null) {
      onDeleteActivity(activityEntity, trackedDayEntity);
    }
  }
}
