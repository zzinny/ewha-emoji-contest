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
        updateRanking(id);
    }


    function updateRanking(uint256 id) internal {
        if(emojis[id].like >= emojis[ranking[0][0]].like) { // 1st
            if(emojis[id].like == emojis[ranking[0][0]].like) {
                ranking[0].push(id);
            }
            else {
                delete ranking[0];
                ranking[0].push(id);
            }
        }
        else if(emojis[id].like >= emojis[ranking[1][0]].like) {    // 2nd
            if(emojis[id].like == emojis[ranking[1][0]].like) {
                ranking[1].push(id);
            }
            else {
                delete ranking[1];
                ranking[1].push(id);
            }
        }
        else if(emojis[id].like >= emojis[ranking[2][0]].like) {    // 3rd
            if(emojis[id].like == emojis[ranking[2][0]].like) {
                ranking[2].push(id);
            }
            else {
                delete ranking[2];
                ranking[2].push(id);
            }
        }
    }
}