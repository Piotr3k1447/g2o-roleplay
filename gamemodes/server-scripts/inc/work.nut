function work(pid, gold){
  if(gold){
    sendMessageToPlayer(pid, 194, 178, 128, "Uda�o si� zarobi� 1 szt. z�.");
    item.give(pid, "ITMI_GOLD", 1);
  }else sendMessageToPlayer(pid, 194, 178, 128, "Nie uda�o si� nic zarobi�.");
  player[pid].isBusy = false;
}
