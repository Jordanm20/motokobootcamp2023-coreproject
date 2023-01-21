import Trie "mo:base/Trie";
import Principal "mo:base/Principal";
import Option "mo:base/Option";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
import Error "mo:base/Error";
import List "mo:base/List";
import Time "mo:base/Time";
import Int16 "mo:base/Int16";
import Nat16 "mo:base/Nat16";
import Text "mo:base/Text";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Buffer "mo:base/Buffer";




 actor {
    //My discord is: iri#1598
    stable var next_proposal_id : Nat = 1;
    
    type Proposal = {
        caller:Principal;
        this_payload:Text;
        votes:{
            si:Nat;
            no:Nat;
        }
    };// TO DEFINE;
    stable var a_proposal:[(Nat,Proposal)]=[];
    var propuestas= HashMap.fromIter<Nat,Proposal>(a_proposal.vals(),1,Nat.equal,Hash.hash);

    public shared({caller}) func submit_proposal(this_payload : Text) : async {#Ok : Proposal; #Err : Text} {
        if(this_payload==""){
            return #Err("Por favor, ingresa una propuesta");
        };
        var proposal_id = next_proposal_id;
        next_proposal_id += 1;
        let votes={
            si = 0;
            no = 0;
        };
        let nueva_prop={caller ; this_payload; votes};
        propuestas.put(proposal_id,nueva_prop);
        return #Ok nueva_prop;
    };
    public shared({caller}) func vote(proposal_id : Int, yes_or_no : Bool) : async {#Ok : {si: Nat; no: Nat}; #Err : Text} {
        var vain16:Int16=0;
        var vana16:Nat16=0;
        var vana:Nat=0;
        vain16:=Int16.fromInt(proposal_id);
        vana16:=Int16.toNat16(vain16);
        vana:=Nat16.toNat(vana16);
        var proid=propuestas.get(vana);
        switch(propuestas.get(vana)){
            case(null){
                return #Err ("Id invalido, propuesta no encontrada, pruebe con otro Id");
            };
            case(?proid){
                var totalSi=proid.votes.si;
                var totalNo=proid.votes.no;
                if(yes_or_no){
                    totalSi+=1;
                }else{
                    totalNo+=1;
                };
                let actualizador:Proposal={
                    caller=proid.caller;
                    this_payload = proid.this_payload;
                    votes = {
                            si = totalSi;
                            no = totalNo;
                        }
                };
                propuestas.put(vana,actualizador);
                 return #Ok (actualizador.votes);


            };

        };
          };
    public query func get_proposal(id : Int) : async ?Proposal {
        var vain16:Int16=0;
        var vana16:Nat16=0;
        var vana:Nat=0;
        vain16:=Int16.fromInt(id);
        vana16:=Int16.toNat16(vain16);
        vana:=Nat16.toNat(vana16);
        propuestas.get(vana);
    };
    
    public query func get_all_proposals() : async [(Int, Proposal)] {
        var prop = Buffer.Buffer<(Int, Proposal)>(0);
        for (i in propuestas.entries()){
            prop.add(i);
        };
        return Buffer.toArray(prop);
    };
}
