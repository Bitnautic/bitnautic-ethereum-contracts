# BitNautic Crowdsale Smart Contracts

The *BitNauticToken* smart contract is an ERC20-compliant token.
You can watch the deployed token at the Ethereum address: [0xd9964e1306dda055f5284c52048712c35ddb61fd](https://etherscan.io/token/0xd9964e1306dda055f5284c52048712c35ddb61fd)

The *BitNauticWhitelist* holds the KYC contribution caps and the AML whitelist.
The crowdsale contract asks the BitNauticWhitelist contract if an address can contribute everytime someone wants to buy BTNT tokens.

The *BitNauticCrowdsale* contract handles the payments for the crowdsale and keeps track of each address contribution and token credit.
Each time someone sends ETH to the crowdsale, the contract checks if the buyer's address hasn't exceed the contribution cap,
it computes how many BTNT, taking into account the current bonus, the buyer will receive and keeps track of each buyer's token credit.

The funds sent to the crowdsale are stored in a RefundVault contract.
At the end of the ICO, if the goal hasn't been reached, each user can reclaim the funds they've sent.

After AML checks, the tokens will be distributed to each contributor.
