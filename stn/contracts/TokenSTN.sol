pragma solidity ^0.4.15;

contract ERC20Interface {
    function totalSupply() constant returns (uint256 totalSupply);
    function balanceOf(address _owner) constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    function approve(address _spender, uint256 _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract TokenSTN is ERC20Interface {
    string public name = "Sentinels";
    string public symbol = "STN";
    uint8 public decimals = 18;
    // inital supply is 1bn 
    uint256 TotalSupply = 1000000000 * 10 ** uint256(decimals);

    address public owner;

    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowances;

    // Events
    // ------------------------------------------------------------------------

    event Burn(address indexed from, uint256 value);

    // Modifiers
    // ------------------------------------------------------------------------

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // Constructor
    // ------------------------------------------------------------------------

    function TokenSTN () public {
        balances[msg.sender] = TotalSupply;
        owner = msg.sender;
    }

    // Non-State Changing Methods
    // ------------------------------------------------------------------------

    function totalSupply() constant returns (uint256 totalSupply) {
        totalSupply = TotalSupply;
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }

    // State Changing Methods
    // ------------------------------------------------------------------------

    function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
        if (_to != 0x0
            && balances[_from] >= _value 
            && _value > 0
            && balances[_to] + _value > balances[_to] )
        {
            uint previousBalances = balances[_from] + balances[_to];
            balances[_from] -= _value;
            balances[_to] += _value;
            Transfer(_from, _to, _value);
            assert(balances[_from] + balances[_to] == previousBalances);
            return true;
        } else { 
            return false;
        }
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        success = _transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (_value <= allowances[_from][msg.sender]) {
            allowances[_from][msg.sender] -= _value;
            success = _transfer(_from, _to, _value);
        } else {
            success = false;
        }
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowances[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        success = true;
    }

    function burn(uint256 _value) public returns (bool success) {
        if (balances[msg.sender] >= _value) {
            balances[msg.sender] -= _value;
            TotalSupply -= _value;
            Burn(msg.sender, _value);
            success = true;
        } else {
            success = false;
        }
    }

    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        if ( balances[_from] >= _value
             && _value <= allowances[_from][msg.sender] )
        { 
                balances[_from] -= _value;
                allowances[_from][msg.sender] -= _value;
                TotalSupply -= _value;
                Burn(_from, _value);
                success = true;
        } else {
            success = false;
        }
    }

    // Admin Functions
    // ------------------------------------------------------------------------

    function changeName(string _newName) onlyOwner() {
        name = _newName;
    }

    function changeSymbol(string _newSymbol) onlyOwner() {
        symbol = _newSymbol;
    }

    function changeOwner(address _newOwner) onlyOwner() {
        owner = _newOwner;
    }

}

