// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./TOKENX.sol";
import "./Driver.sol";
import "./Customer.sol";

contract Ride is Ownable, Driver , Customer{

    uint256 rideCount;
    uint256 auctionCount;

    enum RIDE_STATUS { POSTED , CONFIRMED , CANCELLED , COMPLETED }
        
    TOKENX tradeToken;

    struct USER{
        uint _citId;
        string _name;
        string _email;
        string _password;
        uint _phone;
        address _accAddress;
        // should you store the address or not that is the quest
    }
    

    constructor(address _token) {
        tradeToken = TOKENX(payable(_token));
        rideCount = 0;
        auctionCount = 0;
    }


    struct RIDE_DETAILS {
        string pickup;
        string destination;
        uint256 distance;
        uint256 price;
    }

    struct RIDE {
        uint id;
        address driver ;
        address customer ;
        RIDE_STATUS status;
        RIDE_DETAILS ride; 
        uint256 timestamp;
    }

    struct AUCTION{
        uint id;
        uint latestHighestBid;
        address currentBidder;
        address driver;
        bool isAuctionGoingOn;
        RIDE_DETAILS ride; 
        uint256 timeOfPosting;
        uint256 secondsUntilAuctionEnds;
    }

    mapping(uint256 => RIDE) private Rides;
    mapping(uint256 => AUCTION) private Auctions;
    mapping(uint =>USER) private loginData;
    uint userCount = 0;
    ///@dev checks if the ride is present or not
    modifier checkRide(uint256 _rideId) {
        require(Rides[_rideId].id>0," No Such Ride Exists ! ");
        _;
    }


    function registerCitizen(string memory name,string memory email ,string memory password ,uint phone ) public {
        
        userCount++;
        loginData[userCount]._name = name;
        loginData[userCount]._email = email;
        loginData[userCount]._password = password;
        loginData[userCount]._phone = phone ;
        loginData[userCount]._accAddress = msg.sender;
        // should you store the address of the curr user 
        // create a mapping for address to password
        loginData[userCount]._citId = userCount;
        //increment the citizencount then the value 

    }

    function viewCitizen(uint cid) public view returns(string memory,string memory,uint,address){
        return(loginData[cid]._name,loginData[cid]._email,loginData[cid]._phone,loginData[cid]._accAddress);
    }
    function LoginCitizen(string memory email,string memory password) public view returns(uint){
        // start with checking if email exists in logindata 
        // check for authentication 
        uint i ;
        for( i = 1;i<=userCount;i++){
            if((keccak256(bytes(loginData[i]._email)) == keccak256(bytes(email))) 
            && (keccak256(bytes(loginData[i]._password)) == keccak256(bytes(password)))){
                
                return loginData[i]._citId;
            }     
        }
        
        return 0;
    }



    function postRide(RIDE_DETAILS memory _rideDetails)
        public
        returns (uint256)
    {
        require(drivers[msg.sender].id>0 ,"No registered driver Found !!");


        rideCount++;

        RIDE memory cur_ride;
        
        cur_ride.id = rideCount;
        cur_ride.driver = msg.sender;
        cur_ride.status = RIDE_STATUS.POSTED;
        cur_ride.ride =_rideDetails;
        cur_ride.timestamp = block.timestamp;

        Rides[rideCount] = cur_ride;

        return rideCount;
    }

    function bookRide(uint256 _rideId) public checkRide(_rideId){
        // this needs to be a customer to get the details 
        require(customers[msg.sender].id>0 ,"No registered Customer Found !!");
        require(Rides[_rideId].status==RIDE_STATUS.POSTED," Ride Already Booked !");

        Rides[_rideId].customer = msg.sender;
        Rides[_rideId].status = RIDE_STATUS.CONFIRMED;
        Rides[_rideId].timestamp = block.timestamp;
        // return _rideId;
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
            allRides[count] = Rides[rideId];
            count++;
        }

        return allRides;
    }

    function fetchRide(uint256 _rideId) public view checkRide(_rideId) returns (RIDE memory) {
        return Rides[_rideId];
    }

    function cancelRide(uint _rideId) public checkRide(_rideId){
        
        require(Rides[_rideId].status == RIDE_STATUS.CONFIRMED," Ride Not Booked yet or Ride Completed !");
        require((Rides[_rideId].customer == msg.sender || Rides[_rideId].driver == msg.sender), "Ride can be cancelled by the ride customer or driver only !! ");

        Rides[_rideId].status = RIDE_STATUS.CANCELLED;
        Rides[_rideId].timestamp = block.timestamp;

    }

    function completeRide(uint256 _rideId) public {

        require(Rides[_rideId].status == RIDE_STATUS.CONFIRMED," Ride Not Booked yet or Ride Completed !");
        require((Rides[_rideId].customer == msg.sender || Rides[_rideId].driver == msg.sender), "Ride can be cancelled by the ride customer or driver only !! ");

        Rides[_rideId].status = RIDE_STATUS.COMPLETED;
        Rides[_rideId].timestamp = block.timestamp;
        
    }

    function getRideCount() public view returns(uint256) {
        return rideCount;
    }


    function addToAuction(uint256 _secondsUntilAuctionEnds , RIDE_DETAILS memory _details)
        public
        returns (uint256)
    {
        auctionCount++;
        AUCTION memory curAuc;
        curAuc.id = auctionCount;
        curAuc.latestHighestBid = 0;
        curAuc.currentBidder = address(0);
        curAuc.driver = msg.sender;
        curAuc.isAuctionGoingOn = true;
        curAuc.ride = _details;
        curAuc.timeOfPosting = block.timestamp;
        curAuc.secondsUntilAuctionEnds = _secondsUntilAuctionEnds;

        Auctions[auctionCount] = curAuc;

        return auctionCount;
    }

    function getBalanceOfAddress() public view returns(uint256){
        return tradeToken.balanceOf(msg.sender);
    }

    function transferThisFrom(uint256 bidamt) public payable{
        tradeToken.transferFrom(msg.sender,address(this),bidamt);
    }

    function bid(uint256  _auctionId, uint256 bidamt) public payable{

        checkValidity(_auctionId);

        AUCTION storage act = Auctions[_auctionId];

        require(act.isAuctionGoingOn == true, "Auction has already finished!");
        require(msg.sender != act.driver, "Drivers cannot bid in their own auction!");
        require(bidamt < tradeToken.balanceOf(msg.sender), "Not enough balance to bid!");
        require(bidamt > act.latestHighestBid, "Bid higher than the previous highest bidder!");


        // get the previous bidder 
        address currentBidder = act.currentBidder;
        uint256 prevBidPrice = act.latestHighestBid;
        act.latestHighestBid = 0;

        //  get the tokens from the current highest bidder and keep it with the contract
        tradeToken.transferFrom(msg.sender,address(this),bidamt);

        // transfer the amount back from the contract to the previous bidder 
        if(currentBidder != address(0)){
            tradeToken.transfer(currentBidder, prevBidPrice);
        }
        act.latestHighestBid = bidamt;
        act.currentBidder = msg.sender;

    }

    function checkValidity (uint256 _auctionId) private {
        if((Auctions[_auctionId].isAuctionGoingOn == true) && (Auctions[auctionCount].timeOfPosting + Auctions[auctionCount].secondsUntilAuctionEnds < block.timestamp)){
            Auctions[_auctionId].isAuctionGoingOn = false;
        }
    }
    // we need to book the cancel the auction or complete it 

    function getAllAuctions(uint256[] memory rideIds)
        public
        view
        returns (AUCTION[] memory)
    {
        AUCTION[] memory allAuctions;
        uint256 count = 0;

        for (uint256 i = 0; i < rideIds.length; i++) {
            uint256 rideId = rideIds[i];
            allAuctions[count] = Auctions[rideId];
            count++;
        }

        return allAuctions;
    }

    function fetchAuction(uint256 _auctionId) public view returns (AUCTION memory) {
        return Auctions[_auctionId];
    }

}

