export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_SUST_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/tls/ca.crt
export PEER0_STARTECH_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/example.startech.com/peers/peer0.example.startech.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME=channelbeta


setGlobalsForPeer0SUST(){
    export CORE_PEER_LOCALMSPID="SUSTMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SUST_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/example.sust.edu/users/Admin@example.sust.edu/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1SUST(){
    export CORE_PEER_LOCALMSPID="SUSTMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SUST_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/example.sust.edu/users/Admin@example.sust.edu/msp
    export CORE_PEER_ADDRESS=localhost:8051
    
}

setGlobalsForPeer0STARTECH(){
    export CORE_PEER_LOCALMSPID="STARTECHMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_STARTECH_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/example.startech.com/users/Admin@example.startech.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    
}

setGlobalsForPeer1STARTECH(){
    export CORE_PEER_LOCALMSPID="STARTECHMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_STARTECH_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/example.startech.com/users/Admin@example.startech.com/msp
    export CORE_PEER_ADDRESS=localhost:10051
    
}

createChannel(){
   
    setGlobalsForPeer0SUST
    
    peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.example.com \
    -f ./artifacts/channel/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

removeOldCrypto(){
    rm -rf ./api-2.0/sust-wallet/*
    rm -rf ./api-2.0/startech-wallet/*
}


joinChannel(){
    setGlobalsForPeer0SUST
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    # echo "Peer0SUST joined"
    
    setGlobalsForPeer1SUST
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    # echo "Peer1SUST joined"
    
    setGlobalsForPeer0STARTECH
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    # echo "PeeroSTAR joined"
    
    setGlobalsForPeer1STARTECH
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    # echo "Peer1STAR joined"
    
}


updateAnchorPeers(){
    setGlobalsForPeer0SUST
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobalsForPeer1STARTECH
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
}

# removeOldCrypto

createChannel
joinChannel

updateAnchorPeers