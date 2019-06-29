pragma solidity ^0.5.6;


contract EmojiContest {
    
    struct Emoji {
        uint256 id;
        string imageHash;   // for getting image from off-chain storage
        uint256 like;
        address creator;
        string title;
    }
    
    uint256 constant BALLOT_LIMIT = 5;
    
    Emoji[] emojis;     // searching emoji by id
    mapping (address => uint256[]) creatorToEmojis;   // serching emoji by address
    mapping (address => uint256) addressToBallotCount;
    uint256[][] ranking;  // 1st, 2nd, 3rd prized id
    
    
    
    function registerEmoji(uint256 id, string calldata imageHash, string calldata title) external {
        emojis.push(Emoji(id, imageHash, 0, msg.sender, title));
        creatorToEmojis[msg.sender].push(id);
    }
    

    function editEmojiImage(uint256 id, string calldata imageHash) external {
        require(emojis[id].creator == msg.sender);
        emojis[id].imageHash = imageHash;
    }
    
    
    function editEmojiTitle(uint256 id, string calldata title) external {
        require(emojis[id].creator == msg.sender);
        emojis[id].title = title;
    }
    
    
    function giveLike(uint256 id) external {
        require(addressToBallotCount[msg.sender] < 5);
        addressToBallotCount[msg.sender]++;
        emojis[id].like++;

    }
    
}