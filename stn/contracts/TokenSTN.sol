pragma solidity ^0.4.15;

contract ERC20Interface {
    function name() constant returns (string name);
    function symbol() constant returns (string symbol);
    function decimals() constant returns (uint8 decimals);
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
    string public Name = "Sentinels";
    string public Symbol = "STN";
    uint8 public Decimals = 18;
    // inital supply is 1bn 
    uint256 TotalSupply = 1000000000 * 10 ** uint256(Decimals);

    address public Owner;

    mapping (address => uint256) public Balances;
    mapping (address => mapping (address => uint256)) public Allowances;

    // Events
    // ------------------------------------------------------------------------

    event Burn(address indexed from, uint256 value);

    // Modifiers
    // ------------------------------------------------------------------------

    modifier onlyOwner() {
        require(msg.sender == Owner);
        _;
    }

    // Constructor
    // ------------------------------------------------------------------------

    function TokenSTN () public {
        Balances[msg.sender] = TotalSupply;
        Owner = msg.sender;
    }

    // Non-State Changing Methods
    // ------------------------------------------------------------------------

    function name() constant public returns (string name) {
        name = Name;
    }

    function symbol() constant public returns (string symbol) {
        symbol = Symbol;
    }

    function decimals() constant public returns (uint8 decimals) {
        decimals = Decimals;
    }

    function totalSupply() constant public returns (uint256 totalSupply) {
        totalSupply = TotalSupply;
    }

    function owner() constant public returns (address owner) {
        owner = Owner;
    }

    function balanceOf(address _owner) constant public returns (uint256 balance) {
        return Balances[_owner];
    }

    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
        return Allowances[_owner][_spender];
    }

    // State Changing Methods
    // ------------------------------------------------------------------------

    function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
        if (_to != 0x0
            && Balances[_from] >= _value 
            && Balances[_to] + _value >= Balances[_to] )
        {
            uint previousBalances = Balances[_from] + Balances[_to];
            Balances[_from] -= _value;
            Balances[_to] += _value;
            Transfer(_from, _to, _value);
            assert(Balances[_from] + Balances[_to] == previousBalances);
            return true;
        } else { 
            return false;
        }
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        success = _transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (_value <= Allowances[_from][msg.sender]) {
            Allowances[_from][msg.sender] -= _value;
            success = _transfer(_from, _to, _value);
        } else {
            success = false;
        }
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        Allowances[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        success = true;
    }

    function burn(uint256 _value) public returns (bool success) {
        if (Balances[msg.sender] >= _value) {
            Balances[msg.sender] -= _value;
            TotalSupply -= _value;
            Burn(msg.sender, _value);
            success = true;
        } else {
            success = false;
        }
    }

    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        if ( Balances[_from] >= _value
             && _value <= Allowances[_from][msg.sender] )
        { 
                Balances[_from] -= _value;
                Allowances[_from][msg.sender] -= _value;
                TotalSupply -= _value;
                Burn(_from, _value);
                success = true;
        } else {
            success = false;
        }
    }

    // Admin Functions
    // ------------------------------------------------------------------------

    function changeName(string _newName) public onlyOwner() {
        Name = _newName;
    }

    function changeSymbol(string _newSymbol) public onlyOwner() {
        Symbol = _newSymbol;
    }

    function changeOwner(address _newOwner) public onlyOwner() {
        Owner = _newOwner;
    }

}

