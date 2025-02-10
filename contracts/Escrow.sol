// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Escrow {
    // Enum to track the state of the escrow
    enum State { AWAITING_PAYMENT, AWAITING_CONFIRMATION, COMPLETE, REFUNDED }

    // Struct to store escrow details
    struct EscrowData {
        address payable buyer; 
        address payable seller;
        uint256 amount; 
        State status; 
    }

    mapping(uint256 => EscrowData) public escrows;

    uint256 public escrowCount;

    event EscrowCreated(uint256 indexed escrowId, address indexed buyer, address indexed seller, uint256 amount);
    event PaymentReleased(uint256 indexed escrowId, address indexed seller, uint256 amount);
    event PaymentRefunded(uint256 indexed escrowId, address indexed buyer, uint256 amount);

    modifier onlyBuyer(uint256 _escrowId) {
        require(msg.sender == escrows[_escrowId].buyer, "Only the buyer can perform this action");
        _;
    }

    modifier onlySeller(uint256 _escrowId) {
        require(msg.sender == escrows[_escrowId].seller, "Only the seller can perform this action");
        _;
    }

    function createEscrow(address payable _seller, uint256 _amount) external payable {
        require(_amount > 0, "Amount must be greater than zero");
        require(msg.value == _amount, "Sent Ether must match the specified amount");

        escrowCount++;
        uint256 escrowId = escrowCount;

        escrows[escrowId] = EscrowData({
            buyer: payable(msg.sender),
            seller: _seller,
            amount: _amount,
            status: State.AWAITING_CONFIRMATION
        });

        emit EscrowCreated(escrowId, msg.sender, _seller, _amount);
    }

    function confirmTransaction(uint256 _escrowId) external onlySeller(_escrowId) {
        EscrowData storage escrow = escrows[_escrowId];
        require(escrow.status == State.AWAITING_CONFIRMATION, "Escrow is not awaiting confirmation");

        escrow.status = State.COMPLETE;
        escrow.seller.transfer(escrow.amount);

        emit PaymentReleased(_escrowId, escrow.seller, escrow.amount);
    }

    function requestRefund(uint256 _escrowId) external onlyBuyer(_escrowId) {
        EscrowData storage escrow = escrows[_escrowId];
        require(escrow.status == State.AWAITING_CONFIRMATION, "Escrow is not awaiting confirmation");

        escrow.status = State.REFUNDED;
        escrow.buyer.transfer(escrow.amount);

        emit PaymentRefunded(_escrowId, escrow.buyer, escrow.amount);
    }
    function getEscrowDetails(uint256 _escrowId)
        external
        view
        returns (
            address buyer,
            address seller,
            uint256 amount,
            State status
        )
    {
        EscrowData memory escrow = escrows[_escrowId];
        return (escrow.buyer, escrow.seller, escrow.amount, escrow.status);
    }
}