pragma solidity ^0.8.0;

contract CabPricePrediction {
    uint public basePrice;
    uint public surgeMultiplier;
    uint public constant PRICE_PRECISION = 1e18; // Used to ensure that the price is returned as a whole number
    uint public constant EARTH_RADIUS = 6371000; // Mean radius of the Earth in meters
    
    constructor(uint _basePrice, uint _surgeMultiplier) {
        basePrice = _basePrice;
        surgeMultiplier = _surgeMultiplier;
    }
    
    function predictPrice(int pickUpLat, int pickUpLong, int dropOffLat, int dropOffLong, bool isSurge) public view returns (uint) {
        uint distance = calculateDistance(pickUpLat, pickUpLong, dropOffLat, dropOffLong);
        uint price = distance * basePrice;
        if (isSurge) {
            price *= surgeMultiplier;
        }
        return price / PRICE_PRECISION; // Convert back to whole number
    }
    
    function calculateDistance(int pickUpLat, int pickUpLong, int dropOffLat, int dropOffLong) internal pure returns (uint) {
        // Convert latitudes and longitudes to radians
        int lat1Rad = pickUpLat * int(1e10) / 180;
        int long1Rad = pickUpLong * int(1e10) / 180;
        int lat2Rad = dropOffLat * int(1e10) / 180;
        int long2Rad = dropOffLong * int(1e10) / 180;
        
        // Calculate the differences in latitude and longitude
        int deltaLat = lat2Rad - lat1Rad;
        int deltaLong = long2Rad - long1Rad;
        
        // Calculate the Haversine formula
        int a = sin(deltaLat / 2) ** 2 + cos(lat1Rad) * cos(lat2Rad) * sin(deltaLong / 2) ** 2;
        int c = 2 * atan2(sqrt(a), sqrt(1 - a));
        uint distance = uint(c * EARTH_RADIUS);
        
        return distance;
    }
}