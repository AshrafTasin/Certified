
# chmod -R 0755 ./crypto-config
# # Delete existing artifacts
# rm -rf ./crypto-config
rm genesis.block test_channel.tx test_channel.block STARTECHMSPanchors.tx SUSTMSPanchors.tx
rm -rf ../../channel-artifacts/*

#Generate Crypto artifactes for organizations
# cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/



# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "mychannel"
CHANNEL_NAME="channelbeta"

echo $CHANNEL_NAME

# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./channelbeta.tx -channelID $CHANNEL_NAME

echo "#######    Generating anchor peer update for SUSTMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./SUSTMSPanchors.tx -channelID $CHANNEL_NAME -asOrg SUSTMSP

echo "#######    Generating anchor peer update for STARTECHMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./STARTECHMSPanchors.tx -channelID $CHANNEL_NAME -asOrg STARTECHMSP