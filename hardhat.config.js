require('@nomiclabs/hardhat-waffle')

const fs = require('fs')
const privateKey = fs.readFileSync('.secret').toString()

module.exports = {
  networks: {
    hardhat: {
      chainId: 1337,
    },
    mumbai: {
      url: 'https://matic-testnet-archive-rpc.bwarelabs.com',
      accounts: [privateKey],
    },
  },
  solidity: '0.8.4',
}
