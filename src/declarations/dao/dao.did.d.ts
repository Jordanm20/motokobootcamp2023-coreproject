import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface StaticProposal {
  'id' : bigint,
  'votesA' : bigint,
  'votesF' : bigint,
  'alreadyVoted' : Array<Principal>,
  'body' : string,
}
export interface _SERVICE {
  'get_all_proposals' : ActorMethod<[], Array<[bigint, StaticProposal]>>,
  'get_proposal' : ActorMethod<[bigint], [] | [StaticProposal]>,
  'get_tokens' : ActorMethod<[], bigint>,
  'submit_proposal' : ActorMethod<
    [string],
    { 'Ok' : StaticProposal } |
      { 'Err' : string }
  >,
  'update_site' : ActorMethod<[string], undefined>,
  'vote' : ActorMethod<
    [bigint, boolean],
    { 'Ok' : [bigint, bigint] } |
      { 'Err' : string }
  >,
}