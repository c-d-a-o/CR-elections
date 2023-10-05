import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";

actor {
  let psk : Text = "theorywillonlytakeyousofar";

  var votedList = HashMap.HashMap<Text, Bool>(120);

  var votes : HashMap.HashMap<Text, Nat> = HashMap.HashMap(Text.compare);

  func textToNat(t : Text) : Nat {
    var n : Nat = 0;
    for (c in t.chars()) {
      if (Char.isDigit(c)) {
        let charAsNat : Nat = Nat.fromInt(Char.toNat32(c) - 48);
        n := n * 10 + charAsNat;
      }
    };
    return n;
  };

  public query func getVotes() : async [(Text, Nat)] {
    HashMap.toPairs(votes);
  };

  public func vote(voterMail : Text, entry : Text) : async [(Text, Nat)] {
    if (!votedList.containsKey(voterMail)) {
      let votes_for_entry : ?Nat = votes.get(entry);
      let current_votes_for_entry : Nat = switch (votes_for_entry) {
        case (?Nat) Nat => Nat;
        case null => 0;
      };
      votes.put(entry, current_votes_for_entry + 1);
      votedList.put(voterMail, true);
      HashMap.toPairs(votes);
    } else {
      HashMap.toPairs(votes);
    };
  };

  public func resetVotes(passkey : Text) : async () {
    if (passkey == psk) {
      votes := HashMap.HashMap(Text.compare);
      votedList.clear();
    };
  };
};
