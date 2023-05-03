require("dotenv").config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
require("@nomicfoundation/hardhat-toolbox");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const { GOERLI_API_URL, MAINNET_API_URL, PRIVATE_KEY, ETHERSCAN_KEY } =
  process.env;
module.exports = {
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  defaultNetwork: "goerli",
  networks: {
    hardhat: {
      accounts: [
        {
          privateKey: `0x${PRIVATE_KEY}`,
          balance: "100000000000000000000000000",
        },
      ],
    },
    goerli: {
      url: GOERLI_API_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    mainnet: {
      url: MAINNET_API_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_KEY,
  },
};
