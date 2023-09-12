//SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.21;

abstract contract PaymentStorage {

    enum Tariffs {
        oneMonth,
        threeMonths,
        sixMonths,
        oneYear
    }

    uint64 constant ONE_MONTH = 30 days;
    uint64 constant THREE_MONTHS = 90 days;
    uint64 constant SIX_MONTHS = 180 days;
    uint64 constant ONE_YEAR = 365 days;
    
    uint64[4] TARIFFS_DURATIONS = [ONE_MONTH, THREE_MONTHS, SIX_MONTHS, ONE_YEAR];

    uint256 lifeTimePrice;
    mapping (Tariffs => uint256) public tariffsRate;
    /*
        Players VIP status:
            1st index => Has time to start a new game in vip area?
                (ticket leverage 6-15 & 5 more playable games)
                Also registers it in unix time stamp.
            2nd index => Total payments.
    */
    mapping(address player => uint256[2] tap) internal VIPstat;
}