pragma solidity ^0.4.13;

import "./Owned.sol";
import "./interfaces/PausableI.sol";

contract Pausable is Owned, PausableI {

    bool pausedState;
    
    modifier whenPaused {
        require(pausedState);
        _;
    }
    
    modifier whenNotPaused {
        require(!pausedState);
        _;
    }

    function Pausable(bool _initialState) { 
        pausedState = _initialState;
    }
    
    function setPaused(bool newState) 
        public 
        fromOwner
        returns(bool success) {
            require(newState != pausedState);

            pausedState = newState;

            LogPausedSet(msg.sender, newState);
            return true;
        }

    function isPaused() 
        constant
        returns(bool isIndeed) {
            return pausedState;
        }
}