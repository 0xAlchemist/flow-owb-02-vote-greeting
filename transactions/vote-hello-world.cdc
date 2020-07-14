import MessageVote from 0x01

// Requirements:
// 1. MessageVote contract must be deployed to account 0x01
// 2. CreateCapability transaction must be sent and signed by 0x01

// Call the addProposal() method on the MessageAsset resource that is stored in private storage
// - Get the MessageAsset owner's account object
// - Get the capability for the resource from public storage
// - Borrow a reference to the public capability
// - Call the addProposal() method on the resource using the public reference

transaction {
    prepare(acct: AuthAccount) {
        // Get the public account object using the built-in getAccount() function
        let messageAccount = getAccount(0x01)

        // Get the public capability from the public path of the owner's account
        let messageCapability = messageAccount.getCapability(/public/Message)

        // Borrow a reference for the capability
        let messageReference = messageCapability!.borrow<&MessageVote.MessageAsset>()

        // Call the addProposal() method if the resource exists in storage
        // - (?) optional chaining is used in case the resource is unavailable
        messageReference?.addProposal(message: "Hello world!", account: acct.address)
    }
}