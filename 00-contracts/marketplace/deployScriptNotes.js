const { ethers, upgrades } = require("hardhat");

async function main() {
    const DataAnalysis = await ethers.getContractFactory("DataAnalysisContract");
    const dataAnalysis = await upgrades.deployProxy(DataAnalysis, [ /* constructor arguments */ ]);
    await dataAnalysis.deployed();
    console.log("DataAnalysisContract deployed to:", dataAnalysis.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
