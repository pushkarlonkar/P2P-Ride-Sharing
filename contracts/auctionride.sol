// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Vehicle.sol";
import "./TOKENX.sol";

contract AuctionRide is Ownable, Vehicle, BerriesERC20(50000) {

    uint256 rideCount=0;

    enum appUser {
        Driver,
        Customer,
        NONE
    }

    // Ride data type
    struct USERS {
        address customer;
        address driver;
    }

    struct STATUS {
        bool isCancelled;
        bool isComplete;
        bool isConfirmed;
        bool isAuctionGoingOn;
        appUser wasCancelledBy;
    }

    struct RIDE_DETAILS {
        string pickup;
        string destination;
        uint256 distance;
        uint256 price;
    }

    struct RIDE {
        uint id;
        uint latestHighestBid;
        USERS users;
        STATUS status;
        RIDE_DETAILS ride; 
        VEHICLE_INFO vehicle;
        uint256 timeOfPosting;
        uint256 secondsUntilAuctionEnds;
    }

    mapping(uint256 => RIDE) private _rides;

    //auction methods
    function startAuction(uint256 rideCount, uint256 _seconds) public {
        require(msg.sender == _rides[rideCount].users.driver, "Only Drivers can start the auction!");
        require(_rides[rideCount].status.isAuctionGoingOn != true, "Auction has already started before!");
        _rides[rideCount].status.isAuctionGoingOn = true;
        _rides[rideCount].timeOfPosting = block.timestamp;
        _rides[rideCount].secondsUntilAuctionEnds = _seconds;
    }

    function bid(uint256  rideCount, uint256 bidamt) public {
        checkValidity(rideCount);
        require(_rides[rideCount].status.isAuctionGoingOn == true, "Auction has already finished!");
        require(msg.sender != _rides[rideCount].users.driver, "Drivers cannot bid in their own auction!");
        require(bidamt < balanceOf(msg.sender), "Not enough balance to bid!");
        require(bidamt > _rides[rideCount].latestHighestBid, "Bid higher than the previous highest bidder!");
        _rides[rideCount].latestHighestBid = bidamt;
        _rides[rideCount].users.customer = msg.sender;
    }

    function checkValidity (uint256 rideCount) private {
        if((_rides[rideCount].status.isAuctionGoingOn == true) && (_rides[rideCount].timeOfPosting + _rides[rideCount].secondsUntilAuctionEnds < block.timestamp)){
            _rides[rideCount].status.isAuctionGoingOn = false;
        }
    }
    function publishRide(uint256 _secondsUntilAuctionEnds)
        public
    {
        rideCount++;
        _rides[rideCount].id = rideCount;
        _rides[rideCount].latestHighestBid=0;
        _rides[rideCount].users.driver = msg.sender;
        _rides[rideCount].status.isAuctionGoingOn = true;
        // _rides[rideCount].ride = _details;
        // _rides[rideCount].vehicle = _vehicle;
        _rides[rideCount].timeOfPosting = block.timestamp;
        _rides[rideCount].secondsUntilAuctionEnds = _secondsUntilAuctionEnds;
    }

    function getAllRides(uint256[] memory rideIds)
        public
        view
        returns (RIDE[] memory)
    {
        RIDE[] memory allRides;
        uint256 count = 0;

        for (uint256 i = 0; i < rideIds.length; i++) {
            uint256 rideId = rideIds[i];
            allRides[count] = _rides[rideId];
            count++;
        }

        return allRides;
    }

    function getRide(uint256 _rideId) public view returns (RIDE memory) {
        return _rides[_rideId];
    }

}