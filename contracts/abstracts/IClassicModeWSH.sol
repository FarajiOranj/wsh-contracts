//SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.19;


/*/ ***************** IMPORTS ***************** /*/

// ++++++++++ Abstracts:
import "../storage/ClassicModeLayout.sol";

/*/ ************* END of IMPORTS ************* /*/


abstract contract IClassicModeWSH is ClassicModeLayout {

    function findClassicMatch(
        ClassicJoinReq calldata playerData,
        uint256 ticketLeverage
    )
        external
        virtual
        returns (
            bytes32 opponentRoot /* , uint256 acceptedLeverage */
        )
    {}

    function guessClassicMode(ClassicGuess calldata playerGuess)
        external
        virtual
        returns (uint256 strikes)
    {}
}
