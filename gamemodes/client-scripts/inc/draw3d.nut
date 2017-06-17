local draw3d = {};

local function draw3dCreate(name, x, y, z, text, r, g, b){
  local len = draw3d[name].len();
  draw3d[name][len] <- Draw3d(x, y, z);
  if(text.len()>50){
    if(text[50].tochar()!=" ") draw3d[name][len].insertText(text.slice(0, 50) + "-");
	else draw3d[name][len].insertText(text.slice(0, 50));
    if(text.len()>100) draw3d[name][len].insertText(text.slice(50, 100));
    else draw3d[name][len].insertText(text.slice(50, text.len()));
  }else draw3d[name][len].insertText(text);
  draw3d[name][len].setColor(r, g, b);
  draw3d[name][len].visible = true;
}

function draw3dInit(){
  draw3d["learn"] <- {};
  draw3dCreate("learn", 3711, -88, 3377, "Spotykasz nauczyciela ((/learn))", 184, 129, 238);
  draw3dCreate("learn", 4448, 848, 7214, "Spotykasz nauczyciela ((/learn))", 184, 129, 238);
  draw3dCreate("learn", 13292, 1186, -499, "Spotykasz nauczyciela ((/learn))", 184, 129, 238);

  draw3d["food"] <- {};
  draw3dCreate("food", 2000, -20, -2039, "Spotykasz handlarza �ywno�ci� ((/buy))", 184, 129, 238);
  draw3dCreate("food", -231, -15, -5116, "Spotykasz handlarza �ywno�ci� ((/buy))", 184, 129, 238);
  draw3dCreate("food", 8459, 434, 4517, "Spotykasz handlarza �ywno�ci� ((/buy))", 184, 129, 238);
  draw3dCreate("food", 10427, 451, 4718, "Spotykasz handlarza �ywno�ci� ((/buy))", 184, 129, 238);
  draw3dCreate("food", 7193, 429, -5068, "Spotykasz handlarza �ywno�ci� ((/buy))", 184, 129, 238);
  draw3dCreate("food", 12659, 998, 3246, "Znajdujesz si� w sklepie z �ywno�ci� ((/buy))", 184, 129, 238);

  draw3d["potion"] <- {};
  draw3dCreate("potion", 9249, 437, 4429, "Spotykasz handlarza miksturami ((/buy))", 184, 129, 238);

  draw3d["work"] <- {};
  draw3dCreate("work", 6336, 368, -2584, "Wygl�da na to, �e mo�na tu zarobi� ((/work))", 184, 129, 238);
  draw3dCreate("work", 12358, 998, -1804, "Wygl�da na to, �e mo�na tu zarobi� ((/work))", 184, 129, 238);

  draw3d["cloth"] <- {};
  draw3dCreate("cloth", 5739, 368, -4389, "Znajdujesz si� w sklepie z ubraniami ((/buy))", 184, 129, 238);

  draw3d["weapon"] <- {};
  draw3dCreate("weapon", 9172, 433, 5652, "Spotykasz handlarza broni ((/buy))", 184, 129, 238);

  draw3d["fletcher"] <- {};
  draw3dCreate("fletcher", 10327, 437, 4086, "Spotykasz handlarza �ukami i kuszami ((/buy))", 184, 129, 238);
  draw3dCreate("fletcher", 8155, 368, -3356, "Znajdujesz si� w sklepie z �ukami i kuszami ((/buy))", 184, 129, 238);

  draw3d["lottery"] <- {};
  draw3dCreate("lottery", 3123, -7, -2525, "Mieszkaj�cy tu cz�owiek co jaki� czas organizuje loteri�. ((/lottery))", 184, 129, 238);

  draw3d["roulette"] <- {};
  draw3dCreate("roulette", 1368, 5, -538, "W karczmie jest t�oczno, na stole znajduje si� prowizoryczna wersja ruletki ((/roulette))", 184, 129, 238);

  draw3d["bank"] <- {};
  draw3dCreate("bank", 8734, 456, 3704, "Z dalekich krain do Khorinis trafi� system bankowy ((/bank))", 184, 129, 238);

  draw3d["brothel"] <- {};
  draw3dCreate("brothel", 793, 15, -2842, "Us�uga 150 szt. z�. ((/brothel))", 184, 129, 238);

  draw3d["blacktrader"] <- {};
  draw3dCreate("blacktrader", 4785, 9, -4334, "Podejrzany cz�owiek z wypchanym worem. ((/blacktrader))", 184, 129, 238);

  draw3d["drunk"] <- {};
  draw3dCreate("drunk", 8720, 314, 1486, "Lokalni pijacy zak�adaj� si� o to, kto wypije wi�cej Lou za 2 szt. z�. ((/drunk))", 184, 129, 238);

  draw3d["citizen"] <- {};
  draw3dCreate("citizen", 3335, 848, 6409, "W tym miejscu mo�esz zarejestrowa� si� jako obywatel miasta ((/citizen))", 184, 129, 238);
  
}
