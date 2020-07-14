import MessageVote from 0x01

// Requirements:
// 1. MessageVote contract must be deployed to account 0x01

// This transaction:
// - creates a new capability for the MessageAsset
//   resource in private storage
// - adds the capability to the account's public storage area.
//
// Other accounts and scripts can use this capability
// to create a reference to the private object to be able to
// access its fields and call its methods.

transaction {
    prepare(acct: AuthAccount) {
        // Create a public capability by linking the capability to a 'target' object in private storage
        // - The capability is created regardless of whether the target exists
        // - The capability is stored at /public/Message and it is also returned from the function
        let capability = acct.link<&MessageVote.MessageAsset>(/public/Message, target: /storage/Message)

        // Use the capability's borrow method to create a new reference to the
        // object that the capability links to
        let messageReference = capability!.borrow<&MessageVote.MessageAsset>()

        log("Public capability created successfully")
    }
}
