pragma solidity ^0.4.4;

contract SentinelsICO {

    uint MinSatoshis;

    uint public ICOStart;
    uint public ICOClose;

    function SentinelsICO() {
        MinSatoshis = 1000;
        ICOStart = now;
        ICOClose = now + 14 days;
    }

    function addSponsor(string name, uint amount) returns(bool) {
        if (checkConditions(amount)) {
            recordSponsor(name, amount);
            return true;
        }
        return false;
    }

    function checkConditions(uint amount) returns(bool) {
        bool meetsConditions = true;

        if ((now > ICOClose) || (now < ICOStart)) {
            meetsConditions = false;
        }

        if (amount < MinSatoshis) {
            meetsConditions = false;
        }

        return meetsConditions;
    }

    function recordSponsor(string name, uint amount) {
        // record in ledger
    }
}
