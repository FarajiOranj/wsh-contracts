//SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.19;


abstract contract WarshipsStorage {

/*
   ***********************************
            Type declarations
   ***********************************
*/
    type Islands is uint32;

    //  Player match data in the classic mode
    struct PMDIC {

        /*
            First nibble:
                Max strikes are 15, and for 16 it will emit an event,
                and will be the end of game and will reset everything.
            Last nibble:
                Total hits which if reaches to 15 (0x0f),
                next hit will be the end of game and will reset everything.
        */
        uint8 strikesAndHits;

        //  Max misses are 80 (0x50).
        uint8 misses;

        /*
            First nibble:
                Ticket leverage (1-15).
            Last nibble:
                0 => Can't guess.
                1 => Can guess.
        */
        uint8 tklAndCanGuess;

        //! Those 4 nonplayable squares.
        Islands islands;


        uint40 lastUpdate;

        //  Player address.
        address player;

        //  Guessed square number reaches an index in this array.
        bool[100] guessedSquares;
    }


/*
   ***********************************
             State variables
   ***********************************
*/
    /* 
        Waiting player root in classic mode.
        Length = 15 => We have 15 levels of ticket leverages.
    */
    bytes32[15] internal wpIC;

    // waiting player data in one hand mode.
    // playerInGameData[15] internal wpIOHM;

    // VIP Registrar.
    mapping(address player => bool isVIP) public VIP;

    // Merkle root of a player to the data during his/her game.
    mapping (bytes32 => PMDIC) internal prTpmd;

    // The address of a player to his/her opponents' Merkle roots.
    mapping (address => bytes32[10]) internal paTosrs;


/*
   ***********************************
                 Events
   ***********************************
*/

}