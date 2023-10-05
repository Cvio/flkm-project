### Token Contract

**Purpose:** The Token Contract manages basic ERC-20 functionalities and token properties, serving as the foundation for the COWL token in the federated learning knowledge marketplace ecosystem.

**Attributes:**

- `name`: The name of the token (e.g., "COWL").
- `symbol`: The symbol of the token (e.g., "COWL").
- `decimals`: The number of decimal places for token values.
- `totalSupply`: The total supply of COWL tokens.
- `balanceOf`: A mapping that associates addresses with token balances.
- `allowance`: A mapping that associates an owner address with spender addresses and approved token values.
- `owner`: The address that owns the contract.
- `isMinter`: A mapping that identifies addresses with minter roles.
- `isStaker`: A mapping that identifies addresses with staking privileges.

**Modifiers:**

- `onlyOwner`: Restricts access to certain functions to the contract owner.
- `onlyMinter`: Restricts access to certain functions to addresses with the minter role.

**Constructor:**

The constructor initializes the token properties during contract deployment. It sets the name, symbol, decimals, total supply, and initial balances.

**Functions:**

- `transfer`: Allows token holders to transfer COWL tokens to other addresses.
- `transferFrom`: Allows approved addresses to transfer tokens on behalf of the owner.
- `approve`: Allows token holders to approve addresses for spending tokens.
- `increaseAllowance`: Allows token holders to increase the spending allowance for an address.
- `decreaseAllowance`: Allows token holders to decrease the spending allowance for an address.
- `mint`: Creates new COWL tokens and assigns them to a target address. This function is accessible only by addresses with the minter role.
- `burn`: Destroys COWL tokens owned by the sender.
- `addMinter`: Grants the minter role to an address, allowing it to create new tokens.
- `removeMinter`: Revokes the minter role from an address, preventing it from creating new tokens.

**Events:**

- `Transfer`: Emitted when COWL tokens are transferred between addresses.
- `Approval`: Emitted when spending approval is granted or updated.
- `Mint`: Emitted when new COWL tokens are created and assigned to an address.
- `Burn`: Emitted when COWL tokens are destroyed.
- `MinterAdded`: Emitted when an address is granted the minter role.
- `MinterRemoved`: Emitted when the minter role is revoked from an address.
