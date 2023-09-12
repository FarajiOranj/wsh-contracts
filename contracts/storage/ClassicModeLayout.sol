//SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.21;


abstract contract ClassicModeLayout {

/*
   ***********************************
        Type declarations only
   ***********************************
*/
    //  Player data to start for searching a random game.
    struct ClassicJoinReq {
        uint32 islands;
        uint64 tkLeverage;
        address pAddr;
        bytes32 pRoot;
        bytes signature;
    }

    /*
        The needed data for a player,
        to guess a non duplicated square.
    */
    struct ClassicGuess {
        address pAddr;
        uint256 guess;
        bytes32 pRoot;
        bytes32 oRoot;
        bytes32[5] proofs;
        bytes signature;
    }
}
