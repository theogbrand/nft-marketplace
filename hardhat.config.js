require('@nomiclabs/hardhat-waffle');

const fs = require("fs")
const privateKey = fs.readFileSync(".secret").toString()

module.exports = {
  networks: {
    hardhat: {
      chainId: 1337,
    },
    mumbai: {
      // url: `https://polygon-mumbai.infura.io/v3/f3c222b145ee4c3eba877e8cfcec2123}`,
      url: "https://matic-testnet-archive-rpc.bwarelabs.com",
      accounts: [privateKey],
    },
    mainnet: {
      url: `https://polygon-mainnet.infura.io/v3/f3c222b145ee4c3eba877e8cfcec2123}`,
      accounts: [privateKey],
    },
  },
  solidity: '0.8.4',
};
