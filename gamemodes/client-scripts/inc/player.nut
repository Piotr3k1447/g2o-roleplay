player <- {};

function player::registerEnd(){
	dialog.destroy();
	setPlayerPosition(heroId, -871, -571, 409);
	Chat.print(194, 178, 128, " ");
	Chat.print(194, 178, 128, "Pomy�lnie zarejestrowano now� posta�. Mi�ej gry.");
}

function player::work(){
  setFreeze(true);
  playAni(heroId, "T_PLUNDER");
}
