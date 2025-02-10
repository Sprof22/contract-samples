// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract DailyAttendance {
    // Structure to store user attendance details
    struct User {
        uint256 totalDaysAttended; 
        bool attendedToday; 
    }

    mapping(address => User) public users;
    address[] public userAddresses;
    event AttendanceMarked(address indexed user);
    event DataCleared();

    function markAttendance() external {
        require(!users[msg.sender].attendedToday, "You have already attended today");

        users[msg.sender].totalDaysAttended++;
        users[msg.sender].attendedToday = true;

        if (users[msg.sender].totalDaysAttended == 1) {
            userAddresses.push(msg.sender);
        }

        emit AttendanceMarked(msg.sender);
    }

    function resetDailyAttendance() external {
        for (uint256 i = 0; i < userAddresses.length; i++) {
            users[userAddresses[i]].attendedToday = false;
        }
    }

    function getRanking() external view returns (address[] memory, uint256[] memory) {
        uint256 length = userAddresses.length;
        address[] memory rankedUsers = new address[](length);
        uint256[] memory attendanceCounts = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            rankedUsers[i] = userAddresses[i];
            attendanceCounts[i] = users[userAddresses[i]].totalDaysAttended;
        }

        for (uint256 i = 0; i < length - 1; i++) {
            for (uint256 j = 0; j < length - i - 1; j++) {
                if (attendanceCounts[j] < attendanceCounts[j + 1]) {
                    // Swap attendance counts
                    uint256 tempCount = attendanceCounts[j];
                    attendanceCounts[j] = attendanceCounts[j + 1];
                    attendanceCounts[j + 1] = tempCount;

                    // Swap user addresses
                    address tempUser = rankedUsers[j];
                    rankedUsers[j] = rankedUsers[j + 1];
                    rankedUsers[j + 1] = tempUser;
                }
            }
        }

        return (rankedUsers, attendanceCounts);
    }

    function clearData() external {
        for (uint256 i = 0; i < userAddresses.length; i++) {
            delete users[userAddresses[i]];
        }

        delete userAddresses;
        emit DataCleared();
    }
}