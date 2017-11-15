pragma solidity ^0.4.15;

contract SentinelsICO {

    address public Owner;
    address WithdrawWallet;

    bool contractLive;
    // Smallest sponsorship amount
    uint256 MinimumSponsorship = 10 finney;
    // Amount of ETH available in this ICO
    uint256 TotalMaxSponsorship = 1000 ether;
    uint256 public ICOStart;
    uint256 public ICOClose;

    mapping(address => uint256) public SponsorAmounts;
    mapping(address => address) SponsorAddrIdx;

    // Events
    // ------------------------------------------------------------------------
    event Sponsor(address indexed sponsor, uint256 amount);


    // Modifiers
    // ------------------------------------------------------------------------
    modifier onlyOwner() {
        require(msg.sender == Owner);
        _;
    }
    
    // Constructor
    // ------------------------------------------------------------------------
    function SentinelsICO(address _withdrawWallet) {
        ICOStart = now - 1 days;
        ICOClose = now + 14 days;
        contractLive = true;
        Owner = msg.sender;
        WithdrawWallet = _withdrawWallet;
    }

    // Non-State Changing Methods
    // ------------------------------------------------------------------------
    function icoActive() returns (bool) {
        if ((contractLive == true ) && ( now < ICOClose ) && ( now > ICOStart )) {
            return true;
        }
        return false; 
    }

    // from 0x0 to 0
    function getNextSponsor(address _address) public returns (address) {
        return SponsorAddrIdx[_address];
    }

    function getAmount(address _address) public returns (uint256) {
        return SponsorAmounts[_address];
    }

    // State Changing Methods
    // ------------------------------------------------------------------------
    function sponsor() payable public returns (bool) {
        require ( now < ICOClose );
        require ( now > ICOStart );
        require ( msg.value > MinimumSponsorship );
        require ( contractLive );
        require (( this.balance + msg.value ) <= TotalMaxSponsorship );

        recordSponsor(msg.sender, msg.value);

        return true;
    }

    function recordSponsor(address _addr, uint256 amount) {
        if (SponsorAmounts[_addr] == 0) {
            addSponsorAddr(_addr);
        }
        SponsorAmounts[_addr] += amount;
        Sponsor(_addr, amount);
    }

    function addSponsorAddr(address _addr) {
        SponsorAddrIdx[_addr] = SponsorAddrIdx[0x0];
        SponsorAddrIdx[0x0] = _addr;
    }

    // Admin Functions
    // ------------------------------------------------------------------------
    function closeICO() public onlyOwner() {
        contractLive = false;
    }

    function withdraw() public onlyOwner() {
        WithdrawWallet.transfer(this.balance);
    }

    function changeOwner(address _newOwner) public onlyOwner() {
        Owner = _newOwner;
    }

    function changeWithdrawWallet(address _address) public onlyOwner() {
        WithdrawWallet = _address;
    }
}

