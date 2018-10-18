pragma solidity ^0.4.23;

contract Ownable {
    address internal owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) onlyOwner public returns (bool) {
        require(newOwner != address(0x0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;

        return true;
    }
}

interface ERC20Token {
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
}

contract BitNauticTokenTimeLock is Ownable {
    event TokensLocked(address indexed beneficiary, uint256 releaseTimestamp, uint256 amount);
    event TokensReleased(address indexed beneficiary, uint256 releaseTimestamp, uint256 amount);

    enum TimeLockStatus { WAITING_FUNDS, LOCKED, RELEASED }

    address public beneficiary;
    uint256 public releaseTimestamp;
    uint256 public amount;
    TimeLockStatus public status = TimeLockStatus.WAITING_FUNDS;

    ERC20Token public token;

    constructor(ERC20Token _token, address _beneficiary, uint256 _releaseTimestamp, uint256 _amount) public {
        require(_beneficiary != 0x0);

        token = _token;
        beneficiary = _beneficiary;
        releaseTimestamp = _releaseTimestamp;
        amount = _amount;
    }

    function lockTokens() onlyOwner public returns (bool) {
        require(status == TimeLockStatus.WAITING_FUNDS);
        require(token.transferFrom(msg.sender, address(this), amount));

        status = TimeLockStatus.LOCKED;

        emit TokensLocked(beneficiary, releaseTimestamp, amount);

        return true;
    }

    function releaseTokens() public returns (bool) {
        require(status == TimeLockStatus.LOCKED);
        require(now >= releaseTimestamp);

        require(token.transfer(beneficiary, amount));

        status = TimeLockStatus.RELEASED;

        emit TokensReleased(beneficiary, releaseTimestamp, amount);

        return true;
    }
}
