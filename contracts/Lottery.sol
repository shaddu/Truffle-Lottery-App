pragma solidity 0.4.20;

contract Lottery {
    // owner of the lottery
   address public owner;

   function Lottery() public {
      owner = msg.sender;
   }

   function makeGuess(uint number) public {

   }
    
   function winnerAddress() private {

   }

   function getPrice() private {

   }

   function closeGame() private {
      if(msg.sender == owner) selfdestruct(owner);
   }
}