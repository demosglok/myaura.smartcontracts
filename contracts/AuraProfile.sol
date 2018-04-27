pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

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
        LeveledElem[] hardskills;
        LeveledElem[] softskills;
        LeveledElem[] interests;
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
        }

        profile.hardskills.push(LeveledElem(name,level));
        return true;
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
        }
        profile.softskills.push(LeveledElem(name,level));
        return true;
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
        }

        profile.interests.push(LeveledElem(name,level));
        return true;
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
        }
        profile.hardskills.push(LeveledElem(name,level));
        return true;
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
        }
        profile.softskills.push(LeveledElem(name,level));
        return true;
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
        }

        profile.interests.push(LeveledElem(name,level));
        return true;
    }

    function ClaimProfile(uint64 key, address addr) onlyEditor public{
        profiles[addr] = unclaimed_profiles[key];
        delete unclaimed_profiles[key];
    }
    function GetProfile(address addr) public view returns(Profile) {
        return profiles[addr];
    }
    function GetUnclaimedProfile(uint64 key) public view returns(Profile){
        return unclaimed_profiles[key];
    }
    function SaveProfile(string name, string contact) public {
        profiles[msg.sender].name = name;
        profiles[msg.sender].contact = contact;
    }

    function GetBalance(address addr) public view returns (uint){
        return profiles[addr].balance;
    }
    function UpdateBalance(address addr, uint new_ballance) onlyEditor public {
        profiles[addr].balance = new_ballance;
    }
    function GetScore(address addr) public view returns(uint64){
        return profiles[addr].score;
    }
    function UpdateScore(address addr, uint64 new_score) onlyEditor public {
        profiles[addr].score = new_score;
    }

}
