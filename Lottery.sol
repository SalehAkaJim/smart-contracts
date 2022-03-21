// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract Lottery {
    uint8 public ticketPrice = 1;
    uint256[] numbers;
    uint256 public numberOfEntries;
    uint256 public balance;

    // Participants entered the current lottery
    mapping(uint256 => address) entries;

    // Results of finished lotteries
    struct LotterySt {
        string date;
        uint32 matchOne;
        uint32 matchTwo;
        uint32 matchThree;
        uint32 matchFour;
        uint32 matchFive;
        uint32 matchSix;
        uint32 losers;
    }
    LotterySt[] public finishedLottery;

    // Participants who will receive rewards will be stored here
    mapping(uint256 => address) matchOne;
    mapping(uint256 => address) matchTwo;
    mapping(uint256 => address) matchThree;
    mapping(uint256 => address) matchFour;
    mapping(uint256 => address) matchFive;
    mapping(uint256 => address) matchSix;
    mapping(uint256 => address) losers;

    /* ------------------------------------------------------
    Lottery states: Open, Closed, Finished
    Open: Users are able to enter and buy tickets
    Closed: Lottery is closing and getting ready to pay users
    Finished: It's done
    ------------------------------------------------------ */
    string public lotteryState = "Open";
    modifier isClosed() {
        require(
            keccak256(bytes(lotteryState)) == keccak256("Closed"),
            "The lottery is closed"
        );
        _;
    }

    // Events are here
    event LotteryStateChanged(string lotteryState);
    event NewEntry(address player, uint256 number);

    // Enter lottery
    function submitNumber(uint256 _number) public payable {
        require(msg.value >= ticketPrice, "Minimum entry fee required: $1");
        numbers.push(_number);
        numberOfEntries++;
        emit NewEntry(msg.sender, _number);
    }

    // The winner number will be drawn
    function randomNumber() private view returns (uint256) {
        uint256 randNonce = 0;
        uint256 number = uint256(
            keccak256(abi.encodePacked(now, msg.sender, randNonce))
        ) % 10;
        randNonce++;
        return number;
    }

    // Changing the state of the lottery
    function _changeState(string memory _state) public {
        lotteryState = _state;
        emit LotteryStateChanged(lotteryState);
    }
}
