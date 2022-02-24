const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const domainContractFactory = await hre.ethers.getContractFactory('Domains');
    const domainContract = await domainContractFactory.deploy();
    await domainContract.deployed();

    console.log("Contract deployed to: ", domainContract.address);
    console.log("Contract deployed by: ", owner.address)

    let txn = await domainContract.register("wagmi");
    await txn.wait();

    let domainOwner = await domainContract.getAddress("wagmi");
    console.log("Owner of domain:", domainOwner);

    // randomPerson trying to change the record that doesn't belong to him.... How dare he do that??
    txn = await domainContract.setRecord("wagmi", "Hey, We are all gonna make it!!");
    await txn.wait();

    let domainRecord = await domainContract.getRecord("wagmi");
    console.log("Record for wagami.gmi:", domainRecord)

    txn = await domainContract.connect(randomPerson).register("randomPerson");
    await txn.wait();

    domainOwner = await domainContract.getAddress("randomPerson");
    console.log("Owner of domain:", domainOwner);

    txn = await domainContract.connect(randomPerson).setRecord("randomPerson", "Even me the randomPerson is gonna make it")
    
    domainRecord = await domainContract.getRecord("randomPerson");
    console.log("Record for randomPerson.gmi:", domainRecord)
};

const runMain = async() => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();