// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttendanceRewards {

    // The teacher's address (the contract deployer)
    address public teacher;

    // The number of attendances required to earn a reward
    uint public attendanceThreshold = 5;

    // The number of tokens awarded for reaching the attendance threshold
    uint public rewardTokens = 10;

    // Mapping to track each student's attendance count
    mapping(address => uint) public attendanceCount;

    // Mapping to track each student's token balance
    mapping(address => uint) public tokenBalance;

    // Mapping to track if a student has claimed their reward
    mapping(address => bool) public hasClaimedReward;

    // Events to log attendance and reward claims
    event AttendanceMarked(address indexed student, uint attendanceCount);
    event RewardClaimed(address indexed student, uint tokens);

    // Constructor to set the contract deployer as the teacher
    constructor() {
        teacher = msg.sender;
    }

    // Modifier to restrict access to only the teacher
    modifier onlyTeacher() {
        require(msg.sender == teacher, "Only the teacher can mark attendance.");
        _;
    }

    // Modifier to restrict access to only students (non-teacher addresses)
    modifier onlyStudent() {
        require(msg.sender != teacher, "Teacher cannot claim rewards.");
        _;
    }

    // Function to mark attendance for a student
    function markAttendance(address student) public onlyTeacher {
        attendanceCount[student]++;
        emit AttendanceMarked(student, attendanceCount[student]);
    }

    // Function for students to claim their reward after meeting the attendance threshold
    function claimReward() payable  public onlyStudent {
        require(attendanceCount[msg.sender] >= attendanceThreshold, "Not enough attendance to claim reward.");
        require(!hasClaimedReward[msg.sender], "Reward already claimed.");

        tokenBalance[msg.sender] += rewardTokens;
        hasClaimedReward[msg.sender] = true;

        emit RewardClaimed(msg.sender, rewardTokens);
    }

    // Function to check the attendance count of a specific student
    function getAttendance(address student) public view returns (uint) {
        return attendanceCount[student];
    }

    // Function to check the token balance of a specific student
    function getTokenBalance(address student) public view returns (uint) {
        return tokenBalance[student];
    }
}
