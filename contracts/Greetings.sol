// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Greeting {
    string private greeting;
    event GreetingUpdated(string newGreeting);

    constructor(string memory _initialGreeting) {
        greeting = _initialGreeting;
        emit GreetingUpdated(_initialGreeting);
    }

    function setGreeting(string memory _newGreeting) public {
        greeting = _newGreeting;
        emit GreetingUpdated(_newGreeting);
    }

    function getGreeting() public view returns (string memory) {
        return greeting;
    }
}