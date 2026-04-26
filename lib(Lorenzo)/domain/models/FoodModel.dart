class FoodModel {
	const FoodModel({
		required this.id,
		required this.name,
		required this.kcal,
		required this.proteins,
		required this.carbs,
		required this.fats,
	});

	final String id;
	final String name;
	final int kcal;
	final double proteins;
	final double carbs;
	final double fats;
}
