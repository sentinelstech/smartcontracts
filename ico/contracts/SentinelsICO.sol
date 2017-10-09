pragma solidity ^0.4.4;

contract SentinelsICO {

    uint MinSatoshis;

    uint public ICOStart;
    uint public ICOClose;

    mapping(address => uint) public sponsorAmounts;
    mapping (address => address) sponsorAddrIdx;
    address[] public sponsors;

    function SentinelsICO() {
        MinSatoshis = 1000;
        ICOStart = now;
        ICOClose = now + 14 days;
    }

    function sponsor() payable returns (bool) {
        require ( now < ICOClose );
        require ( now > ICOStart );
        require ( msg.value > MinSatoshis );

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

    function addSponsorAddr(address _addr) public {
        sponsorAddrIdx[_addr] = sponsorAddrIdx[0x0];
        sponsorAddrIdx[0x0] = _addr;
    }

    function recordSponsor(address _addr, uint amount) {
        if (sponsorAmounts[_addr] == 0) {
            addSponsorAddr(_addr);
        }
        sponsorAmounts[_addr] += amount;
    }
}

