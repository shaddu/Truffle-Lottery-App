pragma solidity 0.4.20;

contract Lottery {

/** -------- VARIABLES -------- **/

// owner of the lottery
    address public owner;

// address of the winner
// assumption only one winner
    address private winningAddress;
    address public winner;

// mapping to save token counts for all address 
    mapping (address => uint) public tokenHolders;

// participant address
    address[] public participants;

// price of a token
    uint public token_price;

// game status idicator
    bool public gameClosed = false;

// Total balance of the smart contract
    uint public contractBalance;

// winning guess hash
    bytes32 private winningHash;

/** -------- MODIFIERS -------- **/
    modifier ownerOnly() {
            require(msg.sender == owner);
            _;
        }

    modifier gameOngoing() {
            require(!gameClosed);
            _;
        }
    
    modifier isGameclosed() {
            require(gameClosed);
            _;
        }

/** -------- CONSTRUCTOR -------- **/

   function Lottery(bytes32 winningGuessHash) public {
      owner = msg.sender;
      token_price = 1.0 ether;
      gameClosed = false;
      winningHash = winningGuessHash;

   }


/** -------- FUNCTIONS -------- **/


// function to buy token in exchange of ethers
   function buyTokens(address user) public payable gameOngoing {

       if (msg.value / token_price < 1 ) throw;
        
        tokenHolders[user] += ~~ (msg.value / token_price ); 
        // send back the fractions value
        user.transfer(msg.value - (~~(msg.value / token_price )) * token_price);
        participants.push(user);
    
   }

// function to makeguess and update the winner address

   function makeGuess(uint guess) public gameOngoing {

       if (tokenHolders[msg.sender] < 1) throw;   
       // need to change to require

        if (winningHash == sha3(guess)) // need to change to keccak256
            winningAddress = msg.sender;

        contractBalance += 1;
        tokenHolders[msg.sender] -= 1;

   }

   function winnerAddress() private isGameclosed returns (address) {
       return winningAddress;
   }

// function is called after game is closed and send 50% total contract value to winner

   function getPrice() public isGameclosed {
       winner = winnerAddress();
       if ( winner == msg.sender && contractBalance != 0) {
            winner.transfer(contractBalance/2);
            owner.transfer(contractBalance/2);
            contractBalance = 0;
       }
   }

   function closeGame() private {
      if (msg.sender == owner) 
        gameClosed = true;
   }
}