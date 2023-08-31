
pragma solidity >=0.5.0 <0.9.0;
contract Lottery{
    //DECLARE A DYNAMIC ARRAY THAT WILL SAVE ALL THE ADDRESSES THAT WILL PARTICIPATE IN THE LOTTERY GAME
    address payable[] public players;
    address public manager;// THIS IS THE XTERNAL MANAGER OF THE LOTTERY WHO PICKS AND GIFTS THE WINNER.

    /*WE CREATE A CONSTRUCTOR THAT WILL BE CALLED ONLY ONCE, AND IT WILL ALSO
      ENSURE THAT IT IS TAGGED ONTO THE PERSON INTERACTING WITH THE CONTRACT,IE msg.sender
    */

    constructor(){
        manager = msg.sender;

    }
    //WE HAVE WAYS TO CONVERT AN ADDRESS INTO A PAYABLE ADDRESS.
    //THE NEXT LINE IS A FUNCTION, HOWEVER IT DOESNT USE FUNCTION KEYWORD
    // IT ALLOWS THE CONTRACT TO RECEIVE ETH...
    //NEXT LINE ALSO ALLOWS THE CONTRACT TO CHECK THE BALANCE IN ETH AVAILABLE

    receive external payable{
        require(msg.value == 0.1 ether);
        players.push(payable(msg.sender));
    }
    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }
    /*HERE WE ARE TRYING TO GENERATE A RANDOM UINT.*/
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));

    }
    /* FUNCTION THAT EVENTUALLY PICKS A WINNER*/
    function pickWinner() public {
        require(msg.sender == maager);
        require(players.length >= 3);
        uint r = random();

        address payable winner;
        uint index = r % players.length;
        winner = players[index];
        //COMMAND TO RETURN ALL THE WINNINGS TO THE WINNER
        winner.transfer(getBalance());

        ///AFTER THIS, WE NEED TO FRESHLY INITIALIZE THE LOTTERY.OR RESET.

        players = new address payable[](0);
    }


}