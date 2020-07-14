import MessageVote from 0x01

// Requirements:
// 1. MessageVote contract must be deployed to account 0x01
// 2. CreateCapability transaction must be sent and signed by 0x01

// Scripts are read-only

// This script:
// - Get the MessageAsset owner's account object
// - Get the capability for the resource from public storage
// - Borrow a reference to the public capability
// - Call the getMessage() method on the resource using the public reference

pub fun main() {
    // Get the public account object using the built-in getAccount() function
    let messageAccount = getAccount(0x01)

    // Get the public capability from the public path of the owner's account
    let messageCapability = messageAccount.getCapability(/public/Message)

    // Borrow a refernce for the capability
    let messageReference = messageCapability!.borrow<&MessageVote.MessageAsset>()

    // The log() built-in function logs its argument to stdout
    //
    // Call the getMessage() method on the MessageAsset resource
    // referenced in the published area of the account
    // - optional chaining (?) is used as the value we're
    //   accessing is optional
    log(messageReference?.getMessage())
}