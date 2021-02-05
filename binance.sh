#!/bin/bash

# Opis:
# - Skrypt KUPUJE cenie rynkowej (Market) monete za podana ilosc USDT (lub inne zdefiowane w zmienne PAIR_TO)
# - Skrypt SPRZEDAJE po cenie rynkowej (Market) podana ilosc monet za USDT (lub inne zdefiowane w zmienne PAIR_TO)
# Uzycie:
# - Przykladowo chcemy KUPIC BTC za kwote 10 USDT (domyslnie jest USDT)

# wiec wpisujemy:

# ./binance.sh buy 10 btc

# gdy chcemy sprzedac 5 BTC i otrzymac (domyslnie) USDT piszemy:

# ./binance.sh sell 5 btc

# UWAGA poniższy błąd oznajmia że trade jest poniżej 10 USD i nie można go dokonac
# {"code":-1013,"msg":"Filter failure: MIN_NOTIONAL"}

# ----------- KONFIGURACJA --------------------------
# BINANCE API

API_KEY=TWOJ_API_KEY_TUTAJ
SECRET_KEY=TWOJ_SECRET_KEY_TUTAJ

# Jaka para do podanej monety (duze litery)
PAIR_TO=USDT

# --------------------------------------------------


if [ "$#" -ne 3 ]; then
  echo "============ Opis ======================="
  echo "1. Skrypt KUPUJE cenie rynkowej (Market) monete za podana ilosc $PAIR_TO"
  echo "2. Skrypt SPRZEDAJE po cenie rynkowej (Market) podana ilosc monet za $PAIR_TO"
  echo ""
  echo "============ Konfiguracja ==============="
  echo "Wyedytuj skrypt, zamien API_KEY oraz SECRET_KEY z Binance i opcjonalnie PAIR_TO"
  echo ""
  echo "============ Uzycie ====================="
  echo "Przyklad 1: chcemy KUPIC BTC za kwote 10 USDT (domyslnie):"
  echo ""
  echo "./binance.sh buy 10 btc"
  echo ""
  echo "gdy chcemy SPRZEDAC liczbe 5 BTC i otrzymac USDT (dmyslnie):"
  echo ""
  echo "./binance.sh sell 5 btc"
  echo ""
  echo "UWAGA poniższy błąd oznajmia że trade jest poniżej 10 USD i nie można go dokonac"
  echo "{code:-1013,msg:Filter failure: MIN_NOTIONAL}"
  exit 0
fi


# READY ...

PAIR_FROM=`echo $3 | tr [a-z] [A-Z]`

SIDE=`echo $1 | tr [a-z] [A-Z]`

QUANTITY=$2

TIMESTAMP=$(date +%s)000

PAYLOAD="symbol=$PAIR_FROM$PAIR_TO&side=$SIDE&type=MARKET&recvWindow=5000&timestamp=$TIMESTAMP"

if [ $SIDE == "BUY" ]
then
   REQUEST="$PAYLOAD&quoteOrderQty=$QUANTITY"
else
   REQUEST="$PAYLOAD&quantity=$QUANTITY"
fi


SIGNATURE=`echo -n "$REQUEST" | openssl dgst -sha256 -hmac $SECRET_KEY  | cut -d" " -f2`



# ... AND GOOOO!!!!!

curl -H "X-MBX-APIKEY: $API_KEY" -X POST 'https://api.binance.com/api/v3/order' -d "$REQUEST&signature=$SIGNATURE"
