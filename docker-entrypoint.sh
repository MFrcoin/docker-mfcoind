#!/bin/bash
set -e

if [ "$(echo "$1" | cut -c1)" = "-" ]; then
  echo "$0: assuming arguments for mfcoind"
  set -- mfcoind "$@"
fi

if [ "$(echo "$1" | cut -c1)" = "-" ] || [ "$1" = "mfcoind" ]; then

  mkdir -p "$MFC_DATA"
  chmod 700 "$MFC_DATA"
  chown -R mfcoin "$MFC_DATA"

	if [[ ! -s "$MFC_DATA/mfcoin.conf" ]]; then
    cat <<-EOF > "$MFC_DATA/mfcoin.conf"
    rpcallowip=::/0
    rpcpassword=${RPC_PASSWORD}
    rpcuser=${RPC_USER}
		EOF
    chown mfcoin "$MFC_DATA/mfcoin.conf"
	fi

  set -- "$@" -datadir="$MFC_DATA"
fi

if [ "$1" = "mfcoind" ] || [ "$1" = "mfcoin-cli" ] || [ "$1" = "mfcoin-tx" ]; then
  echo
  exec gosu mfcoin "$@"
fi

exec "$@"
