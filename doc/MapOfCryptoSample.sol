// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract MapOfCrypto {
    function makePurchaseRequest(uint256 merchantId, uint256 productId, string memory targetCountry) public payable {
        // * get data for (merchantId, productId) from our API via Chainlink
        // * make sure that the sent amount is at least the amount required for the product including shipping to target country (using Chainlink conversion data)
        // * set a deadline for the merchant to accept the request, otherwise money is refunded
        // * save the purchaseRequest in the contract, so the merchant can accept it
    }

    function acceptPurchaseRequest(uint256 requestId) public {
        // * ensure that the merchant accepting the request is the one for which the request was made
        // * set a deadline until which the request must be fulfilled, otherwise money is refunded (more generous deadline than before accepting)
    }

    function fulfillPurchaseRequest(uint256 requestId, string memory packageTrackingNumber) public {
        // * ensure that it is called by the correct merchant
        // * add the package tracking number to the request data
        // * convert the amount to be sent to the merchant now and store it in the request. this is important because we want to send the correct
        //   amount of ether _at the time of purchase in the store_ and not at the time of shipping
        // * set up chainlink keeper to call completePurchaseRequest when the tracking status is "delivered"
    }

    function completePurchaseRequest(uint256 requestId) public {
        // * get the tracking status via Chainlink API
        // * if the status is "delivered", send the correct amount of ether to the merchant and refund the remaining amount of ether to the customer
        // * if the status is not "delivered", do not do anything
    }
}