# Simple 721

A super simple sample 721 contract, with a fully on-chain svg storing element.

### Example

A deployment of this contract is available [here](https://goerli.etherscan.io/address/0x485F2dd54f4655FF9f116c09516535780C957f54#writeContract) and its corresponding OpenSea page [here](https://testnets.opensea.io/collection/simple-8)

### Setup

#### .env

Create a file named `.env`, containing the following lines:

```
MAINNET_API_URL="https://eth-mainnet.alchemyapi.io/v2/<mainnet key>"
GOERLI_API_URL="https://eth-goerli.g.alchemy.com/v2/<goerli key>"
PRIVATE_KEY="<a pkey for your eth wallet>"
ETHERSCAN_KEY="<etherscan key>"
```

To get an alchemy key, you'll need to sign up at alchemy.com and create projects for both mainnet and goerli.
Similarly for an etherscan key, you'll have to sign up and retrieve your API key.
For the private key, I recommend creating a new burner to play around with and send some eth to.

### Deploy

#### Goerli (default)

```shell
npx hardhat run scripts/deploy.js
npx hardhat verify <contract address from above>
```

#### Mainnet

```shell
npx hardhat run --network mainnet scripts/deploy.js
npx hardhat verify --network mainnet <contract address from above>
```

### Test

```shell
npx hardhat test
```
