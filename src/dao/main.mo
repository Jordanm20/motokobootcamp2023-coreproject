import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Int "mo:base/Int";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Prelude "mo:base/Prelude";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Cycles "mo:base/ExperimentalCycles";
import Error "mo:base/Error";


actor {

    public type Proposal = {
        id:   Nat;
        var votesFor: Int;
        var votesAgainst: Int;
        body: Text;
        var alreadyVoted : [Principal];
    };

    public type StaticProposal = {
        id: Nat;
        votesFor: Int;
        votesAgainst: Int;
        body: Text;
        alreadyVoted : [Principal];
    };

    stable var spropo : [(Nat, Proposal)] = [];
    let proposals = HashMap.fromIter<Nat, Proposal>(
        spropo.vals(), 10, Nat.equal, Hash.hash
    );
   
    func array(a : [Principal], p : Principal) : Bool {
        for (e in a.vals()) {
            if (e == p) {return true};
        };
        return false;
    };
    public shared({caller}) func submit_proposal(this_payload : Text) : async {#Ok : StaticProposal; #Err : Text} {
        let nextId = proposals.size() + 1;
        switch (proposals.get(nextId)) {
            case (?id) {
                return #Err("Error");
            };
            case null {
                let nextProposal : Proposal = {
                    id = nextId;
                    var votesFor = 0;
                    var votesAgainst = 0;
                    body = this_payload;
                    var alreadyVoted = [];
                };
                proposals.put(nextId, nextProposal);
                return #Ok({
                    nextProposal with
                    votesFor = nextProposal.votesFor;
                    votesAgainst = nextProposal.votesAgainst;
                    alreadyVoted = [];
                })
            }
        }
    };


    type Subaccount = Blob;
    type Account = { 
        owner : Principal;
        subaccount : ?Subaccount;
    };
    let bootcamp_token : actor { icrc1_balance_of : (Account) -> async Nat } = actor ("db3eq-6iaaa-aaaah-abz6a-cai"); 


    public shared({caller}) func get_tokens() : async Nat {
        let tokens_owned = await bootcamp_token.icrc1_balance_of({ owner = caller; subaccount = null; });
        return tokens_owned/100000000;
    };


    public shared({caller}) func vote(proposal_id : Nat, yes_or_no : Bool) : async {#Ok : (Int, Int); #Err : Text} {
        let proposal = switch (proposals.get(proposal_id)) {
            case null {return #Err("Error: Propuesta no existene");};
            case (?p) {p};
        };

        let tokens_owned = await bootcamp_token.icrc1_balance_of({ owner = caller; subaccount = null; });
        if (not (tokens_owned > 1)) {
            return #Err("Number of Motoko Bootcamp Tokens must be greater than 1 to vote")
        };

        if (array(proposal.alreadyVoted, caller) == true) {
            return #Err("No puede votar 2 veces en una misma propuesta");
        };

        let voting_power = tokens_owned/100000000;

        switch yes_or_no {
            case true { // Vote YES
                proposal.votesFor := proposal.votesFor + voting_power;
                proposal.alreadyVoted := Array.append(proposal.alreadyVoted, [caller]);
                if (proposal.votesFor > 100) { 
                    await update_site(proposal.body);
                    return #Err("La propuesta fue aprovada")  
                };
            };
            case false { 
                proposal.votesAgainst := proposal.votesAgainst + voting_power;
                if (proposal.votesAgainst > 100) { 
                    return #Err("La propuesta fue rechazada")
                }
            };
        };
        Prelude.unreachable()
    };
    
    
    let receiver : actor { receive_message : (Text) -> async Nat } = actor ("x6rkz-tyaaa-aaaak-qbuxq-cai"); 

    public func update_site(message : Text) : async () {
        let size = await receiver.receive_message(message);
    };

    public query func get_proposal(id : Nat) : async ?StaticProposal {
        switch (proposals.get(id)) {
            case null {return null};
            case (?proposal) {
                return ?{proposal with 
                votesFor = proposal.votesFor;
                votesAgainst = proposal.votesAgainst;
                alreadyVoted = [];
                }
            }
        }

    };
    
    public query func get_all_proposals() : async [(Nat, StaticProposal)] {
        let a = Iter.toArray(proposals.entries());
        Array.map<(Nat, Proposal), (Nat, StaticProposal)>(a, func (e) {
            (e.0, {e.1 with 
            votesFor = e.1.votesFor;
            votesAgainst = e.1.votesAgainst;
            alreadyVoted = [];
            });
        });
    };
    system func preupgrade() {
        spropo := Iter.toArray(proposals.entries());
    };
    system func postupgrade() {
        spropo := [];
    };
};