// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Customer is Ownable {
    uint256 customer_count = 0;
    struct CUSTOMER {
        uint256 id;
        string name;
        string email;
        string dob;
        string govtId;
        string picture;
        address wallet;
    }

    mapping(address => CUSTOMER) public customers;

    function createCustomer(string memory _name,string memory _email,string memory _dob,string memory _govtId,string memory _picture)
        public
        returns (address)
    {   

        customer_count++;

        CUSTOMER memory customer = customers[msg.sender];

        customer.id = customer_count;
        customer.name = _name;
        customer.email = _email;
        customer.dob = _dob;
        customer.govtId = _govtId;
        customer.picture = _picture;
        customer.wallet = msg.sender;

        return msg.sender;
    }

    function getCustomer(address _walletAddr)
        public
        view
        returns (CUSTOMER memory)
    {
        CUSTOMER memory customer = customers[_walletAddr];
        return customer;
    }

    
}
