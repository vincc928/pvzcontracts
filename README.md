# install dependencies
npm i
# clean build folder
npx hardhat clean
# compile smart contracts
npx hardhat compile
# deploy smart contracts
npx hardhat run --network kaia_oft oft_scripts/1_deploy_oft.js

Following the deployment of the smart contract, mint the tokens to the multisignature address. This address is safeguarded by multiple wallets, requiring over 50% approval to authorize any transactions.
