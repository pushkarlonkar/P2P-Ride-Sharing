var TOKENX = artifacts.require("./TOKENX.sol");

module.exports = function(deployer) {
  deployer.deploy(TOKENX,5000000);
};
