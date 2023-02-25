// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Driver is Ownable {
    
    uint256 driver_count  = 0 ;

    struct DRIVER {
        uint256 id;
        string name;
        string dob;
        string curAddress;
        string govtID;
        string picture;
        string DL;
        address wallet;
    }

    mapping(address => DRIVER) public drivers;
    
    function createDriver(string memory _name,string memory _dob,string memory _curAddress,string memory _govtId,string memory _picture,string memory _dl)
        public
        returns (address)
    {   

        driver_count++;

        DRIVER storage driver = drivers[msg.sender];

        driver.id = driver_count;
        driver.name = _name;
        driver.dob = _dob;
        driver.curAddress = _curAddress;
        driver.govtID = _govtId;
        driver.DL = _dl;
        driver.picture = _picture;
        driver.wallet = msg.sender;

        return msg.sender;
    }

    function getDriver(address _walletAddr)
        public
        view
        returns (DRIVER memory)
    {
        DRIVER memory driver = drivers[_walletAddr];
        return driver;
    }
}
    