const main = async () => {
    const domainContractFactory = await hre.ethers.getContractFactory('Domains');
    const domainContract = await domainContractFactory.deploy("gmi");
    await domainContract.deployed();
  
    console.log("Contract deployed to:", domainContract.address);
  
    let txn = await domainContract.register("wagmi",  {value: hre.ethers.utils.parseEther('0.1')});
    await txn.wait();
    console.log("Minted domain wagmi.gmi");
  
    txn = await domainContract.setRecord("wagmi", "Hey, We are all gonna make it!!");
    await txn.wait();
    console.log("Set record for wagmi.gmi");
  
    const address = await domainContract.getAddress("wagmi");
    console.log("Owner of domain wagmi:", address);
  
    const balance = await hre.ethers.provider.getBalance(domainContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(balance));
};
  
const runMain = async () => {
try {
    await main();
    process.exit(0);
} catch (error) {
    console.log(error);
    process.exit(1);
}
};
  
runMain();