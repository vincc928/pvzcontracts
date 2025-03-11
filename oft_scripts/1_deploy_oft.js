const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  const TelgatherToken = await hre.ethers.getContractFactory("MyFT");
  let token = await TelgatherToken.deploy(
    "Zombie Power",
    "ZP",
    "0x1a44076050125825900e736c501f859c50fE728c",
    "0xa7e39127134845f3e9331ff2833d22516013ee4d",
    1000000000
  );
  await token.deployed();

  console.log("token: ", token.address, "\n", "deployer: ", deployer.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
