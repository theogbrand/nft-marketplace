# Pseudo NFT Marketplace 

## startup fake accounts for testing
```shell
npx hardhat node
```

## Deploy smart contracts locally
```shell
npx hardhat run scripts/deploy.js --network localhost
```

## Deploy smart contracts on Polygon Mumbai Testnet
```shell
npx hardhat run scripts/deploy.js --network mumbai
```

### final notes
* Remember to double check and update smart contract addresses (nftmarketaddress, nftaddress) in config.js when deployed/test accordingly
* Ensure only ONE account is logged in at any one time. Log out ALL other active accounts including fake testing accounts
* otherwise, try logging out, refresh and login again, even re-trying failed transactions manually on metamask (Mumbai's performance is unpredictable)
* if still unable, try changing mumbai url in hardhat.config.js to other RPC URLs: https://docs.polygon.technology/docs/develop/network-details/network
* all features tested and works on Mumbai testnet as of last deployment