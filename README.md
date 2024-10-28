# StackedDeck - Card Trading Game Smart Contract

StackedDeck is a blockchain-based card trading game implemented in Clarity, where players can create, trade, and exchange unique NFT cards with custom attributes. Each card is stored as an NFT, giving players verified ownership on the Stacks blockchain. StackedDeck’s customizable attributes allow players to assemble unique collections and trade with other users.

## Features

- **Card Creation**: Admins can mint new cards with unique attributes such as `name`, `attack`, `defense`, `rarity`, and `element`.
- **NFT Marketplace**: Players can list, buy, and sell cards directly on the marketplace, setting STX prices for transactions.
- **Direct Player-to-Player Trading**: Players can propose and complete direct trades of cards with each other.
- **Ownership Verification**: Each card is an NFT, ensuring provable ownership on the Stacks blockchain.

## Contract Functions

### Admin Functions
- **`create-card(name, attack, defense, rarity, element)`**: Allows the contract owner to mint a new card with specified attributes.

### Trading Functions
- **`list-card(card-id, price)`**: Lists a card for sale on the marketplace at a specified price.
- **`unlist-card(card-id)`**: Removes a card from the marketplace and returns it to the owner’s custody.
- **`buy-card(card-id)`**: Purchases a listed card by transferring STX to the seller.
- **`trade-cards(send-card-id, receive-card-id, counterparty)`**: Trades cards directly between two players.

### Read-Only Functions
- **`get-card-details(card-id)`**: Retrieves a card’s attributes (name, attack, defense, rarity, element).
- **`get-market-listing(card-id)`**: Fetches details of a card listed on the marketplace.
- **`get-card-owner(card-id)`**: Returns the current owner of a specified card.

## Data Structures

- **card-attributes**: Stores each card’s unique attributes.
- **card-market**: Manages cards listed on the marketplace, including prices and sellers.

## Error Codes

- `err-owner-only (u100)`: Restricted to the contract owner.
- `err-not-token-owner (u101)`: Only the card’s owner can perform this action.
- `err-invalid-card (u102)`: Invalid card.
- `err-card-exists (u103)`: The card already exists.
- `err-insufficient-payment (u104)`: Payment is insufficient to buy the card.

## Setup and Deployment

1. Clone the repository and set up a Clarity development environment.
2. Deploy the contract to a Stacks blockchain network.
3. The contract owner gains exclusive rights to create new cards.
4. Interact with StackedDeck through a Clarity-compatible wallet or dev tools.

## Usage

1. **Minting Cards**: The owner can mint new cards with chosen attributes.
2. **Listing and Buying**: Players list cards on the marketplace for other players to buy.
3. **Direct Trades**: Players can initiate direct trades of cards.

## Future Enhancements

- **Battle Mechanics**: Introducing a battling system to engage cards in gameplay.
- **Card Abilities**: Implementing unique abilities based on rarity and element.
  
## License

This project is licensed under the MIT License.