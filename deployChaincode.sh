export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_SUST_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/tls/ca.crt
export PEER0_STARTECH_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/example.startech.com/peers/peer0.example.startech.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export PRIVATE_DATA_CONFIG=${PWD}/artifacts/private-data/collections_config.json

export CHANNEL_NAME=test-channel

setGlobalsForOrderer() {
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp

}

setGlobalsForPeer0SUST() {
    export CORE_PEER_LOCALMSPID="SUSTMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SUST_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/example.sust.edu/users/Admin@example.sust.edu/msp
    # export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1SUST() {
    export CORE_PEER_LOCALMSPID="SUSTMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SUST_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/example.sust.edu/users/Admin@example.sust.edu/msp
    export CORE_PEER_ADDRESS=localhost:8051

}

setGlobalsForPeer0STARTECH() {
    export CORE_PEER_LOCALMSPID="STARTECHMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_STARTECH_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/example.startech.com/users/Admin@example.startech.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

}

setGlobalsForPeer1STARTECH() {
    export CORE_PEER_LOCALMSPID="STARTECHMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_STARTECH_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/example.startech.com/users/Admin@example.startech.com/msp
    export CORE_PEER_ADDRESS=localhost:10051

}

presetup() {
    echo Vendoring Go dependencies ...
    pushd ./artifacts/chaincode/go
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies
}


CHANNEL_NAME="channelbeta"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
CC_SRC_PATH="./artifacts/chaincode/go"
CC_NAME="smartcert"

packageChaincode() {

    echo "--------------------- Packaging Chaincode ----------------------"
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer0SUST
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo " -- : Done : --"
    echo ""
}


installChaincode() {

    echo "--------------------- Installing Chaincode ----------------------"
    setGlobalsForPeer0SUST
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.SUST ===================== "

    setGlobalsForPeer1SUST
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer1.SUST ===================== "

    setGlobalsForPeer0STARTECH
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.STARTECH ===================== "

    setGlobalsForPeer1STARTECH
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer1.STARTECH ===================== "

    echo " -- : Done : --"
    echo ""
}


queryInstalled() {
    echo "--------------------- Querying Installed ----------------------"
    setGlobalsForPeer0SUST
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo " -- : Done : --"
    echo ""
}


approveForSUST() {
    echo "--------------------- Approving Chaincode : SUST ----------------------"
    setGlobalsForPeer0SUST
    # set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --collections-config $PRIVATE_DATA_CONFIG \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}
    # set +x

    echo " -- : Done : --"
    echo ""

}


checkCommitReadyness() {

    echo "--------------------- Checking commit readyness from SUST --------------------------"
    setGlobalsForPeer0SUST
    peer lifecycle chaincode checkcommitreadiness \
        --collections-config $PRIVATE_DATA_CONFIG \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo " -- : Done : --"
    echo ""
}


approveForSTARTECH() {

    echo "--------------------- Approving Chaincode : STARTECH ----------------------"
    setGlobalsForPeer1STARTECH

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --collections-config $PRIVATE_DATA_CONFIG \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}

    echo " -- : Done : --"
    echo ""
}


checkCommitReadyness() {
    
    echo "--------------------- Checking commit readyness from SUST ------------------------ "
    setGlobalsForPeer0SUST
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_SUST_CA \
        --collections-config $PRIVATE_DATA_CONFIG \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    
    echo " -- : Done : --"
    echo ""
}


commitChaincodeDefination() {

    echo "===================== Committing Chaincode Definition : SUST ===================== "
    setGlobalsForPeer0SUST
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --collections-config $PRIVATE_DATA_CONFIG \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_SUST_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_STARTECH_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required

    echo " -- : Done : --"
    echo ""

}


queryCommitted() {
    
    echo "-------------------- Querying Committed --------------------"
    setGlobalsForPeer0SUST
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
    echo " -- : Done : --"
    echo ""

}


chaincodeInvokeInit() {

    echo "-------------------- Chaincode Invoke Init -------------------------"
    
    setGlobalsForPeer0SUST
    
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_SUST_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_STARTECH_CA \
        --isInit -c '{"Args":[]}'

    echo " -- : Done : -- "
    echo ""

}



chaincodeInvoke() {

    echo "-------------------- Chaincode Invoke --------------------"

    setGlobalsForPeer0SUST

    ## Init ledger
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_SUST_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_STARTECH_CA \
        -c '{"function": "initLedger","Args":[]}'

    ## Add private data
    # export CAR=$(echo -n "{\"key\":\"1111\", \"make\":\"Tesla\",\"model\":\"Tesla A1\",\"color\":\"White\",\"owner\":\"pavan\",\"price\":\"10000\"}" | base64 | tr -d \\n)
    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME} \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_SUST_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_STARTECH_CA \
    #     -c '{"function": "createPrivateCar", "Args":[]}' \
    #     --transient "{\"car\":\"$CAR\"}"

    echo " -- : Done : --"
    echo ""
}



chaincodeQuery() {

    echo "-------------------- Chaincode Query --------------------"
    setGlobalsForPeer1STARTECH

    # Query all cars
    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["queryAllCars"]}'

    # Query Car by Id
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryStudent","Args":["2017331000"]}'
    #'{"Args":["GetSampleData","Key1"]}'

    # Query Private Car by Id
    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "readPrivateCar","Args":["1111"]}'
   # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "readCarPrivateDetails","Args":["1111"]}'

    echo " -- : Done : --"
    echo ""
}

# Run this function if you add any new dependency in chaincode
# presetup

packageChaincode

installChaincode
                                    queryInstalled
approveForSUST
                                    checkCommitReadyness
approveForSTARTECH
                                    checkCommitReadyness
commitChaincodeDefination
                                    queryCommitted
chaincodeInvokeInit

sleep 5
chaincodeInvoke

sleep 3
chaincodeQuery
