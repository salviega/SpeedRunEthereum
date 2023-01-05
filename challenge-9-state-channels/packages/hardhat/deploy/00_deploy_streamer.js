// deploy/00_deploy_streamer.js

const { ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  await deploy("Streamer", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    log: true,
  });

  await ethers.getContract("Streamer", deployer);

  //  console.log("\n 🤹  Sending ownership to frontend address...\n");
  // Checkpoint 2: change address to your frontend address vvvv
  // const ownerTx = await streamer.transferOwnership(
  //   "0x2E23A5e4b498b8bfaB7636BCD8Ef32ed1287dDd9"
  // );

  console.log("\n       confirming...\n");
  // const ownershipResult = await ownerTx.wait();
  // if (ownershipResult) {
  //   console.log("       ✅ ownership transferred successfully!\n");
  // }
};

module.exports.tags = ["Streamer"];
