// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
    Ownable Provides us with the security measures / modifiers 
 */

contract Customer is Ownable {
    struct USERS{
        string fullname ;
        string email;
        string dob;
        string govtID;
        string picture;
        address wallet ;
    }

    mapping(address=>USERS) private customers;

    function createCustomer(address _walletAddr,USERS memory _customer) 
        public 
        onlyOwner 
        returns(address)
    {
        USERS memory customer ;
        customer = _customer;
        customers[_walletAddr] = customer;

        return _walletAddr;
    }

    function updateCustomer(address _walletAddr)
        public 
        onlyOwner 
        returns (address)
    {
        USERS memory customer;

        customer = _customer;
        customers[_walletAddr] = customer;

        return _walletAddr;
    }   

    function getCustomer(address _walletAddr)
        public
        view
        onlyOwner
        returns (USERS memory)
    {
        USERS memory customer = customers[_walletAddr];
        return customer;
    }

    function addVehicle(address driver, VEHICLE_INFO memory _vehicle)
        public
        onlyOwner
    {
        VEHICLE_INFO memory vehicle;
        vehicle = _vehicle;
        _vehicles[driver] = vehicle;
    }

    function updateVehicle(address driver, VEHICLE_INFO memory _vehicle)
        public
        onlyOwner
    {
        VEHICLE_INFO memory vehicle;
        vehicle = _vehicle;
        _vehicles[driver] = vehicle;
    }

    function getVehicle(address driver)
        public
        view
        onlyOwner
        returns (VEHICLE_INFO memory)
    {
        return _vehicles[driver];
    }
}