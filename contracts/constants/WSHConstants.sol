//SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.21;


//  Max Regular & VIP player's ticket leverage.
uint256 constant MAX_TK_LEVERAGE = 5;
uint256 constant MAX_VIP_TK_LEVERAGE = 15;

/* 
    Max playable matches,
    for Regular & VIP players at the same time.
*/
uint256 constant MAX_MATCHES = 5;
uint256 constant MAX_VIP_MATCHES = 10;