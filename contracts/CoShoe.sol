pragma solidity >=0.5.0;

import "./CO.sol";

//Non-fungible token
contract CoShoe is CO {

    struct Shoe {
        address owner;
        string name;
        string image;
        bool sold;
    }

    //need to convert to wei, can use uint64 to store the wei value
    //uint64 price = (1 ether) / 2;

    //var defined as shoesSold in c. but later referred to as soldShoes? Assume first is correct
    uint8 shoesSold = 0;

    Shoe[] public shoes;

    //Mint 100 CoShoe tokens
    constructor(address minter) public {
        for (uint8 i = 0; i < 100; i++) {
            shoes.push(Shoe(msg.sender, "", "", false));
        }
    }


    function buyShoe(string memory name, string memory image) public payable {
        require(shoesSold < uint8(shoes.length), "No more shoes in stock");
        //require(msg.value == price, "Amount does not match price");
        uint numTokens = balanceOf(msg.sender);
        require(numTokens > 0, "You do not have a CoToken");
        transferFrom(msg.sender, minter, 1);
        require(numTokens == balanceOf(msg.sender) + 1, "Token transfer failed");
        shoes[shoesSold].owner = msg.sender;
        shoes[shoesSold].name = name;
        shoes[shoesSold].image = image;
        shoes[shoesSold].sold = true;
        shoesSold++;
    }

     function checkPurchases() public view returns (bool[] memory) {
        bool[] memory purchases = new bool[](shoes.length);
        for (uint8 i = 0; i < uint8(shoes.length); i++) {
            if (shoes[i].owner == msg.sender) {
                purchases[i] = true;
            }
        }
        return purchases;
    }

    function numberShoesSold() external view returns (uint8) {
        return shoesSold;
    }

    function numShoes() external view returns (uint) {
        return shoes.length;
    }

}
