local timer60s = setTimer(function(){
	for(local i = 0; i<getMaxSlots(); ++i){
		if(player[i].isLogged){
			player[i].minuter++;
			if(player[i].minuter>=60){
				sendMessageToPlayer(i, 194, 178, 128, "Otrzymano 2 PN i 20 sztuk z�ota za przegranie pe�nej godziny.");
				player[i].minuter=0;
				player[i].online++;
				player[i].pn += 2;;
				item.give(i, "ITMI_GOLD", 20);
			}
		}

		if(lottery.time<time()){
			if(lottery.players.len()>0){
				local winner = rand() % (lottery.players.len());
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].isLogged){
						if(lottery.players[winner]==getPlayerName(i)){
							if(item.hasPlace(i)){
								if(lottery.budget==10){
									item.give(i, "ITMI_GOLD", 13);
									sendMessageToPlayer(i, 184, 129, 238, format("#Pos�aniec przyni�s� Ci %d szt. z�. z wygranej loterii.", 13));
								}else {
									item.give(i, "ITMI_GOLD", lottery.budget);
									sendMessageToPlayer(i, 184, 129, 238, format("#Pos�aniec przyni�s� Ci %d szt. z�. z wygranej loterii.", lottery.budget));
								}
							}else sendMessageToPlayer(i, 192, 192, 192, ">Nie masz miejsca w ekwipunku, wi�c nie mo�esz odebra� nagrody.");
						}
					}
				}
				lottery.players.clear();
				lottery.budget = 0;
			}
			lottery.time = time()+3600;
		}
	}
}, 60000, 0);

local timer5s = setTimer(function(){
	for(local i = 0; i<getMaxSlots(); ++i){
		if(player[i].isLogged){
			item[i].flood = 0;
			protection[i].flood = 0;
			if(trade[i].mode){
				local pos = getPlayerPosition(i), pos2 = getPlayerPosition(trade[i].player);
				if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)>600) trade.destroy(i, 0);
			}
		}
	}
}, 5000, 0);
