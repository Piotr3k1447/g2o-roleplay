addEventHandler("onInit", function(){
	pmLog <- Log("pm");
	bLog <- Log("b");
	lLog <- Log("l");
	sLog <- Log("s");
	wLog <- Log("w");
	earLog <- Log("ear");
	meLog <- Log("me");
	doLog <- Log("do");
	tryLog <- Log("try");
	descriptionLog <- Log("description");
	reportLog <- Log("report");

	for(local i = 0; i<getMaxSlots(); ++i){
		player.init(i);
		item.init(i);
		work.init(i);
		protection.init(i);
		bank.init(i);
	}
	position.init();

	local date = date();
	setTime(date.hour, date.min);
});

addEventHandler("onPlayerJoin", function(pid){
	protection.join(pid);
	setPlayerName(pid, format("New %d", pid));
});

addEventHandler("onPlayerDisconnect", function(pid, reason){
	if(player[pid].isLogged){
		player.destroy(pid);
		item.destroy(pid);
		bank.destroy(pid);
		work.destroy(pid);
		protection.destroy(pid);
	}
});

addEventHandler("onPlayerMessage", function(pid, message){
	if(player[pid].isLogged){
		if(protection.flood(pid)) return 0;
		else if(message.find("@")==0) animations(pid, message);
		else{
			local pos = getPlayerPosition(pid);
			for(local i = 0; i<getMaxSlots(); ++i){
				if(player[i].isLogged){
					local pos2 = getPlayerPosition(i);
					if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<800) sendMessageToPlayer(i, 250, 250, 250, format("%s m�wi: %s", getPlayerName(pid),
					convertMessageToIC(message)));
				}
			}
			lLog.enter(format("%s: %s", getPlayerName(pid), message));
		}
	}
});

