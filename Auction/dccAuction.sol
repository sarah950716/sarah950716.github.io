pragma solidity ^0.4.24;

contract dccAuction {
    
    struct participant {
        address participantAddress;
        uint tokenBought;    
    }

    struct product {
        bytes32 productName;
        uint highestPrice;
    }

    // struct voter {
    //     address voterAddress;
    //     uint tokenBought;
    // }

    mapping (bytes32 => uint) public highestBidOf;
    mapping (address => uint) public tokensOf;
    mapping (address => mapping(bytes32 => uint)) public bids;

    bytes32[] public productNames;

    // mapping (address => voter) public voters; // ��ǥ�ڵ��� �ּ�
    // mapping (bytes32 => uint) public votesReceived; // �ĺ��� ��ǥ ��
    
    // bytes32[] public candidateNames; // �ĺ��� �迭
    
    uint public totalToken; // ��ū �� ����
    uint public balanceTokens; // ���� ��ū ��
    uint public tokenPrice; // ��ū ���� ex) 0.01 ether
    
    constructor(uint _totalToken, uint _tokenPrice) public // Tx ������ ȣ����
    {
        totalToken = _totalToken;
        balanceTokens = _totalToken;
        tokenPrice = _tokenPrice;
        
        productNames.push("iphone7");
        productNames.push("iphone8");
        productNames.push("iphoneX");
        productNames.push("galaxyS9");
        productNames.push("galaxyNote9");
        productNames.push("LGG7");

        // candidateNames.push("Monday");
        // candidateNames.push("Tuesday");
        // candidateNames.push("Wednesday");
        // candidateNames.push("Thursday");
        // candidateNames.push("Friday");
        // candidateNames.push("Saturday");
        // candidateNames.push("Sunday");
    }
    
    function buy() payable public returns (int) {
        uint tokensToBuy = msg.value / tokenPrice;
        require(tokensToBuy <= balanceTokens);
        tokensOf[msg.sender] += tokensToBuy;
        balanceTokens -= tokensToBuy;
    }
    
    function getHighestBidFor(bytes32 productName) view public returns (uint) {
        require(getProductIndex(productName) != uint(-1));
        return (highestBidOf[productName]);
    }

    function getMyselfBidFor(bytes32 productName) view public returns (uint) {
        require(getProductIndex(productName) != uint(-1));
        return (bids[msg.sender][productName]);
    }
    
    function bid(bytes32 productName, uint tokenCountForBid) public {
        // Participants can't lower their bidding price.
        require(bids[msg.sender][productName] <= tokenCountForBid);

        uint additionalToken = tokenCountForBid - getMyselfBidFor(productName);

        // Check if the participant has enough tokens.
        require(tokensOf[msg.sender] >= additionalToken);

        bids[msg.sender][productName] = tokenCountForBid;
        tokensOf[msg.sender] -= additionalToken;

        uint highestBid = getHighestBidFor(productName);
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
    
    function getTotalToken() view public returns(uint)
    {
        return totalToken;
    }

    function getTokenPrice() view public returns(uint)
    {
        return tokenPrice;
    }
    
    function getTokenBought() view public returns(uint)
    {
        return tokensOf[msg.sender];
    }
}