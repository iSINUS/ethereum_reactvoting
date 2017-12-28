var Questionary = artifacts.require("./Questionary.sol");
var LibLinkedList = artifacts.require("./LibLinkedList.sol");

module.exports = function(deployer) {
  deployer.deploy(Questionary);
  deployer.deploy(LibLinkedList);
  deployer.link(LibLinkedList, Questionary);
};
