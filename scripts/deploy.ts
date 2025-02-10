import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Fetch the balance using ethers.provider.getBalance
  const deployerBalance = await ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", ethers.formatEther(deployerBalance)); // Format balance in ETH

  // Deploy DailyAttendance
  const DailyAttendance = await ethers.getContractFactory("DailyAttendance");
  const attendance = await DailyAttendance.deploy();
  await attendance.waitForDeployment();
//   console.log("DailyAttendance deployed to:", attendance.address);
  console.log(`DailyAttendance deployed to:, ${attendance.getAddress()}`);

  // Deploy SimpleBank
  const SimpleBank = await ethers.getContractFactory("SimpleBank");
  const bank = await SimpleBank.deploy();
  await bank.waitForDeployment();
//   console.log("SimpleBank deployed to:", bank.address);
  console.log(`SimpleBank deployed to:, ${bank.getAddress()}`);

  // Deploy Escrow
  const Escrow = await ethers.getContractFactory("Escrow");
  const escrow = await Escrow.deploy();
  await escrow.waitForDeployment();
  console.log(`Escrow deployed to:, ${escrow.getAddress()}`);

  // Deploy Greeting (with initial greeting)
  const Greeting = await ethers.getContractFactory("Greeting");
  const greeting = await Greeting.deploy("Hello, Blockchain World!");
  await greeting.waitForDeployment();
//   console.log("Greeting deployed to:", greeting.address);
  console.log(`Greeting deployed to:, ${greeting.getAddress()}`);

  // Deploy Election (Voting)
  const Election = await ethers.getContractFactory("Election");
  const election = await Election.deploy();
  await election.waitForDeployment();
//   console.log("Election deployed to:", election.address);
  console.log(`Election deployed to:, ${election.getAddress()}`);

  console.log("All contracts deployed successfully!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });