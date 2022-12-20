// SPDX-License-Identifier: CC-BY-1.0

pragma solidity >=0.7.0 <0.9.0;

contract Bet{
    address private manager;
    address[] private players;

    constructor(){
        manager = msg.sender;
    }

    modifier restricted(){
        require(msg.sender == manager);
        _;
    }

    function join() public payable{
        require(msg.value >= 1 ether);

        players.push(msg.sender);
    }

    function pickWinner() public restricted{
        uint index = randomNumber() % players.length;
        address payable player = payable(players[index]);

        player.transfer(address(this).balance);
        clearPlayers();
    }

    function getPlayers() public view returns(address[] memory){
        return players;
    }

    function getManager() public view returns(address){
        return manager;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function clearPlayers() private{
        players = new address[](0);
    }

    function randomNumber() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
}
