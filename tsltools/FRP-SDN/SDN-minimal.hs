
{- Initial Network Spec in TSL
initially assume {
  !(haspacket(r1) || haspacket(r2));
  !(forwardsTo(s, noder1()) || forwardsTo(s, noder2()));
}

always assume {
  [s <- addFwd(s, noder1())] -> X forwardsTo(s, noder1()) W [s <- rmFwd(s, noder1())];
  [s <- addFwd(s, noder2())] -> X forwardsTo(s, noder2()) W [s <- rmFwd(s, noder2())];
  [s <- rmFwd(s, noder1())] -> !forwardsTo(s, noder1()) W [s <- addFwd(s, noder1())];
  [s <- rmFwd(s, noder2())] -> !forwardsTo(s, noder2()) W [s <- addFwd(s, noder2())];
}

always guarantee {
  //forwardsTo(s, noder1()) && haspacket(s) && dest(s, noder1()) -> F haspacket(r1);
  //forwardsTo(s, noder2()) && haspacket(s) && dest(s, noder2()) -> F haspacket(r2);

  dest(s,noder1()) -> F haspacket(r1);
  dest(s,noder2()) -> F haspacket(r2);
}
-}

{-# LANGUAGE

    LambdaCase
  , RankNTypes
  , RecordWildCards
  , ImplicitParams
  , TemplateHaskell
  , FlexibleContexts
  , MultiParamTypeClasses
  , ScopedTypeVariables
  , ConstraintKinds

  #-}


data Packet = String {-
  --packetBufferID :: Maybe BufferID, -- buffer ID, if packet buffered at switch
  --packetOrigLen :: NumBytes, -- full length of frame received by switch
  --packetInPort :: PortID, -- port on which frame was received
  --packetInReason :: PacketInReason, -- reason packet is being sent
  --packetData :: [Word8 ] -- ethernet frame received by switch
  contents :: Message
-}

data Destination = Destination {
  destSwitchID :: Maybe SwitchID, --if receiver is a switch (not yet at end dest)
  destID :: DestID,
  hasPacket :: [Packet]
}

data Switch = Switch {
  switch :: switchID,
  containsPacket :: [Packet],
  forwardingRules :: [Rules]
}

data SwitchID = Int 
data DestID = Int
data Rules = (Switch, Destination)

haspacket :: a -> Packet -> Bool


containsP :: [Packet] -> Packet -> Bool
containsP [] p = False
containsP [x] p = x == p
containsP [x:xs] p = (x == p) || containsP xs p


factory conf =
  do table ← newHashTable size hashfun
  let ph = packetHandler table
    return (switchHandler {onPacket = ph })
packetHandler table pkt =
  do insert table (etherSc pkt) (inPort pkt)
    result ← lookup table (etherDst pkt)
    case result of
      Nothing → forward pkt flood
      Just destPort → forwardRule pkt (exactMatch pkt) (phyPort destPort) opts


