// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

contract LocatorCar is ChainlinkClient, ConfirmedOwner, KeeperCompatibleInterface {
  using Chainlink for Chainlink.Request;

  uint256 public monitors;

  uint256 private constant ORACLE_PAYMENT = (1 * LINK_DIVISIBILITY) / 10;

  constructor() ConfirmedOwner(msg.sender) {
    setPublicChainlinkToken();
  }

  function makePurchaseRequest(
    uint256 merchantId,
    uint256 productId,
    string memory targetCountry
  ) public payable {
    // * get data for (merchantId, productId) from our API via Chainlink   ->  getDataMerchantAPI
    // * make sure that the sent amount is at least the amount required for the product including shipping to target country (using Chainlink conversion data)
    // * set a deadline for the merchant to accept the request, otherwise money is refunded
    // * save the purchaseRequest in the contract, so the merchant can accept it
  }

  function acceptPurchaseRequest(uint256 requestId) public {
    // * ensure that the merchant accepting the request is the one for which the request was made
    // * set a deadline until which the request must be fulfilled, otherwise money is refunded (more generous deadline than before accepting)
    // Set the status of requests = accepted with status delivered = false
  }

  function fulfillPurchaseRequest(uint256 requestId, string memory packageTrackingNumber) public {
    // * ensure that it is called by the correct merchant
    // * add the package tracking number to the request data
    // * convert the amount to be sent to the merchant now and store it in the request. this is important because we want to send the correct
    //   amount of ether _at the time of purchase in the store_ and not at the time of shipping
    // * set up chainlink keeper to call completePurchaseRequest when the tracking status is "delivered"
  }

  function fullfillDeliveredTransactions(bytes32 _requestId, bytes memory bytesResponse) public {
    // fetch the response data from our api
    // decode here the bytesResponse
    // check on chain for our struct of transactions with status deliverd = false and accepted
    // If api returns that delivered = true then save the list of address recipients as needs funding
    // return list()
  }

  // GET API Chainlink

  function getDeliveredTransactions() public {
    // Return here a list of all the transactions that need funding (the recipient addreses that should receive money because status = delivred)
    // Chainlink request to our api
    // Chainlink.Request memory req = buildChainlinkRequest(stringToBytes32(_jobId), address(this), this.fullfillDeliveredTransactions.selector);
    // req.add("get", "https://martelaxe90-cdppi36oeq-ue.a.run.app/trackingAPI");
    // req.add("path", "TODO");
    // sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
  }

  function getDataMerchantAPI(address _oracle, string memory _jobId) public {
    // Chainlink request to datamerchant API
    // Chainlink.Request memory req = buildChainlinkRequest(stringToBytes32(_jobId), address(this), this.fullfillMerchantAPI.selector);
    // req.add("get", "https://martelaxe90-cdppi36oeq-ue.a.run.app/");
    // req.add("path", "TODO");
    // sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
  }

  function fullfillMerchantAPI(bytes32 _requestId, bytes memory bytesResponse) public recordChainlinkFulfillment(_requestId) {
    //  decode the byetesResponse
    // make a struct with the requests on chain using the data from the API
    // fulfillPurchaseRequest()
  }

  /// Keeper functions

  // check when a a delivery has been finished -> this is sent off chain to the keepers register
  function checkUpkeep(
    bytes calldata /* checkData */
  )
    external
    view
    override
    returns (
      bool upkeepNeeded,
      bytes memory /* performData */
    )
  {
    //Check the delivery API -> see the whole list of transactions and check if any has status delivered and hasnt been paid on chain
    // getDeliveredTransactions()
    // if any then upkeepNeeded = true
    // performData = the list of transactions
  }

  // When the keeper register detects taht we need to do a performUpKeep
  function performUpkeep(
    bytes calldata /* performData */
  ) external override {
    // validate here for malicious keepers so we will call getDeliveredTransactions again
    // return list of PurchaseRequests that need funding
    // make the transfers from our smart contract to the recipients according to the response
    // change status delivered= true in our struct
    
  }

  // UTILS

  function getChainlinkToken() public view returns (address) {
    return chainlinkTokenAddress();
  }

  function withdrawLink() public onlyOwner {
    LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
    require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
  }

  function cancelRequest(
    bytes32 _requestId,
    uint256 _payment,
    bytes4 _callbackFunctionId,
    uint256 _expiration
  ) public onlyOwner {
    cancelChainlinkRequest(_requestId, _payment, _callbackFunctionId, _expiration);
  }

  function stringToBytes32(string memory source) private pure returns (bytes32 result) {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0) {
      return 0x0;
    }

    assembly {
      // solhint-disable-line no-inline-assembly
      result := mload(add(source, 32))
    }
  }
}
