# Akash Deploy UI

A quick and dirty deployment UI for Akash. I built this to help the community get started with Akash, and to make it easier to manage multiple deployments in one place. It's currently in a very early stage of development but it's already proving very useful.

This tool runs locally on your own machine using Docker. I'm looking into a hosted solution using Keplr but the need for a deployment certificate makes this more challenging to self-custody. 

<img width="1357" alt="Screenshot 2021-03-28 at 04 32 34" src="https://user-images.githubusercontent.com/670623/112741543-ab72a280-8f7e-11eb-966d-67dad4aff37d.png">

Once you've [got the tool running](#installation), it will direct you through the process of deploying to some extent. You should also [check out the Examples wiki](https://github.com/tombeynon/akash-deploy/wiki/Examples) for some ideas.

## Roadmap

- ~~Container logs~~
- ~~Funding an existing escrow account~~
- Better walkthrough of deployment (e.g. submit manifest)
- Manifest builder UI
- Local currency pricing and forecasts
- Better fee handling
- Manage multiple keys
- Basic transaction history
- Extract the Akash library as a Ruby gem (let me know if anyone is interested in this)
- Hosted version with self-custody via Keplr. Unsure how to handle certificate
- Make it prettier

Donate me a coffee to help me work faster: akash1w25hcy6sq66x8j0hwcda4f9fn7l63ntx3h6656

## Installation

You will need [Docker installed](https://docs.docker.com/get-docker) on your machine first. After that it's a simple one line command to run:

```
docker run -v ~/.akash-ui:/root/akash -p 3000:3000 --rm -it tombeynon/akash-deploy
```

Note the following two options:

`-v ~/.akash-ui:/root/akash` - the first argument is your Akash home directory. Note we use `~/.akash-ui` here instead of the default `~/.akash` to protect existing installations. Feel free to use whatever. 

`-p 3000:3000` - the first argument is the port the tool will run on on your machine.

**The deploy tool should now be accessible at [http://localhost:3000](http://localhost:3000)** (or the port specified above)


### Updates

To update to the latest version, just pull the latest docker image:

```
docker pull tombeynon/akash-deploy
```

You will need to restart the container after updating (CTRL-C to quit)

### Using an existing Akash keyfile and certificate

If you've previously used the Akash CLI with the `file` keystore, and have an Akash home directory with certificate etc, you can use the same path for the Akash volume above. Using the same password you entered when creating the keystore, the tool will use your existing certificate and keystore. You may need to use the same key name, which is detailed in the [Environment Variables](#environment-variables) section below.

### Restore an existing wallet

The tool has basic wallet management features, allowing you to create a new wallet or restore an existing wallet from a mnemonic. Note that if you have previously deployed but can't restore your certificate as above, you will need to create a new one and update your deployment. 

### Environment variables

You can pass the following environment variables to the application via `docker run`

`AKASH_NET=mainnet` - switch the tool to other Akash networks

`AKASH_CLI_VERSION=latest` - use a specific CLI version

`AKASH_HOME=/root/akash` - the Akash home directory inside the container

`RPC_NODE=http://127.0.0.1:80` - sets the RPC node (defaults to a random entry from [overclk/net](https://github.com/ovrclk/net/blob/master/mainnet/rpc-nodes.txt))

`KEY_NAME=deploy` - the key name used for the wallet

`FEE_RATE=5000uakt` - fee rate for all transactions

## Disclaimer

I built this very quickly (first commit was 5 days ago at the time of writing) and it's one of my first projects in anything related to blockchain. I'm a Ruby developer by trade so while I can be confident in most of this application, Akash is still new to me. Here be dragons (maybe).

## Further reading

- [Examples](https://github.com/tombeynon/akash-deploy/wiki/Examples)
- [Hello World tutorial](https://github.com/tombeynon/akash-hello-world)
- [Akash Documentation](https://docs.akash.network/)
- [Akash Network](https://akash.network/)
