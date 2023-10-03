# Additional Contracts Architecture for EternalLight Ecosystem

## **1. Staking Contract (EternalLightStaking)**

### **Purpose:**

- Allows users to stake tokens to earn rewards and possibly integrate with NFTs to allow staking of NFTs.

### **Functionalities:**

- Stake tokens/NFTs.
- Unstake tokens/NFTs.
- Calculate and distribute rewards.

### **Interaction with KnowledgeExchangeContract:**

- Interacts with `KnowledgeExchangeContract` to check the user's reputation and adjust rewards accordingly.
- Could also update user reputation based on staking and contribution.

## **2. Governance Contract (EternalLightGovernance)**

### **Purpose:**

- Manages proposals and voting within the ecosystem.
- Allows users to propose changes and vote based on their stakes/reputation.

### **Functionalities:**

- Create proposals.
- Vote on proposals.
- Execute approved proposals.

### **Interaction with KnowledgeExchangeContract:**

- Interacts to check the reputation level of users for voting power.
- Could modify user reputation based on participation in governance.

## **3. Marketplace Contract (EternalLightMarketplace)**

### **Purpose:**

- Facilitates the buying, selling, or trading of resources and NFTs within the ecosystem.

### **Functionalities:**

- List items for sale or trade.
- Execute trades and sales.
- Manage fees and royalties.

### **Interaction with KnowledgeExchangeContract:**

- Checks the availability and validity of resources.
- Updates resource demand and user reputation based on transactions.

## **4. Royalty Contract (EternalLightRoyalty)**

### **Purpose:**

- Manages and distributes royalties to creators for the use of their intellectual property.

### **Functionalities:**

- Calculate royalties.
- Distribute royalties to creators.

### **Interaction with KnowledgeExchangeContract:**

- Interacts to identify the creators and users of resources.
- Calculates royalties based on resource demand and transactions in the ecosystem.

## **5. Upgradeability Proxy Contract (EternalLightUpgradeProxy)**

### **Purpose:**

- Facilitates upgrades to contracts without losing the state.

### **Functionalities:**

- Upgrade contracts.
- Maintain state across upgrades.

### **Interaction with KnowledgeExchangeContract:**

- Acts as a delegate to call functionalities from `KnowledgeExchangeContract`.
- Upgrades `KnowledgeExchangeContract` and other contracts as needed.

## **6. Dynamic Attributes and DAO Interaction Contract (EternalLightDynamicDAO)**

### **Purpose:**

- Handles the dynamic attributes and visualization of resources and NFTs.
- Manages interactions with DAOs for influence and rewards.

### **Functionalities:**

- Modify and interact with dynamic attributes of resources and NFTs.
- Calculate and adjust the influence and rewards in DAOs.

### **Interaction with KnowledgeExchangeContract:**

- Synchronizes dynamic attributes and visualizations with resources in `KnowledgeExchangeContract`.
- Interacts for user reputations and resource demands for DAO influence and rewards calculations.

## Architecture Diagram:

```
    +-----------------------------+
    |   KnowledgeExchangeContract |
    +------------+----------------+
                |
                |<-------------------------------------------------------------+
                |                                                              |
    +------------v-------------+     +------------------------+     +-----------v-----------+
    |      NFT Staking         |     |        Governance      |     |       Marketplace     |
    +--------------------------+     +------------+-----------+     +-----------------------+
                                                |
                                        +-------v--------+
                                        |    CowlDAO     |
                                        +-------+--------+
                                                |
                                        +-------v-------------+
                                        | EternalLightRoyalty |
                                        +---------------------+
```

## SQL Interaction Flow:

1. Users interact with `KnowledgeExchangeContract` for basic functionalities like uploading and accessing resources.
2. Depending on user actions, `KnowledgeExchangeContract` interacts with other contracts to execute additional functionalities like staking, governance voting, marketplace transactions, royalty calculations, and dynamic attribute modifications.

## Summary:

In this architecture, each contract has a specific responsibility, keeping the system modular and manageable. Contracts are interconnected but have a clear separation of concerns, ensuring that enhancements and modifications can be made independently without affecting the entire ecosystem.
