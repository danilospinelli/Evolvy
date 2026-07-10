import 'package:flutter/material.dart';

/// =====================================================
/// MODELLI DATI
/// =====================================================

/// Rappresenta una singola sfida/obiettivo giornaliero.
class Challenge {
  final String id;
  final String title;
  final int xpReward;
  final bool completed;

  const Challenge({
    required this.id,
    required this.title,
    required this.xpReward,
    this.completed = false,
  });

  Challenge copyWith({bool? completed}) {
    return Challenge(
      id: id,
      title: title,
      xpReward: xpReward,
      completed: completed ?? this.completed,
    );
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      id: map['id'] as String,
      title: map['title'] as String,
      xpReward: map['xpReward'] as int,
      completed: map['completed'] as bool? ?? false,
    );
  }
}

/// Dati del profilo/personaggio mostrati nella schermata.
class UserProfile {
  final String name;
  final int level;
  final double currentXp;
  final double xpForNextLevel;
  final int coins;
  final int streakDays;
  final String avatarAssetPath;
  final Color selectedMascotColor;
  final List<Color> availableMascotColors;

  const UserProfile({
    required this.name,
    required this.level,
    required this.currentXp,
    required this.xpForNextLevel,
    required this.coins,
    required this.streakDays,
    required this.avatarAssetPath,
    required this.selectedMascotColor,
    required this.availableMascotColors,
  });

  double get xpProgress =>
      xpForNextLevel == 0 ? 0 : currentXp / xpForNextLevel;

  UserProfile copyWith({
    int? currentXp,
    int? level,
    Color? selectedMascotColor,
  }) {
    return UserProfile(
      name: name,
      level: level ?? this.level,
      currentXp: currentXp ?? this.currentXp,
      xpForNextLevel: xpForNextLevel,
      coins: coins,
      streakDays: streakDays,
      avatarAssetPath: avatarAssetPath,
      selectedMascotColor: selectedMascotColor ?? this.selectedMascotColor,
      availableMascotColors: availableMascotColors,
    );
  }
}


class Avatar_ViewModel extends ChangeNotifier {


  UserProfile? _user;
  UserProfile? get user => _user;

  List<Challenge> _challenges = [];
  List<Challenge> get challenges => List.unmodifiable(_challenges);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Carica profilo utente e sfide giornaliere dal database.
  Future<void> loadData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        //_repository.fetchUserProfile(),
        //_repository.fetchDailyChallenges(),
      ]);
      _user = results[0] as UserProfile;
      _challenges = results[1] as List<Challenge>;
    } catch (e) {
      _errorMessage = 'Errore nel caricamento dei dati: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Chiamato al tap su una sfida non ancora completata:
  /// la marca come fatta e assegna l'XP al personaggio.
  Future<void> completeChallenge(String challengeId) async {
    final index = _challenges.indexWhere((c) => c.id == challengeId);
    if (index == -1) return;

    final challenge = _challenges[index];
    if (challenge.completed || _user == null) return;

    // Aggiornamento ottimistico dello stato locale.
    _challenges[index] = challenge.copyWith(completed: true);
    _user = _user!.copyWith(currentXp: _user!.currentXp + challenge.xpReward);
    notifyListeners();

    try {
      //await _repository.completeChallenge(challengeId, challenge.xpReward);
    } catch (e) {
      // Rollback in caso di errore di salvataggio sul DB.
      _challenges[index] = challenge;
      _user = _user!.copyWith(currentXp: _user!.currentXp - challenge.xpReward);
      _errorMessage = 'Impossibile salvare la sfida completata: $e';
      notifyListeners();
    }
  }

  /// Chiamato quando l'utente sceglie un nuovo colore per la mascotte.
  Future<void> selectMascotColor(Color color) async {
    if (_user == null) return;
    final previous = _user!.selectedMascotColor;
    _user = _user!.copyWith(selectedMascotColor: color);
    notifyListeners();

    try {
      //await _repository.updateMascotColor(color);
    } catch (e) {
      _user = _user!.copyWith(selectedMascotColor: previous);
      _errorMessage = 'Impossibile salvare il colore scelto: $e';
      notifyListeners();
    }
  }

  /// Hook da collegare a un dialog/route di modifica nome.
  void onEditName() {
    // Da implementare: apertura dialog/route per rinominare il personaggio,
    // seguito da una chiamata al repository per persistere il nuovo nome.
  }

  /// Hook da collegare all'apertura dello shop (icona cesto).
  void onOpenShop() {
    // Attualmente non fa nulla, come da mockup.
  }




// REPOSITORY (accesso al database)

  Future<UserProfile> fetchUserProfile() async {
    // TODO: chiamata DB - recupero profilo utente (nome, lvl, xp, coins, streak, colore mascotte)
    // Esempio: final doc = await firestore.collection('users').doc(uid).get();
    throw UnimplementedError('Collegare fetchUserProfile al database');
  }

  Future<List<Challenge>> fetchDailyChallenges() async {
    // TODO: chiamata DB - pull delle 3 sfide giornaliere correnti per l'utente
    // Esempio: final snap = await firestore.collection('users').doc(uid)
    //     .collection('dailyChallenges').where('date', isEqualTo: today).get();
    throw UnimplementedError('Collegare fetchDailyChallenges al database');
  }


  Future<void> updateMascotColor(Color color) async {
    // TODO: chiamata DB - salva il colore mascotte selezionato sul profilo utente
    throw UnimplementedError('Collegare updateMascotColor al database');
  }
}
