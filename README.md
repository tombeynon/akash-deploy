# Akash Deploy UI

A quick and dirty deployment UI for Akash. I built this to help the community get started with Akash, and to make it easier to manage multiple deployments in one place. It's currently in a very early stage of development but it's already proving very useful.

This tool runs locally on your own machine using Docker. I'm looking into a hosted solution using Keplr but the need for a deployment certificate makes this more challenging to self-custody. 

<img width="1357" alt="Screenshot 2021-03-28 at 04 32 34" src="https://user-images.githubusercontent.com/670623/112741543-ab72a280-8f7e-11eb-966d-67dad4aff37d.png">

## Installation

You will need [Docker installed](https://docs.docker.com/get-docker) on your machine first. After that it's a simple one line command to run:

```
docker run -v ~/.akash:/root/akash -p 3000:3000 --rm -it tombeynon/akash-deploy
```

Note the following two options:

`-v ~/.akash:/root/akash` - the first argument is your Akash home directory. This can be an existing or new directory.

`-p 3000:3000` - the first argument is the port the tool will run on on your machine.

To update to the latest version, just pull the latest docker image:

```
docker pull tombeynon/akash-deploy
```

### Using an existing Akash keyfile and certificate

If you've previously used the Akash CLI with the `file` keystore, and have an Akash home directory with certificate etc, you can use the same path for the Akash volume above. Using the same password you entered when creating the keystore, the tool will use your existing certificate and keystore. You may need to use the same key name, which is detailed in the [Environment Variables](#environment-variables) section below.

### Restore an existing wallet

The tool has basic wallet management features, allowing you to create a new wallet or restore an existing wallet from a mnemonic. Note that if you have previously deployed but can't restore your certificate as above, you will need to create a new one and update your deployment. 

### Environment variables

You can pass the following environment variables to the application via `docker run`

`AKASH_NET=mainnet` - switch the tool to other Akash networks

`AKASH_CLI_VERSION=latest` - use a specific CLI version

`AKASH_HOME=/root/akash` - the Akash home directory inside the container

`KEY_NAME=deploy` - the key name used for the wallet

`FEE_RATE=5000uakt` - fee rate for all transactions

## Roadmap

- Manifest builder UI
- Better fee handling
- Manage multiple keys
- Basic transaction history
- Extract the Akash library as a Ruby gem (let me know if anyone is interested in this)
- Hosted version with self-custody via Keplr. Unsure how to handle certificate
- Make it prettier

Donate me a coffee to help me work faster: akash1w25hcy6sq66x8j0hwcda4f9fn7l63ntx3h6656

## Disclaimer

I built this very quickly (first commit was 7 days ago at the time of writing) and it's one of my first projects in anything related to blockchain. I'm a Ruby developer by trade so while I can be confident in most of this application, Akash is still new to me. Here be dragons (maybe).
