//SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.19;


/*/ ***************** IMPORTS ***************** /*/

// ++++++++++ Constants:
import "./constants/Constants.sol";
import "./constants/Errors.sol";

// +++++++++ Interfaces:


// ++++++++++ Libraries:


// ++++++++++ Abstracts:
import { IClassicModeWSH } from "./abstracts/IClassicModeWSH.sol";
import "./storage/WarshipsStorage.sol";

/*/ ************* END of IMPORTS ************* /*/


contract Warships is WarshipsStorage, IClassicModeWSH {

/*
   ***********************************
                Modifiers
   ***********************************
*/
    modifier classicFindChecker(
        address callerAsParam,
        bytes calldata signature
    ) {
        address sender = msg.sender;

        _onlyEOA(sender);
        _senderMustBeCallerAsParam(sender, callerAsParam);
        _validateSignature(signature);
        _;
    }

    modifier classicGuessChecker(
        address callerAsParam,
        uint256 guess,
        bytes32 playerRoot,
        bytes32 opponentRoot,
        bytes calldata signature
    ) {
        address sender = msg.sender;

        _onlyEOA(sender);
        _senderMustBeCallerAsParam(sender, callerAsParam);
        _matchPairRoots(sender, playerRoot, opponentRoot, VIP[sender]);
        _onlyPlayerTurn(playerRoot);
        _checkDupGuess(guess);
        _validateSignature(signature);
        _;
    }


/*
   ***********************************
            External Functions
   ***********************************
*/
    function findClassicMatch(
        ClassicJoinReq calldata playerData,
        uint256 ticketLeverage
    )
        external override
        classicFindChecker(playerData.pAddr, playerData.signature)
        returns (
            bytes32 opponentRoot /* , uint256 acceptedLeverage */
        )
    {
        bool isVip = VIP[playerData.pAddr];

        _tkLeverageChecker(playerData.pAddr, playerData.tkLeverage, isVip);

        // check has even one ticket CODE...

        if (wpIC[ticketLeverage] == 0) {
            searchForFirstEmptyPATOSRS(playerData.pAddr, isVip);
            wpIC[ticketLeverage] = playerData.pRoot;
        } else {
            opponentRoot = wpIC[ticketLeverage];
            paTosrs[playerData.pAddr][
                searchForFirstEmptyPATOSRS(playerData.pAddr, isVip)
            ] = opponentRoot;

            address opponent = prTpmd[opponentRoot].player;

            paTosrs[opponent][
                searchForFirstEmptyPATOSRS(opponent, VIP[opponent])
            ] = playerData.pRoot;

            delete wpIC[ticketLeverage];

            // prTpmd[playerData.pRoot].canGuessAndHits = true;
        }

        // prTpmd[playerData.pRoot].ticketLeverage = uint8(ticketLeverage);
        prTpmd[playerData.pRoot].player = playerData.pAddr;
    }

    function guessClassicMode(ClassicGuess calldata playerGuess)
        external
        classicGuessChecker(
            playerGuess.pAddr,
            playerGuess.guess,
            playerGuess.pRoot,
            playerGuess.oRoot,
            playerGuess.signature
        )
        returns (uint256 strikes)
    {}


/*
   ***********************************
            Public Functions
   ***********************************
*/
    function searchForFirstEmptyPATOSRS(address player, bool isVip)
        public
        view
        returns (uint256 index)
    {
        uint256 maxMatches = isVip ? MAX_VIP_MATCHES : MAX_MATCHES;
        bool gotIndex;

        for (uint256 i; i < maxMatches;) {
            if (paTosrs[player][i] == 0) {
                index = i;
                gotIndex = true;
            }
        }

        if (!gotIndex) revert();
    }

    function searchForAllEmptyPATOSRS(address player, bool isVip)
        public
        view
        returns (uint256[] memory indexes)
    {
        uint256 totalEmptyIndexes;
        uint256 maxMatches = isVip ? MAX_VIP_MATCHES : MAX_MATCHES;

        for (uint256 i; i < maxMatches;) {
            if (paTosrs[player][i] == 0) totalEmptyIndexes++;
            unchecked {
                i++;
            }
        }

        uint256[] memory emptyIndexes = new uint256[](totalEmptyIndexes);
        uint256 iterator;

        for (uint256 i; i < maxMatches;) {
            if (paTosrs[player][i] == 0) emptyIndexes[iterator];

            if (iterator == totalEmptyIndexes) break;
            unchecked {
                i++;
                iterator++;
            }
        }

        indexes = emptyIndexes;
    }


/*
   ***********************************
            Private Functions
   ***********************************
*/
    function _onlyEOA(address _sender) private view {
        if (_sender != tx.origin) revert();
    }

    function _tkLeverageChecker(
        address _sender,
        uint256 _tkLeverage,
        bool _isVip
    ) private view {
        if (_tkLeverage == 0) revert();

        if (_isVip && _tkLeverage > MAX_VIP_TK_LEVERAGE) revert();
        else if (!_isVip && _tkLeverage > MAX_TK_LEVERAGE) revert();

        if (prTpmd[wpIC[_tkLeverage]].player == _sender) revert();
    }

    function _validateSignature(bytes calldata _signature) private view {}

    function _checkDupGuess(uint256 _guess) private view {}

    function _onlyPlayerTurn(bytes32 _senderRoot) private view {
        // if(!prTpmd[_senderRoot].canGuess) revert ();
    }

    function _matchPairRoots(
        address _sender,
        bytes32 _playerRoot,
        bytes32 _opponentRoot,
        bool _isVip
    ) private view {
        if (prTpmd[_playerRoot].player != _sender) revert();

        bool opponentRootFound;

        uint256 maxMatches = _isVip ? MAX_VIP_MATCHES : MAX_MATCHES;

        for (uint256 i; i < maxMatches;) {
            if (paTosrs[_sender][i] == _opponentRoot) {
                opponentRootFound = true;
                break;
            }

            unchecked {
                i++;
            }
        }

        if (!opponentRootFound) revert();
    }

    function _senderMustBeCallerAsParam(address _sender, address _callerAsParam)
        private
        pure
    {
        if (_callerAsParam != _sender) revert();
    }

    // function _verifyMerkleProof(bytes32[5] proofs) private pure {

    // }
}
