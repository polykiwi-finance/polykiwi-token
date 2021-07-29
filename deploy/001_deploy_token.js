async function deploy (hre) {
    const {deployments, getNamedAccounts} = hre;
    const {deploy} = deployments;

    const {deployer} = await getNamedAccounts();

    await deploy('KiwiToken', {
        from: deployer,
        log: true,
    })
}

module.exports = deploy;

deploy.tags = ['KiwiToken'];