addEventHandler("onPlayerCommand", function(pid, cmd, params){
	if(!player[pid].isLogged){
		switch(cmd){
			case "register":
				local args = sscanf("ss", params);
				if(args){
					local register = player.register(pid, args[0], args[1]);
					if(register==0) sendMessageToPlayer(pid, 192, 192, 192, ">Nieprawid�owa d�ugo�� nicku.");
					else if(register==1) sendMessageToPlayer(pid, 192, 192, 192, ">Nieprawid�owa d�ugo�� has�a.");
					else if(register==2) sendMessageToPlayer(pid, 192, 192, 192, ">Proponowany nick jest zaj�ty.");
					else{
						sendMessageToPlayer(pid, 194, 178, 128, "Zarejestrowano konto. Wybierz p�e� postaci.");
						callClientFunc(pid, "dialog.show", 0);

					}
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /register (nick) (password)");
			break;

			case "login":
				local args = sscanf("ss", params);
				if(args){
					local login = player.login(pid, args[0], args[1]);
					if(login>=0 && login<4) sendMessageToPlayer(pid, 192, 192, 192, ">Nazwa postaci b�d� has�o s� nieprawid�owe.");
					else if(login==4) sendMessageToPlayer(pid, 192, 192, 192, ">Konto jest nieaktywne.");
					else if(login==5) {
						sendMessageToPlayer(pid, 192, 192, 192, ">Tworzenie postaci nie zosta�o zako�czone.");
						callClientFunc(pid, "dialog.show", 0);
					}else{
						sendMessageToPlayer(pid, 194, 178, 128, " ");
						sendMessageToPlayer(pid, 194, 178, 128, "Pomy�lnie zalogowano. Mi�ej gry.");
						item.login(pid);
						bank.login(pid);
						spawnPlayer(pid);
					}
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /login (nick) (password)");
			break;
		}
	}
	else{
		if(protection.flood(pid)) return 0;
		switch(cmd){

			/*
				Chat commands start
			*/

			case "pm":
			case "privatemessage":
				local args = sscanf("ds", params);
				if(args){
					if(player[args[0]].isLogged && args[0]!=pid){
						if(args[1].len()<180){
							sendMessageToPlayer(pid, 255, 191, 0, format("(( PM do (%d) %s: %s ))", args[0], getPlayerName(args[0]), args[1]));
							sendMessageToPlayer(args[0], 233, 107, 57, format("(( PM od (%d) %s: %s ))", pid, getPlayerName(pid), args[1]));
							pmLog.enter(format("%s do %s: %s", getPlayerName(pid), getPlayerName(args[0]), args[1]));
						}else  sendMessageToPlayer(pid, 192, 192, 192, ">Zbyt wiele znak�w.");
					}else sendMessageToPlayer(pid, 192, 192, 192, ">Nieprawid�owe ID.");
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /p(rivate)m(essage) (id) (text)");
			break;

			case "b":
				if(params.len()>0 && params.len()<180){
					local pos = getPlayerPosition(pid), string = format("(( (%d) %s: %s ))", pid, getPlayerName(pid), params);
					for(local i = 0; i<getMaxSlots(); ++i){
						if(player[i].isLogged){
							local pos2 = getPlayerPosition(i);
							if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<800) sendMessageToPlayer(i, 198, 206, 206, string);
						}
					}
					bLog.enter(format("%s: %s", getPlayerName(pid), params));
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /b (text)");
			break;

		case "s":
		case "shout":
			if(params.len()>0 && params.len()<180){
				local pos = getPlayerPosition(pid);
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].isLogged){
						local pos2 = getPlayerPosition(i);
						if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<1600) sendMessageToPlayer(i, 250, 250, 250, format("%s krzyczy: %s", getPlayerName(pid), convertMessageToIC(params)));
					}
				}
				sLog.enter(format("%s: %s", getPlayerName(pid), params));
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /s(hout) (text)");;
		break;

		case "w":
		case "whisper":
			if(params.len()>0 && params.len()<180){
				local pos = getPlayerPosition(pid);
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].isLogged){
						local pos2 = getPlayerPosition(i);
						if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<400) sendMessageToPlayer(i, 250, 250, 250, format("%s szepcze: %s", getPlayerName(pid), convertMessageToIC(params)));
					}
				}
				wLog.enter(format("%s: %s", getPlayerName(pid), params));
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /w(hisper) (text)");
		break;

		case "ear":
			local args = sscanf("ds", params);
			if(args && args[1].len()<180){
				if(player[args[0]].isLogged && args[0]!=pid){
					local pos = getPlayerPosition(pid), pos2 = getPlayerPosition(args[0]);
					if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<300){
						local format = format("#%s szepcze co� na ucho %s.", getPlayerName(pid), getPlayerName(args[0]));
						for(local i = 0; i<getMaxSlots(); ++i){
							if(player[i].isLogged){
								local pos2 = getPlayerPosition(i);
								if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<800) sendMessageToPlayer(i, 238, 130, 238, format);
							}
						}
						sendMessageToPlayer(args[0], 250, 250, 250, format("%s szepcze Ci na ucho: %s", getPlayerName(pid), convertMessageToIC(args[1])));
						earLog.enter(format("%s do %s: %s", getPlayerName(pid), getPlayerName(args[0]), args[1]));
					}else sendMessageToPlayer(pid, 192, 192, 192, ">Gracz jest za daleko.");
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Nieprawid�owe ID.");
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /ear (id) (text)");
		break;

		case "me":
			if(params.len()>0 && params.len()<180){
				local pos = getPlayerPosition(pid), string = format("%s %s", getPlayerName(pid), params);
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].isLogged){
						local pos2 = getPlayerPosition(i);
						if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<800) sendMessageToPlayer(i, 238, 130, 238, string);
					}
				}
				meLog.enter(format("%s: %s", getPlayerName(pid), params));
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /me (text)");
		break;

		case "do":
			if(params.len()>0 && params.len()<180){
				local pos = getPlayerPosition(pid), string = format("%s (( (%d) %s ))", params, pid, getPlayerName(pid));
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].isLogged){
						local pos2 = getPlayerPosition(i);
						if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<800) sendMessageToPlayer(i, 184, 129, 238, string);
					}
				}
				doLog.enter(format("%s: %s", getPlayerName(pid), params));
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /do (text)");
		break;

		case "try":
			if(params.len()>0 && params.len()<180){
				local random = rand() % 2, pos = getPlayerPosition(pid), randomResult;
				if(random==1) randomResult = "z powodzeniem";
				else randomResult = "z niepowodzeniem";
				local string = format("#%s %s spr�bowa� %s", getPlayerName(pid), randomResult, params);
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].isLogged){
						local pos2 = getPlayerPosition(i);
						if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<800) sendMessageToPlayer(i, 238, 130, 238, string);
					}
				}
				tryLog.enter(format("%s: %s - %s", getPlayerName(pid), params, randomResult));
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /try (text)");
		break;

		case "bones":
				local args = sscanf("d", params);
				if(args && args[0]>1 && args[0]<100){
					local random = rand() % (args[0]+1), pos = getPlayerPosition(pid), string = format("Wylosowano %d z %d (( #(%d) %s ))", random, args[0], pid, getPlayerName(pid));
					for(local i = 0; i<getMaxSlots(); ++i){
						if(player[i].isLogged){
							local pos2 = getPlayerPosition(i);
							if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<800) sendMessageToPlayer(i, 184, 129, 238, string);
						}
					}
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /bones (max 2-99)");
		break;

		/*
			Chat commands end
		*/

		/*
			Settings commands start
		*/

		case "description":
			if(params.len()>=1 && params.len()<180){
				player[pid].description = params;
				if(player[pid].description!="delete"){
					sendMessageToPlayer(pid, 194, 178, 128, "Ustawiono opis.");
					setPlayerColor(pid, 184, 129, 238);
					descriptionLog.enter(format("%s: %s", getPlayerName(pid), params));
				}else{
					sendMessageToPlayer(pid, 194, 178, 128, "Usuni�to opis.");
					setPlayerColor(pid, 250, 250, 250);
				}
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /description (text)");
		break;

		/*
			Settings commands end
		*/

		/*
			Activity commands start
		*/

		case "learn":
			if(position.get(pid, "learn")){
				sendMessageToPlayer(pid, 194, 178, 128, "Wszystkie umiej�tno�ci kosztuj� 1 PN za 1 punkt.");
				callClientFunc(pid, "dialog.show", 2);
			}
		break;

		case "brothel":
			if(position.get(pid, "brothel")){
				if(item.has(pid, "ITMI_GOLD")>=150){
					sendMessageToPlayer(pid, 194, 178, 128, "Uzupe�niono punkty trafie� do maksymalnej warto�ci.");
					removeItem(pid, Items.id("ITMI_GOLD"), 150);
					callClientFunc(pid, "brothelShow");
					setPlayerHealth(pid, player[pid].maxHealth);
				}else sendMessageToPlayer(pid, 198, 206, 206, ">Nie posiadasz wystarczaj�co z�ota.");
			}else sendMessageToPlayer(pid, 198, 206, 206, ">Jeste� nie nieodpowiednim miejscu.");
		break;

		case "roulette":
			if(position.get(pid, "roulette")){
				local args = sscanf("d", params);
				if(args){
					if(item.has(pid, "ITMI_GOLD")>=args[0]){
						local random;
						for(local i = 0; i<3; ++i){
							random = rand() % 3;
						}
						if(random==1){
							local gold = args[0]*2;
							sendMessageToPlayer(pid, 194, 178, 128, format("Gratulacje! %d szt. z�. trafia do Twojej kieszeni.", gold));
							item.give(pid, "ITMI_GOLD", gold);
						}else{
							sendMessageToPlayer(pid, 194, 178, 128, "Tym razem si� nie uda�o.");
							item.remove(pid, "ITMI_GOLD", args[0]);
						}
					}else sendMessageToPlayer(pid, 198, 206, 206, ">Nie posiadasz wystarczaj�co z�ota.");
				}else{
					sendMessageToPlayer(pid, 198, 206, 206, ">U�yj /roulette (gold), by zagra� w ruletk�.");
					sendMessageToPlayer(pid, 194, 178, 128, "Uwa�aj, bo hazard wci�ga.");
				}
			}else sendMessageToPlayer(pid, 198, 206, 206, ">Nie znajdujesz si� przy ruletce.");
		break;

		case "lottery":
			if(position.get(pid, "lottery")){
				local args = sscanf("s", params);
				if(args){
					if(args[0]=="pay"){
						if(lottery.players.find(getPlayerName(pid))==null){
							if(item.has(pid, "ITMI_GOLD")>=10){
								sendMessageToPlayer(pid, 194, 178, 128, "Wp�acono na loteri�. Je�li wygrasz, pos�aniec przyniesie Ci z�oto.");
								item.remove(pid, "ITMI_GOLD", 10);
								lottery.budget += 10;
								lottery.players.push(getPlayerName(pid));
							}else sendMessageToPlayer(pid, 198, 206, 206, ">Nie posiadasz wystarczaj�co z�ota.");
						}else sendMessageToPlayer(pid, 198, 206, 206, ">Wp�acono ju� na obecn� loteri�.");
					}else sendMessageToPlayer(pid, 198, 206, 206, ">Nieprawid�owa opcja.");
				}else{
					local lotteryEnd = (lottery.time-time())/60;
					if(lotteryEnd<=0) sendMessageToPlayer(pid, 198, 206, 206, ">U�yj /lottery pay, by wzi�� udzia�. Cena 10 szt. z�. Loteria za chwil� si� zako�czy.");
					else sendMessageToPlayer(pid, 198, 206, 206, format(">U�yj /lottery pay, by wzi�� udzia�. Cena 10 szt. z�. Loteria ko�czy si� za %d min.", lotteryEnd));
					sendMessageToPlayer(pid, 194, 178, 128, "Pami�taj, �e musisz znajdowa� si� na serwerze, by odebra� ewentualn� nagrod�.");
				}
			}else sendMessageToPlayer(pid, 198, 206, 206, ">W tym miejscu loterie nie s� organizowane.");
		break;

		case "blacktrader":
			if(position.get(pid, "blacktrader")){
				local args = sscanf("dd", params);
				if(args){
					if(item[pid].instance.len()>=args[0]){
						if(item[pid].amount[args[0]]>=args[1]){
							sendMessageToPlayer(pid, 194, 178, 128, "Paser da� Ci sztuk� z�ota za ten przedmiot.");
							removeItem(pid, Items.id(item[pid].instance[args[0]]), args[1]);
							giveItem(pid, Items.id("ITMI_GOLD"), args[1]);
							callClientFunc(pid, "itemSave");
						}else sendMessageToPlayer(pid, 198, 206, 206, ">Nie posiadasz ��danego przedmiotu w takiej liczbie.");
					}else sendMessageToPlayer(pid, 198, 206, 206, ">Nieprawid�owy slot.");
				}else{
					sendMessageToPlayer(pid, 198, 206, 206, ">U�yj /blacktrader (slot) (amount)");
					sendMessageToPlayer(pid, 194, 178, 128, "Paser nie bierze pod uwag� warto�ci przedmiotu i za ka�dy zap�aci Ci 1 szt. z�.");
				}
			}else sendMessageToPlayer(pid, 198, 206, 206, ">W okolicy nie wida� pasera.");
		break;

		case "bank":
			if(position.get(pid, "bank")) callClientFunc(pid, "dialog.show", 8);
		break;

		case "buy":
			if(position.get(pid, "food")) callClientFunc(pid, "dialog.show", 3);
			else if(position.get(pid, "potion")) callClientFunc(pid, "dialog.show", 4);
			else if(position.get(pid, "cloth")) callClientFunc(pid, "dialog.show", 5);
			else if(position.get(pid, "weapon")) callClientFunc(pid, "dialog.show", 6);
			else if(position.get(pid, "fletcher")) callClientFunc(pid, "dialog.show", 7);
		break;

		case "work":
			if(position.get(pid, "work")){
				if(!work[pid].isWork){
					sendMessageToPlayer(pid, 194, 178, 128, "Rozpocz�to prac�. Trzymaj lewy ctrl do osi�gni�cia 100%.");
					sendMessageToPlayer(pid, 194, 178, 128, "Spadek do 0% oznacza przerwanie pracy.");
					work[pid].isWork = true;
					callClientFunc(pid, "work.start");
				}
			}
			else sendMessageToPlayer(pid, 198, 206, 206, ">W tym miejscu nie mo�na pracowa�.");
		break;

		/*
			Activity commands end
		*/

		/*
			Other commands start
		*/

		case "admins":
			local id = [];
			local lvl = [];
			for(local i = 0; i<getMaxSlots(); ++i){
				if(player[i].adminIsLogged){
					id.push(i);
					lvl.push(player[i].admin);
				}
			}
			if(id.len()>0){
				local sort = true, len = id.len()-1;
				while(sort){
					local n = 0;
					for(local i = 0; i<len; ++i){
						if(lvl[i]>lvl[i+1]){
							local temp = lvl[i];
							lvl[i] = lvl[i+1];
							lvl[i+1] = temp;

							temp = id[i];
							id[i] = id[i+1];
							id[i+1] = temp;
						}else n++;
					}
					if(n>=len) sort = false;
				}
				sendMessageToPlayer(pid, 207, 41, 66, "Dost�pni supporterzy:");
				for(local i = 0; i<id.len(); ++i){
					sendMessageToPlayer(pid, 207, 41, 66, format("(Level: %d) (%d) (%s)", lvl[i], id[i], getPlayerName(id[i])));
				}
			}else sendMessageToPlayer(pid, 207, 41, 66, "Brak dost�pnych supporter�w.");
		break;

		case "report":
			if(params.len()>0 && params.len()<180){
				sendMessageToPlayer(pid, 207, 41, 66, "Raport zosta� wys�any.");
				local string = format("Raport od (%d) %s: %s", pid, getPlayerName(pid), params);
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].adminIsLogged) sendMessageToPlayer(i, 238, 130, 238, string);
				}
				reportLog.enter(format("%s: %s", getPlayerName(pid), params));
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /report (text)");
		break;

		/*
			Other commands end
		*/

		/*
			Admin commands start
		*/

		case "alogin":
			if(player[pid].admin>0){
				if(!player[pid].adminIsLogged){
					if(player[pid].adminPassword==md5(params)){
						sendMessageToPlayer(pid, 128, 0, 0, "Zalogowano.");
						player[pid].adminIsLogged = true;
					}
				}else{
					sendMessageToPlayer(pid, 128, 0, 0, "Wylogowano.");
					player[pid].adminIsLogged = false;
				}
			}
		break;

		case "ahelp":
			if(player[pid].adminIsLogged){
				sendMessageToPlayer(pid, 128, 0, 0, " ");
				sendMessageToPlayer(pid, 128, 0, 0, "/a, /all, /tp, /tppos, /kick, /ban, /warn, /descdelete, /sethp");
				if(player[pid].admin>1) sendMessageToPlayer(pid, 128, 0, 0, "/setpn, /setstr, /setdex, /setwp");
				if(player[pid].admin>2) sendMessageToPlayer(pid, 128, 0, 0, "/giveadmin, /giveitem, /removeitem, /setserverdescription");
				sendMessageToPlayer(pid, 128, 0, 0, " ");
			}
		break;

		case "a":
			if(player[pid].adminIsLogged){
				if(params.len()>0 && params.len()<180){
					for(local i = 0; i<getMaxSlots(); ++i){
						if(player[i].adminIsLogged) sendMessageToPlayer(i, 128, 0, 0, format("(%d) %s: %s", pid, getPlayerName(pid), params));
					}
				}else sendMessageToPlayer(pid, 128, 0, 0, "Tip: /a (text)");
			}
		break;

		case "all":
			if(player[pid].adminIsLogged){
				if(params.len()>0 && params.len()<180) sendMessageToAll(pid, 207, 41, 66, format("Supporter (%d) %s: %s", pid, getPlayerName(pid), params));
				else sendMessageToPlayer(pid, 128, 0, 0, "Tip: /all (text)");
			}
		break;

		case "tp":
			if(player[pid].adminIsLogged){
				local args = sscanf("dddd", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Teleportowano gracza do gracza. Gracz: (%d) %s, gracz 2: (%d) (%s)", args[0], getPlayerName(args[0]),
						args[1], getPlayerName(args[1])));
						sendMessageToPlayer(args[0], 207, 41, 66, format("Supporter (%d) %s teleportowa� Ci� do (%d) %s.", pid, getPlayerName(pid), args[1],
						getPlayerName(args[1])));
						setPlayerPosition(args[0], args[1], args[2], args[3]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /tp (id) (id2)");
			}
		break;

		case "tppos":
			if(player[pid].adminIsLogged){
				local args = sscanf("dddd", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Teleportowno gracza. Gracz: (%d) %s.", args[0], getPlayerName(args[0])));
						sendMessageToPlayer(args[0], 207, 41, 66, format("Supporter (%d) %s teleportowa� Ci� na inn� pozycj�.", pid, getPlayerName(pid)));
						setPlayerPosition(args[0], args[1], args[2], args[3]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /tppos (id) (x) (y) (z)");
			}
		break;

		case "kick":
			if(player[pid].adminIsLogged){
				local args = sscanf("ds", params);
				if(args){
					if(isPlayerConnected(args[0])){
						sendMessageToPlayer(pid, 128, 0, 0, format("Wyrzucono gracza. Gracz: (%d) %s, pow�d: %s.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToPlayer(pid, 207, 41, 66, format("Supporter (%d) %s nada� Ci ostrze�enie. Pow�d: %s", pid, getPlayerName(pid), args[1]));
						player[args[0]].active = 0; kick(args[0]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /kick (id) (reason)");
			}
		break;

		case "ban":
			if(player[pid].adminIsLogged){
				local args = sscanf("dds", params);
				if(args && args[1]>0){
					if(isPlayerConnected(args[0])){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zbanowano gracza. Gracz: (%d) %s, minut: %d, pow�d: %s.", args[0], getPlayerName(args[0]), args[1], args[2]));
						sendMessageToAll(207, 41, 66, format("Supporter (%d) %s zbanowa� %s. Pow�d: %s", pid, getPlayerName(pid), getPlayerName(args[0]), args[1]));
						player[args[0]].active = 0; ban(args[0], args[1], args[2]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /ban (id) (minutes) (reason)");
			}
		break;

		case "warn":
			if(player[pid].adminIsLogged){
				local args = sscanf("ds", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Ostrze�ono gracza. Gracz: (%d) %s, pow�d: %s.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToPlayer(pid, 207, 41, 66, format("Supporter (%d) %s nada� Ci ostrze�enie. Pow�d: %s", pid, getPlayerName(pid), args[1]));
						sendMessageToAll(207, 41, 66, format("Supporter (%d) %s ostrzeg� (%d) %s. Pow�d: %s", pid, getPlayerName(pid), args[0], getPlayerName(args[0]), args[1]));
						local pos = getPlayerPosition(pid);
						setPlayerPosition(args[0], pos.x, pos.y+300, pos.z);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /warn (id) (reason)");
			}
		break;

		case "descdelete":
			if(player[pid].adminIsLogged){
				local args = sscanf("ds", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Usuni�to opis gracza. Gracz: (%d) %s.", args[0], getPlayerName(args[0])));
						sendMessageToPlayer(args[0], 207, 41, 66, format("Supporter (%d) %s usun�� Tw�j opis.", pid, getPlayerName(pid)));
						player[args[0]].description = "delete"; setPlayerColor(args[0], 250, 250, 250);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /descdelete (id)");
			}
		break;

		case "sethp":
			if(player[pid].adminIsLogged){
				local args = sscanf("dd", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono punkty trafie�. Gracz: (%d) %s, liczba: %d.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToPlayer(pid, 207, 41, 66, format("Supporter (%d) %s zmieni� Ci punkty trafie� na %d.", pid, getPlayerName(pid), args[1]));
						setPlayerHealth(args[0], args[1]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /sethp (id) (amount)");
			}
		break;

		case "setmaxhp":
			if(player[pid].adminIsLogged && player[pid].admin>1){
				local args = sscanf("dd", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono maksymalne punkty trafie�. Gracz: (%d) %s, liczba: %d.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToPlayer(pid, 207, 41, 66, format("Supporter (%d) %s zmieni� Ci maksymalne punkty trafie� na %d.", pid, getPlayerName(pid), args[1]));
						setPlayerMaxHealth(args[0], args[1]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /setmaxhp (id) (amount)");
			}
		break;

		case "setpn":
			if(player[pid].adminIsLogged && player[pid].admin>1){
				local args = sscanf("dd", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono PN. Gracz: (%d) %s, liczba: %d.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToPlayer(pid, 207, 41, 66, format("Supporter (%d) %s zmieni� Ci PN na %d.", pid, getPlayerName(pid), args[1]));
						player[pid].pn = args[1];
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /setpn (id) (amount)");
			}
		break;

		case "setstr":
			if(player[pid].adminIsLogged && player[pid].admin>1){
				local args = sscanf("dd", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono si��. Gracz: (%d) %s, liczba: %d.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToPlayer(pid, 207, 41, 66, format("Supporter (%d) %s zmieni� Ci si�� na %d.", pid, getPlayerName(pid), args[1]));
						setPlayerStrength(args[0], args[1]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /setstr (id) (amount)");
			}
		break;

		case "setdex":
			if(player[pid].adminIsLogged && player[pid].admin>1){
				local args = sscanf("dd", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono zr�czno��. Gracz: (%d) %s, liczba: %d.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToPlayer(pid, 207, 41, 66, format("Supporter (%d) %s zmieni� Ci zr�czno�� na %d.", pid, getPlayerName(pid), args[1]));
						setPlayerDexterity(args[0], args[1]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /setdex (id) (amount)");
			}
		break;

		case "setwp":
			if(player[pid].adminIsLogged && player[pid].admin>1){
				local args = sscanf("dd", params);
				if(args && args[1]>-1 && args[1]<4){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono umiej�tno�� walki broni�. Gracz: (%d) %s, umiej�tno��: %d, liczba: %d.", args[0],
						getPlayerName(args[0]), args[1]), args[2]);
						sendMessageToPlayer(pid, 207, 41, 66, format("Supporter (%d) %s zmieni� Ci umiej�tno�� walki broni� nr %d na %d.", pid, getPlayerName(pid), args[1]), args[2]);
						setPlayerDexterity(args[0], args[1]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /setwp (id) (nr) (amount)");
			}
		break;

		case "giveadmin":
			if(player[pid].adminIsLogged && player[pid].admin==3){
				local args = sscanf("dds", params);
				if(args && args[1]>0 && args[1]<4){
					if(player[args[0]].isLogged){
							sendMessageToPlayer(pid, 128, 0, 0, format("NADANO ADMINISTRATORA. GRACZ: (%d) %s, POZIOM: %d.", args[0], getPlayerName(args[0]), args[2], args[1]));
							player[args[0]].admin = args[1];
							player[args[0]].password = md5(args[2]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /giveadmin (id) (level 1-3) (password)");
			}
		break;

		case "giveitem":
			if(player[pid].adminIsLogged && player[pid].admin==3){
			local args = sscanf("dds", params);
			if(args){
				if(player[args[0]].isLogged){
					if(item.hasPlace(pid)){
						sendMessageToPlayer(pid, 128, 0, 0, format("Podarowano przedmiot. Gracz: (%d) %s, instancja: %s, liczba: %d.", args[0], getPlayerName(args[0]), args[2], args[1]));
						sendMessageToPlayer(pid, 207, 41, 66, format("Supporter (%d) %s podarowa� Ci przedmiot/y %s w liczbie %d.", pid, getPlayerName(pid), args[2], args[1]));
						item.give(args[0], args[2], args[1]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Gracz nie ma miejsca w ekwipunku.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
			}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /giveitem (id) (amount) (instance)");
		}
		break;

		case "removeitem":
			if(player[pid].adminIsLogged && player[pid].admin==3){
			local args = sscanf("dds", params);
			if(args){
				if(player[args[0]].isLogged){
					sendMessageToPlayer(pid, 128, 0, 0, format("Zabrano przedmiot. Gracz: (%d) %s, instancja: %s, liczba: %d.", args[0], getPlayerName(args[0]), args[2], args[1]));
					sendMessageToPlayer(pid, 207, 41, 66, format("Supporter (%d) %s usun�� Ci przedmiot/y %s w liczbie %d.", pid, getPlayerName(pid), args[2], args[1]));
					item.remove(args[0], args[2], args[1]);
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid�owe ID.");
			}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /removeitem (id) (amount) (instance)");
		}
		break;

		case "setserverdescription":
			if(player[pid].adminIsLogged && player[pid].admin==3){
				if(params && params.len()<180){
					sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono opis serwera. Tekst: %s", params));
					setServerDescription(params);
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /setserverdescription (text)");
			}
		break;

		/*
			Admin commands end
		*/

		}
	}
});

addEventHandler("onPlayerRespawn", function(pid){
	setPlayerVisual(pid, player[pid].visual[0], player[pid].visual[1], player[pid].visual[2], player[pid].visual[3]);
	for(local i = 0; i<item[pid].instance.len(); ++i){
		giveItem(pid, Items.id(item[pid].instance[i]), item[pid].amount[i]);
	}
});

function onPlayerDialogBoxResponse(pid, id, position){
	if(id==0){
		switch(position){
			case 0: player[pid].sex=1; callClientFunc(pid, "dialog.show", 1); break;
			case 1: player[pid].sex=2; callClientFunc(pid, "dialog.show", 1); break;
		}
	}
	else if(id==1){
		switch(position){
			case 0: player[pid].race=1; player.registerEnd(pid); break;
			case 1: player[pid].race=2; player.registerEnd(pid); break;
		}
	}
	else if(id==2){
		if(position!=7){
			if(player[pid].pn>0){
				player[pid].pn--;
				sendMessageToPlayer(pid, 194, 178, 128, "Podniesiono poziom umiej�tno�ci.");
				switch(position){
					case 0: setPlayerMaxHealth(pid, player[pid].maxHealth+1); break;
					case 1: setPlayerStrength(pid, player[pid].strength+1); break;
					case 2: setPlayerDexterity(pid, player[pid].dexterity+1); break;
					case 3: setPlayerSkillWeapon(pid, player[pid].skillWeapon[0]+1); break;
					case 4: setPlayerSkillWeapon(pid, player[pid].skillWeapon[1]+1); break;
					case 5: setPlayerSkillWeapon(pid, player[pid].skillWeapon[2]+1); break;
					case 6: setPlayerSkillWeapon(pid, player[pid].skillWeapon[3]+1); break;
					}
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Nie posiadasz �adnych punkt�w nauki.");
			}else callClientFunc(pid, "dialog.destroy");
	}else if(id==3){
			switch(position){
				case 0: item.buy(pid, 2, "ITFO_FISH", 1); break;
				case 1: item.buy(pid, 3, "ITFO_BREAD", 1); break;
				case 2: item.buy(pid, 5, "ITFO_HONEY", 1); break;
				case 3: item.buy(pid, 5, "ITFO_CHEESE", 1); break;
				case 4: callClientFunc(pid, "dialog.destroy");
			}
	}else if(id==4){
			switch(position){
				case 0: item.buy(pid, 3, "ITPO_SPEED", 1); break;
				case 1: item.buy(pid, 15, "ITPO_HEALTH_01", 1); break;
				case 2: item.buy(pid, 25, "ITPO_HEALTH_03", 1); break;
				case 3: item.buy(pid, 25, "ITFO_ADDON_SCHLAFHAMMER", 1); break;
				case 4: callClientFunc(pid, "dialog.destroy");
			}
	}else if(id==5){
			switch(position){
				case 0: item.buy(pid, 100, "ITAR_VLK_L", 1); break;
				case 1: item.buy(pid, 220, "ITAR_LEATHER_L", 1); break;
				case 2: item.buy(pid, 600, "ITAR_DIEGO", 1); break;
				case 3: callClientFunc(pid, "dialog.destroy");
			}
	}else if(id==6){
			switch(position){
				case 0: item.buy(pid, 12, "ITMW_1H_BAU_MACE", 1); break;
				case 1: item.buy(pid, 110, "ITMW_1H_MISC_AXE", 1); break;
				case 2: item.buy(pid, 170, "ITMW_1H_SWORD_L_03", 1); break;
				case 3: callClientFunc(pid, "dialog.destroy");
			}
	}else if(id==7){
			switch(position){
				case 0: item.buy(pid, 25, "ITRW_ARROW", 25); break;
				case 1: item.buy(pid, 25, "ITRW_BOLT", 25); break;
				case 2: item.buy(pid, 70, "ITRW_BOW_L_01", 1); break;
				case 3: item.buy(pid, 90, "ITRW_CROSSBOW_L_01", 1); break;
				case 4: callClientFunc(pid, "dialog.destroy");
			}
	}else if(id==8){
		switch(position){
			case 0:
				if(item[pid].instance.len()>0) callClientFunc(pid, "dialog.show", 9);
				else sendMessageToPlayer(pid, 192, 192, 192, ">Nie posiadasz �adnego ekwipunku.");
			break;
			case 1:
				local packet = bank.depositPacket(pid);
				if(packet) callClientFunc(pid, "dialog.show", 10, packet);
				else sendMessageToPlayer(pid, 192, 192, 192, ">Nie posiadasz �adnego depozytu w banku.");
			break;
			case 2: callClientFunc(pid, "dialog.destroy");
		}
	}else if(id==9){
		if(position!=item[pid].instance.len()){
			if(position<=item[pid].instance.len()){
				if(bank[pid].instance.len()<60){
					sendMessageToPlayer(pid, 194, 178, 128, "Zdeponowano przedmiot.");
					removeItem(pid, Items.id(item[pid].instance[position]), 1);
					local index = bank[pid].instance.find(item[pid].instance[position]);
					if(index!=null) bank[pid].amount[index]++;
					else{
						bank[pid].instance.push(item[pid].instance[position]);
						bank[pid].amount.push(1);
					}
					callClientFunc(pid, "bankRefresh", 0);
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Brak miejsca w banku.");
			}
		}else callClientFunc(pid, "dialog.destroy");
	}else if(id==10){
		if(position!=bank[pid].instance.len()){
			if(position<=bank[pid].instance.len()){
				sendMessageToPlayer(pid, 194, 178, 128, "Odebrano przedmiot.");
				giveItem(pid, Items.id(bank[pid].instance[position]), 1);
				local index = bank[pid].instance.find(bank[pid].instance[position]);
				if(index!=null){
					if(bank[pid].amount[index]>1) bank[pid].amount[index]--;
					else{
						bank[pid].instance.remove(index);
						bank[pid].amount.remove(index);
					}
				}
				bank.depositPacketSend(pid);
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Nie posiadasz wi�cej depozytu w banku.");
		}else callClientFunc(pid, "dialog.destroy");
	}
}
