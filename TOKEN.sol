// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/token/ERC20/ERC20.sol";

contract BlockTuneToken is ERC20{
    address public admin;

    constructor() ERC20('Test Token','TTN'){
        _mint(msg.sender,100000 * 10 ** 18);
        admin = msg.sender;
    }
    
    function mintToken(address to, uint amount) external{
        require( msg.sender == admin, 'only admin');
        _mint(to,amount);
    }

    function burn(uint amount) external{
        _burn(msg.sender, amount);
    }
}