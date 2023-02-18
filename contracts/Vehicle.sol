pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Vehicle is Ownable {
    enum VEHICLE_TYPE{
        MINI,
        PRIME,
        SEDAN,
        SUV
    }

    struct VEHICLE_INFO{
        string vehicle_no;
        string RC;
        string vehicle_images;
        VEHICLE_TYPE vehicle_type;
        address driver;
    }

    mapping(address => VEHICLE_INFO) internal _vehicles;
}