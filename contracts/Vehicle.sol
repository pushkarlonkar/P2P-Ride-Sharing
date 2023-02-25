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
    }

    mapping(address => VEHICLE_INFO) internal _vehicles;
    function addVehicle(address driver,VEHICLE_INFO memory _vehicle)
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