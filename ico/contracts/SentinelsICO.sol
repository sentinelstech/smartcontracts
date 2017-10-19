pragma solidity ^0.4.4;

contract SentinelsICO {

    address public owner;
    address withdrawWallet;

    bool contractLive;
    uint MinEther;
    uint TotalMaxEther;
    uint public ICOStart;
    uint public ICOClose;

    mapping(address => uint) public sponsorAmounts;
    mapping (address => address) sponsorAddrIdx;
    address[] public sponsors;

    function SentinelsICO(address _withdrawWallet) {
        MinEther = 10;
        TotalMaxEther = 10000;
        ICOStart = now;
        ICOClose = now + 14 days;
        contractLive = true;
        owner = msg.sender;
        withdrawWallet = _withdrawWallet;
    }

    function sponsor() payable returns (bool) {
        require ( now < ICOClose );
        require ( now > ICOStart );
        require ( msg.value > MinEther );
        require ( contractLive );
        require (( ower.balance + msg.value ) < TotalMaxEther )

        recordSponsor(msg.sender, msg.value);

        return true;
    }

    function getSponsors() public returns (address) {
        address currentAddr = sponsorAddrIdx[0x0];
        while (currentAddr != 0) {
            console.log(currentAddr + " -- " + sponsorAmounts[currentAddr]);
            currentAddr = sponsorAddrIdx[currentAddr];
        }
    }

    function addSponsorAddr(address _addr) {
        sponsorAddrIdx[_addr] = sponsorAddrIdx[0x0];
        sponsorAddrIdx[0x0] = _addr;
    }

    function recordSponsor(address _addr, uint amount) {
        if (sponsorAmounts[_addr] == 0) {
            addSponsorAddr(_addr);
        }
        sponsorAmounts[_addr] += amount;
    }

    function closeICO() onlyBy (owner) {
        contractLive = false;
    }

    function withdraw() onlyBy (owner) {
        withdrawWallet.transfer(this.balance);
    }

    function changeOwner(address _newOwner) onlyBy(owner) {
        owner = _newOwner;
    }

    modifier onlyBy(address _account) {
        require(msg.sender == _account);
        _;
    }


}

