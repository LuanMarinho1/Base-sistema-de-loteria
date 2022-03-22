/*****************************************************************************************************************/
// Base de sistema de loteria em TextDraw 1.0 - By Dath. https://github.com/LuanMarinho1/Base-sistema-de-loteria //
/*****************************************************************************************************************/
#include <a_samp>
#include <zcmd>
#include <sscanf2>

#define VALOR 500
#define TEMPO 15000
#define PREMIO 200000

new ContarLoteria, Text:LoteriaTexto, bool:LoteriaInit, bool:TemBilhete[MAX_PLAYERS], BilheteNumero[MAX_PLAYERS];

public OnGameModeInit()
{
    LoteriaInit = true, SetTimer("LoteriaUpdate", TEMPO, 1);
    LoteriaTexto = TextDrawCreate(576.0, 130.0, "_"), TextDrawAlignment(LoteriaTexto, 2), TextDrawFont(LoteriaTexto, 2), TextDrawSetOutline(LoteriaTexto, 1);
    TextDrawLetterSize(LoteriaTexto, 0.20, 1.39), TextDrawUseBox(LoteriaTexto, 1), TextDrawTextSize(LoteriaTexto, 22.0, 60.0), TextDrawBoxColor(LoteriaTexto, 120);
	return 0;
}
forward LoteriaUpdate(); public LoteriaUpdate()
{
	new Numero = random(99), String[15], String2[38];
	if(LoteriaInit == true)
	{
		for(new i; i < MAX_PLAYERS; i++){TextDrawShowForPlayer(i, LoteriaTexto);}
		if(ContarLoteria < 25)
		{
		    if(Numero < 10) { format(String, sizeof(String), "LOTERIA: 0%i", Numero); }
			else { format(String, sizeof(String), "LOTERIA: %i", Numero); }
			TextDrawSetString(LoteriaTexto, String), ContarLoteria++, SetTimer("LoteriaUpdate", 100, 0);
		}
		else
		{
			if(Numero == 0) return ContarLoteria = 24, SetTimer("LoteriaUpdate", 100, 0);
			if(Numero < 10) { format(String, sizeof(String), "LOTERIA: ~g~0%i", Numero); }
			else { format(String, sizeof(String), "LOTERIA: ~g~%i", Numero); }
			format(String2, sizeof(String2), "[Loteria] O número sorteado foi %i.", Numero), SendClientMessageToAll(-1, String2), TextDrawSetString(LoteriaTexto, String), LoteriaInit = false, SetTimer("LoteriaUpdate", 3000, 0);
			for(new i; i < MAX_PLAYERS; i++)
			{
			    if(TemBilhete[i] == true && BilheteNumero[i] == Numero) { SendClientMessage(i, -1, "[Loteria] Você ganhou o prêmio da loteria!"), GivePlayerMoney(i, PREMIO); }
			}
		}
	}
	else
	{
	    for(new i; i < MAX_PLAYERS; i++){TextDrawHideForPlayer(i, LoteriaTexto), TemBilhete[i] = false, BilheteNumero[i] = 0;}
		ContarLoteria = 0, LoteriaInit = true;
	}
	return 0;
}
CMD:bilhete(playerid, params[])
{
	if(sscanf(params, "i", BilheteNumero[playerid])) return SendClientMessage(playerid, -1, "[ERRO] Use /bilhete [Número 1-99]");
	if(BilheteNumero[playerid] < 1 || BilheteNumero[playerid] > 99) return SendClientMessage(playerid, -1, "[ERRO] Escolha um número entre 1 - 99");
	TemBilhete[playerid] = true, GivePlayerMoney(playerid, -VALOR), SendClientMessage(playerid, -1, "[Loteria] Bilhete comprado!");
	return 1;
}
