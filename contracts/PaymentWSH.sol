//SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.21;


import "./constants/PaymentConstants.sol";
import "./storage/PaymentStorage.sol";

contract PaymentWSH is PaymentStorage {

    function chargeVIP(Tariffs selectedPlan) external {
        // the coin/token transfer code...

        uint[2] storage tap = VIPstat[msg.sender];

        uint256 time = tap[0];

        if(time == LIFETIME) revert ();
        else if((time == 0 || time < block.timestamp)) {
            tap[0] = block.timestamp;
        }

        tap[0] += TARIFFS_DURATIONS[uint256(selectedPlan)];
        tap[1] += tariffsRate[selectedPlan];
    }
}