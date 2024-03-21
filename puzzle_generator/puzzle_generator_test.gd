extends Node2D

@onready var puzzle_generator:PuzzleGenerator = get_node("PuzzleGenerator")



func _ready() -> void:
	SceneController._current_scene = SCENE.TEST_PUZZLE_GENERATOR
	test_no_players_ball_on_field()

func test_no_players_ball_on_field():
	var data = PuzzleData.PuzzleDataParser.parse_from_json(PuzzleGeneratorTestData.no_players_ball_on_field())
	var puzzle = puzzle_generator.generate(data)
	SceneController.schedule_scene_change(SCENE.GENERATED, puzzle)

	

