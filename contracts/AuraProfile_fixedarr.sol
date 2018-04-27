pragma solidity ^0.4.23;
contract AuraProfile{
    
    address owner;
    address editor;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    modifier onlyEditor() {
        require(msg.sender == owner);
        _;
    }
    uint16 constant MaxSkills = 16;
    struct LeveledElem{
        string name;
        uint16 level;
    }
    struct Profile{ //it should be actually hash to IPFS, SWARM or smth alike
        string name;
        string contact;
        uint balance;
        uint64 score;
        LeveledElem[MaxSkills] hardskills;
        LeveledElem[MaxSkills] softskills;
        LeveledElem[MaxSkills] interests;
    }
    mapping(address => Profile) public profiles;
    mapping(uint64 => Profile) public unclaimed_profiles;
    
    event Error(string msg);
    
    constructor() public{
        owner = msg.sender;
        editor = msg.sender;
    }
    function SetEditor(address new_editor) onlyOwner public {
        editor = new_editor;
    }
    function AddProfile(string name, string contact)public {
        profiles[msg.sender].name = name;
        profiles[msg.sender].contact = contact;
    }
    function AddHardSkill(string name, uint16 level) public returns(bool){
        Profile storage profile = profiles[msg.sender];

        if(profile.hardskills.length >= MaxSkills){
            emit Error("hard skills limit reached");
            return false;
        }

        for(uint16 i = 0; i < profile.hardskills.length; i++){
            if(keccak256(profile.hardskills[i].name) == keccak256(name)){
                profile.hardskills[i].level = level;
                return true;
            }
            else if(bytes(profile.hardskills[i].name).length == 0){
                profile.hardskills[i].name = name;
                profile.hardskills[i].level = level;
                return true;
            }
        }

        return false;
    }
    function AddSoftSkill(string name, uint16 level) public returns(bool){
        Profile storage profile = profiles[msg.sender];

        if(profile.softskills.length >= MaxSkills){
            emit Error("soft skills limit reached");
            return false;
        }

        for(uint16 i = 0; i < profile.softskills.length; i++){
            if(keccak256(profile.softskills[i].name) == keccak256(name)){
                profile.softskills[i].level = level;
                return true;
            }
            else if(bytes(profile.softskills[i].name).length == 0){
                profile.softskills[i].name = name;
                profile.softskills[i].level = level;
                return true;
            }
        }
        return false;
    }
    function AddInterest(string name, uint16 level) public returns(bool){
        Profile storage profile = profiles[msg.sender];

        if(profile.interests.length >= MaxSkills){
            emit Error("interests limit reached");
            return false;
        }

        for(uint16 i = 0; i < profile.interests.length; i++){
            if(keccak256(profile.interests[i].name) == keccak256(name)){
                profile.interests[i].level = level;
                return true;
            }
            else if(bytes(profile.interests[i].name).length == 0){
                profile.interests[i].name = name;
                profile.interests[i].level = level;
                return true;
            }
        }
        
        return false;
    }
    function AddUnclaimedProfile(uint64 key, string name, string contact) onlyEditor public {
        unclaimed_profiles[key].name = name;
        unclaimed_profiles[key].contact = contact;
    }
     function AddHardSkillToUnclaimed(uint64 key, string name, uint16 level) onlyEditor public returns(bool){
        Profile storage profile = unclaimed_profiles[key];

        if(profile.hardskills.length >= MaxSkills){
            emit Error("hard skills limit reached");
            return false;
        }

        for(uint16 i = 0; i < profile.hardskills.length; i++){
            if(keccak256(profile.hardskills[i].name) == keccak256(name)){
                profile.hardskills[i].level = level;
                return true;
            }
            else if(bytes(profile.hardskills[i].name).length == 0){
                profile.hardskills[i].name = name;
                profile.hardskills[i].level = level;
                return true;
            }
        }
        return false;
    }
    function AddSoftSkillToUnclaimed(uint64 key, string name, uint16 level) onlyEditor public returns(bool){
        Profile storage profile = unclaimed_profiles[key];

        if(profile.softskills.length >= MaxSkills){
            emit Error("soft skills limit reached");
            return false;
        }

        for(uint16 i = 0; i < profile.softskills.length; i++){
            if(keccak256(profile.softskills[i].name) == keccak256(name)){
                profile.softskills[i].level = level;
                return true;
            }
            else if(bytes(profile.softskills[i].name).length == 0){
                profile.softskills[i].name = name;
                profile.softskills[i].level = level;
                return true;
            }
        }
        return false;
    }
    function AddInterestToUnclaimed(uint64 key, string name, uint16 level) onlyEditor public returns(bool){
        Profile storage profile = unclaimed_profiles[key];
        
        if(profile.interests.length >= MaxSkills){
            emit Error("interests limit reached");
            return false;
        }
        
        for(uint16 i = 0; i < profile.interests.length; i++){
            if(keccak256(profile.interests[i].name) == keccak256(name)){
                profile.interests[i].level = level;
                return true;
            }
            else if(bytes(profile.interests[i].name).length == 0){
                profile.interests[i].name = name;
                profile.interests[i].level = level;
                return true;
            }
        }
        
        return false;
    }

    function ClaimProfile(uint64 key, address addr) onlyEditor public{
        profiles[addr] = unclaimed_profiles[key];
        delete unclaimed_profiles[key];
    }
}