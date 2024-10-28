;; Card Trading Game Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-invalid-card (err u102))
(define-constant err-card-exists (err u103))
(define-constant err-insufficient-payment (err u104))

;; Define the NFT for cards
(define-non-fungible-token card uint)

;; Data Maps
(define-map card-attributes
    uint    ;; card-id
    {
        name: (string-utf8 50),
        attack: uint,
        defense: uint,
        rarity: uint,
        element: (string-utf8 20)
    })

(define-map card-market
    uint    ;; card-id
    {
        price: uint,
        seller: principal
    })

;; Variables
(define-data-var next-card-id uint u1)

;; Admin Functions
(define-public (create-card (name (string-utf8 50)) 
                          (attack uint) 
                          (defense uint) 
                          (rarity uint)
                          (element (string-utf8 20)))
    (let ((card-id (var-get next-card-id)))
        (begin
            (asserts! (is-eq tx-sender contract-owner) err-owner-only)
            (try! (nft-mint? card card-id contract-owner))
            (map-set card-attributes card-id
                {
                    name: name,
                    attack: attack,
                    defense: defense,
                    rarity: rarity,
                    element: element
                })
            (var-set next-card-id (+ card-id u1))
            (ok card-id))))

;; Trading Functions
(define-public (list-card (card-id uint) (price uint))
    (begin
        (asserts! (is-eq (unwrap! (nft-get-owner? card card-id) err-invalid-card) tx-sender) 
                 err-not-token-owner)
        (try! (nft-transfer? card card-id tx-sender (as-contract tx-sender)))
        (map-set card-market card-id {price: price, seller: tx-sender})
        (ok true)))

(define-public (unlist-card (card-id uint))
    (let ((market-listing (unwrap! (map-get? card-market card-id) err-invalid-card)))
        (begin
            (asserts! (is-eq (get seller market-listing) tx-sender) err-not-token-owner)
            (try! (as-contract (nft-transfer? card card-id (as-contract tx-sender) tx-sender)))
            (map-delete card-market card-id)
            (ok true))))

(define-public (buy-card (card-id uint))
    (let ((listing (unwrap! (map-get? card-market card-id) err-invalid-card))
          (price (get price listing))
          (seller (get seller listing)))
        (begin
            (try! (stx-transfer? price tx-sender seller))
            (try! (as-contract (nft-transfer? card card-id (as-contract tx-sender) tx-sender)))
            (map-delete card-market card-id)
            (ok true))))

;; Direct Trading Between Players
(define-public (trade-cards (send-card-id uint) (receive-card-id uint) (counterparty principal))
    (begin
        (asserts! (is-eq (unwrap! (nft-get-owner? card send-card-id) err-invalid-card) tx-sender)
                 err-not-token-owner)
        (asserts! (is-eq (unwrap! (nft-get-owner? card receive-card-id) err-invalid-card) counterparty)
                 err-not-token-owner)
        (try! (nft-transfer? card send-card-id tx-sender counterparty))
        (try! (nft-transfer? card receive-card-id counterparty tx-sender))
        (ok true)))

;; Read-Only Functions
(define-read-only (get-card-details (card-id uint))
    (map-get? card-attributes card-id))

(define-read-only (get-market-listing (card-id uint))
    (map-get? card-market card-id))

(define-read-only (get-card-owner (card-id uint))
    (nft-get-owner? card card-id))