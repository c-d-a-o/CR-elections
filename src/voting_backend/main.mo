import RBTree "mo:base/RBTree";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import Char "mo:base/Char";
import Nat32 "mo:base/Nat32";
import Option "mo:base/Option";
import Buffer "mo:base/Buffer";



actor {
  let psk : Text = "theorywillonlytakeyousofar";

  var votedList = Buffer.Buffer<Text>(120);

  var question : Text = "Who will sit on the throne?";
  var votes : RBTree.RBTree<Text, Nat> = RBTree.RBTree(Text.compare);

  func textToNat(t : Text) : Nat {
    var n : Nat = 0;
    for (c in t.chars()) {
      if (Char.isDigit(c)) {
        let charAsNat : Nat = Nat32.toNat(Char.toNat32(c) - 48);
        n := n * 10 + charAsNat;
      }
    };
    return n;
  };

  func personExistsVoters(e : Text) : Bool {
    for(p in votedList.vals()) {
      if (p == e) return true;
    };
    return false;
  };

  public query func getQuestion() : async Text {
    question;
  };

  // public func vote(voterMail : Text, candidateMail : Text) : async Text {
  //     if (not personExistsElectionPool(voterMail)) {return "Person not in election pool";}
  //     else if (personExistsVoters(voterMail)) {return "Person has already voted";}
  //     else if (personExistsCandidates(voterMail)) {return "The person is an existing candidate";}
  //     else {
  //       for(c in candidates.vals()) {
  //         if (c.email == candidateMail) {
  //           c.votes += 1;
  //           var v : Voter = {email = voterMail; hasVoted = true};
  //           voters.add(v);
  //         }
  //       };
  //       // return "No such candidate found";
  //       return "Vote cast";
  //     };
  //   };


  public query func getVotes() : async [(Text, Nat)] {
    Iter.toArray(votes.entries());
  };

  public func addCandidate(entry : Text) : async [(Text, Nat)] {
    votes.put(entry, 0);
    Iter.toArray(votes.entries());
  };

  public func vote(voterMail : Text, entry : Text) : async [(Text, Nat)] {
    if (not personExistsVoters(voterMail)) {
    let votes_for_entry : ?Nat = votes.get(entry);

    let current_votes_for_entry : Int = switch votes_for_entry {
      case null -1;
      case (?Nat) Nat;
    };

    if (current_votes_for_entry != -1) {
      let current_votes_for_entry_nat : Nat = textToNat(Int.toText(current_votes_for_entry));
      votes.put(entry, current_votes_for_entry_nat + 1);
    };

    votedList.add(voterMail);

    Iter.toArray(votes.entries());
    } else return Iter.toArray(votes.entries());
  };

  public func resetVotes(passkey : Text) : async () {
    if (passkey == psk) votes := RBTree.RBTree(Text.compare);
  };

};