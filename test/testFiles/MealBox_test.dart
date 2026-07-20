import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/MealType_Enum.dart';
import 'package:flutter_application_1/ui/Homepage/ViewModel/Homepage_ViewModel.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/MealBox.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/InsertedFood.dart';
import '../mock_repository/Mock_LogMealRepository.dart';
import '../mock_repository/Mock_UserRepository.dart';
import '../utils/ViewModel_Builders.dart';
import '../utils/Model_Builders.dart';

// Metodo helper per la fase di ARRANGE, avvolge il widget da testare (MealBox) in uno Scaffold, collegandolo al ViewModel
// E' necessario passare anche i parametri per la creazione di un widgert MealBox:
// mealType = pasto a cui si riferisce la box
Widget _arrange(Homepage_ViewModel vm, {required MealType_Enum mealType}) {
  return MaterialApp(
    home: ChangeNotifierProvider<Homepage_ViewModel>.value(
      value: vm,
      child: Scaffold(body: MealBox(mealType: mealType)),
    ),
  );
}

// TESTING -----------------------------------------------------------------------------------------------------------------------------------

void main() {

  // --- Verifica che alla creazione di un MealBox il suo stato sia "chiuso", con CrossFadeState.showFirst
  testWidgets('MealBox chiuso all\'inizio', (tester) async {
    // ARRANGE
    // Ora attendiamo correttamente la creazione del ViewModel
    final vm = await buildHomepageViewModel(Mock_LogMealRepository(logMeal: buildLogMealModel(colazione: [buildLoggedFood('Pane')])), Mock_UserRepository());
    await tester.pumpWidget(_arrange(vm, mealType: MealType_Enum.Colazione));

    // ACT
    final crossFade = tester.widget<AnimatedCrossFade>(
      find.byType(AnimatedCrossFade),
    );

    /// ASSERT
    // Di base, la MealBox è chiusa, mostrando CrossFadeState.showFirst
    expect(crossFade.crossFadeState, CrossFadeState.showFirst);
  });

  // --- Verifica che quando premi una volta su un MealBox si apra, se ci ripremi si richiude
  testWidgets('on/off di sezione espandibile MealBox', (tester) async {
    // ARRANGE
    final vm = await buildHomepageViewModel(Mock_LogMealRepository(logMeal: buildLogMealModel(colazione: [buildLoggedFood('Pane')])), Mock_UserRepository());
    await tester.pumpWidget(_arrange(vm, mealType: MealType_Enum.Colazione));

    // ACT
    await tester.tap(find.text('Colazione'));
    await tester.pumpAndSettle();

    // ASSERT
    // Dopo 1 tocco, la MealBox si apre, mostrando CrossFadeState.showSecond
    expect(
      tester.widget<AnimatedCrossFade>(find.byType(AnimatedCrossFade)).crossFadeState,
      CrossFadeState.showSecond,
    );

    // ACT
    await tester.tap(find.text('Colazione'));
    await tester.pumpAndSettle();
    // Dopo 2 tocchi, la MealBox si richiude, mostrando CrossFadeState.showFirst

    // ASSERT
    expect(
      tester.widget<AnimatedCrossFade>(find.byType(AnimatedCrossFade)).crossFadeState,
      CrossFadeState.showFirst,
    );
  });

  // --- Verifica che, aprendo un MealBox, ci sia il numero corretto di InsertedFood all'interno e che siano i cibi corretti
  testWidgets('corrispondenza MealBox-InsertedFood', (tester) async {
    // ARRANGE
    final vm = await buildHomepageViewModel(Mock_LogMealRepository(logMeal: buildLogMealModel(
      colazione: [buildLoggedFood('Pane'), buildLoggedFood('Latte')],
      pranzo: [buildLoggedFood('Pasta')],
    )), Mock_UserRepository());
    await tester.pumpWidget(_arrange(vm, mealType: MealType_Enum.Colazione));

    // ACT
    await tester.tap(find.text('Colazione'));
    await tester.pumpAndSettle();

    // ASSERT
    expect(find.byType(InsertedFood), findsNWidgets(2));
    expect(find.textContaining('Pane'), findsOneWidget);
    expect(find.textContaining('Latte'), findsOneWidget);
  });

  // --- Verifica che, aprendo un MealBox con nessun cibo caricato, mostri "Nessun cibo caricato"
  testWidgets('out "Nessun cibo caricato" quando il pasto in MealBox è vuoto', (tester) async {
    // ARRANGE
    final vm = await buildHomepageViewModel(Mock_LogMealRepository(logMeal: buildLogMealModel(colazione: [buildLoggedFood('Pane')])), Mock_UserRepository());
    await tester.pumpWidget(_arrange(vm, mealType: MealType_Enum.Pranzo));

    // ACT
    await tester.tap(find.text('Pranzo'));
    await tester.pumpAndSettle();

    // ASSERT
    // Ho caricato un cibo (Pane) in colazione, ma sto verificando il MealBox del pranzo
    expect(find.text('Nessun cibo caricato'), findsOneWidget);
    expect(find.byType(InsertedFood), findsNothing);
  });

  // --- Verifica che, aprendo un MealBox, mostri SOLO i cibi caricati nel suo pasto e nessun altro
  testWidgets(
    'mostra solo i cibi del proprio pasto (MealType_Enum) in MealBox', (tester) async {
      // ARRANGE
      final vm = await buildHomepageViewModel(Mock_LogMealRepository(logMeal: buildLogMealModel(
        colazione: [buildLoggedFood('Pane')],
        pranzo: [buildLoggedFood('Pasta')],
        cena: [buildLoggedFood('Pesce')],
        spuntino: [buildLoggedFood('Mela')],
      )), Mock_UserRepository());
      await tester.pumpWidget(_arrange(vm, mealType: MealType_Enum.Cena));
      
      // ACT
      await tester.tap(find.text('Cena'));
      await tester.pumpAndSettle();

      // ASSERT
      expect(find.textContaining('Pesce'), findsOneWidget);
      expect(find.textContaining('Pane'), findsNothing);
      expect(find.textContaining('Pasta'), findsNothing);
      expect(find.textContaining('Mela'), findsNothing);
    },
  );
}