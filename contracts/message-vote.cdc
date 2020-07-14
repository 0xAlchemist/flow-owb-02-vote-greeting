// The MessageVote contract creates and stores the MessageAsset resource in
// the contract owner's private storage

pub contract MessageVote {
    
    // The MessageAsset resource can only exist in one place at a time
    //
    // Properties
    // - message: String - the current message
    // - proposals: { String: Int } - a dictionary of messages: voteCounts
    // - mostVotes: Int - records the highest vote count from the last message update to reduce variable assignments during update loop
    // - voters: [Address] - an array of account addresses that have voted for a proposal
    //
    // Methods:
    // - addProposal( message: String, account: Address ) - add and vote for new greeting messages
    // - updateProposal() - update the current message
    // - getMessage() - return the current message

    pub resource MessageAsset {
        pub var message: String
        pub var proposals: {String: Int}
        pub var mostVotes: Int
        pub var voters: [Address]

        // Initialize the empty variables
        init() {
            self.message = "Hello, Flow! Add a proposal to update this message."
            self.proposals = {}
            self.mostVotes = 0
            self.voters = []
        }

        pub fun addProposal(message: String, account: Address) {
            
            // Before running function body...
            pre {
                // ... check if an account has already voted
                // and prevent an account from voting twice
                !self.voters.contains(account):
                    "You've already voted. Silly user... Only one vote per account"
            }
            
            // Get the vote count from the proposed message
            let voteCount = self.proposals[message]

            // If the message has already been added...
            if voteCount != nil {
                log("Increasing vote count...")
                // ... increase the vote count by 1
                self.proposals[message] = voteCount! + 1
            } else {
                log("Adding proposal...")
                // ... otherwise, add the message key to
                // the dictionary with a vote count of 1
                self.proposals[message] = 1
            }

            // Add the account address to the voters array
            self.voters.append(account)
            
            // Run updateMessage() to activate the message 
            // with the most votes
            self.updateMessage()
        }

        pub fun updateMessage() {
            // For each message in the proposals dictionary...
            for key in self.proposals.keys {
                // ... get the message vote count or stop execution
                let numVotes = self.proposals[key]!

                // ... if the message has more votes than the current leader...
                if numVotes > self.mostVotes {
                    // ... update the mostVotes and message variables
                    // to the value and key of the new leader
                    self.mostVotes = numVotes
                    self.message = key
                }
            }
        }

        pub fun getMessage(): String {
            // Returns the current message
            return self.message
        }
    }

    // Initialize the new MessageAsset on deployment
    init() {

        // Creates a new MessageAsset
        let newMessage <- create MessageAsset()

        // Stores the new MessageAsset in contract owner's private storage
        self.account.save(<-newMessage, to: /storage/Message)
        
        log("MessageAsset created and stored")
    }
}
 