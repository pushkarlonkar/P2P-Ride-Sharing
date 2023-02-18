// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PriToken is ERC20 {
    address public owner;

    uint256 private _taxLiquidityPercentage = 4000;  
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;


    string private _name = "Simple Token";
    string private _symbol = "STK";
    uint8 private _decimals = 18;

    function name() public view virtual override returns(String memory){
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
    
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }
        
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
    

    constructor() public ERC20("Pride Token", "PRI") {
        owner = msg.sender;
        uint256 supply = 1000000000 ether; // 1 billion supply
        _mint(msg.sender, supply);
    }



    /** 
     * Requirements:
     * - only 'owner' can only mint the token .
     */
    
    function mint(address to, uint256 amount) external {
        require(msg.sender == owner, "Minting is allowed only by owner.");
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

}