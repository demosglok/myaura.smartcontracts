const Reverter = require('./helpers/reverter');
const Asserts = require('./helpers/asserts');
const Profile = artifacts.require('./AuraProfile.sol');

contract('Profile', function(accounts) {
  const reverter = new Reverter(web3);
  afterEach('revert', reverter.revert);

  const asserts = Asserts(assert);
  const OWNER = accounts[0];
  const EDITOR = accounts[1];
  const OTHER = accounts[2];
  let profile;

  before('setup', () => {
    return Profile.deployed()
    .then(instance => profile = instance)
    .then(reverter.snapshot);
  });

  it('should not allow anybody except owner to SetEditor', ()=>{
	  return Promise.resolve()
	  .then(() => asserts.throws(profile.SetEditor(accounts[3],{from:OTHER})))
	  .then(() => asserts.throws(profile.SetEditor(accounts[3],{from:EDITOR})))
	  .then(() => profile.SetEditor(accounts[3], {from:OWNER}))//not throws?
	  ;
  });

  it('should allow add profile', () => {
	  const name = "profile_name";
	  const contact = "profile_contact";

    return Promise.resolve()
    .then(() => profile.AddProfile(name, contact,{from:OTHER}))
	.then(() => profile.profiles(OTHER))
	.then(res => {
		assert.equal(res[0] , name);
		assert.equal(res[1] , contact)
	});
  });
  it('should allow to add hardskill', ()=>{
	  const skill_name = "skill_name";
	  const skill_level = 2;
	  return Promise.resolve()
	  .then(() => profile.AddHardSkill(skill_name, skill_level, {from:OTHER}))
	  .then(() => profile.profiles(OTHER))
	  .then(prof => {
		  console.log('prof',prof);
		  const hardskills = prof.hardskills;
		  console.log('hardskills',hardskills);
		  const hs = prof[4];
		  console.log('hs',hs);
	  });
  });
  it('should allow to add more then 16 hardskills', ()=>{
	  const skill_name = "skill";
	  const new_skill = "new skill";
	  const skill_level = 2;
	  return Promise.resolve()
	  .then(() => {
		  let requests = [];
		  for(let i = 0; i < 16; i++){
			  requests.push(profile.AddHardSkill(skill_name+i, skill_level,{from:OTHER}));
		  }
		  return Promise.all(requests);
	  })
	  .then(() => profile.AddHardSkill(new_skill, skill_level,{from:OTHER}))
	  .then( res => console.log('add hard skill res',res))
  });
  it('should allow to add softskill', ()=>{
	  return Promise.resolve();
  });
  it('should allow to add interest', ()=>{
	  return Promise.resolve();
  });


  it('should allow only editor to add unclaimed profile', ()=>{
	  return Promise.resolve();
  });

  it('should allow only editor to add unclaimed hardskill', ()=>{
	  return Promise.resolve();
  });
  it('should allow only editor to add unclaimed to add softskill', ()=>{
	  return Promise.resolve();
  });
  it('should allow only editor to add unclaimed to add interest', ()=>{
	  return Promise.resolve();
  });

  it('should allow only editor to assign unclaimed profile', ()=>{
	  return Promise.resolve();
  });
/*
  it('should not allow owner to borrow',() => {
	  const value=10;
	  return Promise.resolve()
	  .then(()=>debts.borrow.call(value, {from:OWNER}))
	  .then(asserts.isFalse);
  });


  it('should not allow extra repay', () => {
    const borrower = accounts[3];
    const value = 1000;
	const repay_value = 1500;
    return Promise.resolve()
    .then(() => debts.borrow(value, {from: borrower}))
    .then(() => asserts.throws(debts.repay(borrower, repay_value, {from: OWNER})))

  });

  it('should return true after borrowing',()=>{
    const borrower = accounts[3];
    const value = 1000;
    return Promise.resolve()
    .then(() => debts.borrow.call(value, {from: borrower}))
	.then(asserts.isTrue)

  });
  */
});
