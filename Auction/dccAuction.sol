pragma solidity ^0.4.24;

contract dccAuction {
    // A map which maps the name of product to its highest bid.
    mapping (bytes32 => uint) public highestBidOf;
    // A map which maps the address of participant to his/her tokens bought.
    mapping (address => uint) public tokensOf;
    // A map which maps (address, product name) to the 
    // corresponding participant's bid of the product.
    mapping (address => mapping(bytes32 => uint)) public bids;

    bytes32[] public productNames;

    uint public totalToken; 
    uint public balanceTokens; 
    uint public tokenPrice; 
    
    constructor(uint _totalToken, uint _tokenPrice) public {
        totalToken = _totalToken;
        balanceTokens = _totalToken;
        tokenPrice = _tokenPrice;
        
        productNames.push("iphone7");
        productNames.push("iphone8");
        productNames.push("iphoneX");
        productNames.push("galaxyS9");
        productNames.push("galaxyNote9");
        productNames.push("LGG7");
    }
    
    function buy() payable public returns (int) {
        uint tokensToBuy = msg.value / tokenPrice;
        require(tokensToBuy <= balanceTokens);
        tokensOf[msg.sender] += tokensToBuy;
        balanceTokens -= tokensToBuy;
    }
    
    function getHighestBidFor(bytes32 productName) view public returns (uint) {
        // Check if passed productName exists.
        require(getProductIndex(productName) != uint(-1));
        return (highestBidOf[productName]);
    }

    function getMyselfBidFor(bytes32 productName) view public returns (uint) {
        // Check if passed productName exists.
        require(getProductIndex(productName) != uint(-1));
        return (bids[msg.sender][productName]);
    }
    
    function bid(bytes32 productName, uint tokenCountForBid) public {
        // Check if the participant is trying to lower their bidding price, 
        // which is not allowed.
        require(bids[msg.sender][productName] <= tokenCountForBid);

        // Calculate the amount of addtional tokens needed.
        uint additionalToken = tokenCountForBid - getMyselfBidFor(productName);

        // Check if the participant has enough tokens.
        require(tokensOf[msg.sender] >= additionalToken);

        bids[msg.sender][productName] = tokenCountForBid;
        tokensOf[msg.sender] -= additionalToken;

        uint highestBid = getHighestBidFor(productName);
        // Update the value of highest bid if needed.
        if (highestBid < tokenCountForBid) {
            highestBidOf[productName] = tokenCountForBid;
        }
    }
    
    function getProductIndex(bytes32 productName) view public returns (uint) {
        for (uint i = 0; i < productNames.length; i++) {
            if (productNames[i] == productName) {
                return i;
            }
        }
        return uint(-1);
    }
    
    function getTotalToken() view public returns(uint) {
        return totalToken;
    }

    function getTokenPrice() view public returns(uint) {
        return tokenPrice;
    }
    
    function getTokenBought() view public returns(uint) {
        return tokensOf[msg.sender];
    }
}