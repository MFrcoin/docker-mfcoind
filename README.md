# /mfcoind

mfcoind docker image.

## Usage
### How to use this image

It behaves like a binary, so you can pass any arguments to the image and they will be forwarded to the `mfcoind` binary:

```sh
$ docker run --name mfcoind -d mfcoin/mfcoind \
  -rpcallowip=::/0 \
  -rpcpassword=bar \
  -rpcuser=foo
```

By default, `mfcoin` will run as as user `mfcoin` for security reasons and with its default data dir (`~/.mfcoin`). If you'd like to customize where `mfcoin` stores its data, you must use the `MFC_DATA` environment variable. The directory will be automatically created with the correct permissions for the user and `mfcoin` automatically configured to use it.

```sh
$ docker run --env MFC_DATA=/var/lib/mfcoin --name mfcoind -d mfcoin/mfcoind
```

You can also mount a directory it in a volume under `/home/mfcoin/.MFC` in case you want to access it on the host:

```sh
$ docker run -v /home/mfcoin:/home/mfcoin/.MFC --name mfcoind -d mfcoin/mfcoind
```
That will allow to access containers `~/.MFC` directory in `/opt/mfcoin` on the host.

```sh
$ docker run -v ${PWD}/data:/home/mfcoin/.MFC --name mfcoind -d mfcoin/mfcoind
```
will mount current directory in containers `~/.MFC`

To map container RPC ports to localhost start container with following command:

```sh
$ docker run -v /opt/mfcoin:/home/mfcoin/.MFC -p 22825:22825 --name mfcoind -d mfcoin/mfcoind -rpcallowip=::/0
```
You may want to change the port that it is being mapped to if you already run a mfcoin instance on the localhost.
For example: `-p 9999:22825` will map port 22825 from container to localhost:9999.

Now you will be able to `curl` the mfcoin RPC in the container:

`curl --user foo:bar --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getinfo", "params": [] }'  -H 'content-type: text/plain;' localhost:22825/`

> {"result":{"fullversion":"v0.8.0.0-63808ba","version":80000,"protocolversion":70015,"walletversion":130000,"balance":0.00000000,"newmint":0.00000000,"stake":0.00000000,"blocks":63980,"moneysupply":21933285.52415774,"timeoffset":0,"connections":3,"proxy":"","difficulty":0.001273460351749045,"testnet":false,"keypoololdest":1575384401,"keypoolsize":500,"encrypted":false,"mintonly":false,"paytxfee":0.00010000,"relayfee":0.00010000,"errors":""},"error":null,"id":"curltest"}
