drunk <- {
  active = null,
  letter = null,
  count = null
};
local drunkTimer, drunkCount, drunkLetters = [];

local function drunkTimerFunction(){
  if(drunkCount<drunkLetters.len()){
    gameDraw.setText(drunkLetters[drunkCount]);
    drunk.letter = drunkLetters[drunkCount];
    drunkCount++;
  }else{
    killTimer(drunkTimer);
    if(drunk.count==drunkLetters.len()){
      Chat.print(194, 178, 128, "Uda�o si� wygra� z pijakiem 2 szt. z�.");
      callServerFunc("drunk", heroId, true);
    }
    else{
      Chat.print(194, 178, 128, "Nie uda�o si� wygra�. Tracisz 2 szt. z�.");
      callServerFunc("drunk", heroId, false);
    }
    drunk.active = false;
    drunkLetters.clear();
    gameDraw.destroy();
    setFreeze(false);
  }
}

local function drunkSort(){
  local letters = ["a", "b", "c", "q", "w", "e", "j", "k", "l", "x", "y", "z"];
  for(local i = 0; i<6; ++i){
    local random = rand() % letters.len();
    drunkLetters.push(letters[random]);
    letters.remove(random);
  }
}

function drunk::start(){
  setFreeze(true);
  drunkSort();
  drunkCount = 0;
  drunk.count = 0;
  Chat.print(194, 178, 128, "Powodzenia.");
  gameDraw.create("Klikaj pojawiaj�ce si� na ekranie litery, by wygra�");
  drunk.active = true;
  drunkTimer = setTimer(drunkTimerFunction, 2000, 5000);
}
