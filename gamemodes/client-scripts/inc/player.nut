player <- {};

function player::registerEnd(){
	itemSave();
	dialog.destroy();
	setPlayerPosition(heroId, -871, -571, 409);
	Chat.print(194, 178, 128, " ");
	Chat.print(194, 178, 128, "Pomy�lnie zarejestrowano now� posta�. Mi�ej gry.");
	Chat.print(194, 178, 128, "Udaj si� do garnizonu stra�y, by uzyska� obywatelstwo miejskie.");
}

function player::work(){
  setFreeze(true);
  playAni(heroId, "T_PLUNDER");
}
