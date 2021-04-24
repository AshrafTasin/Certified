createcertificatesForSUST() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p crypto-config-ca/peerOrganizations/example.sust.edu/
  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.example.sust.edu --tls.certfiles ${PWD}/fabric-ca/sust/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-example-sust-edu.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-example-sust-edu.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-example-sust-edu.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-example-sust-edu.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/msp/config.yaml


  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.example.sust.edu --id.name sustadmin --id.secret sustadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/sust/tls-cert.pem
  
  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.example.sust.edu --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/sust/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.example.sust.edu --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/sust/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.example.sust.edu --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/sust/tls-cert.pem

  

  mkdir -p crypto-config-ca/peerOrganizations/example.sust.edu/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.example.sust.edu -M ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/msp --csr.hosts peer0.example.sust.edu --tls.certfiles ${PWD}/fabric-ca/sust/tls-cert.pem

  cp ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/msp/config.yaml ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.example.sust.edu -M ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/tls --enrollment.profile tls --csr.hosts peer0.example.sust.edu --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/sust/tls-cert.pem

  cp ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/tls/ca.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/tls/signcerts/* ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/tls/server.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/tls/keystore/* ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/tls/server.key

  mkdir ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/msp/tlscacerts/ca.crt

  mkdir ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/tlsca
  cp ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/tlsca/tlsca.example.sust.edu-cert.pem

  mkdir ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/ca
  cp ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer0.example.sust.edu/msp/cacerts/* ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/ca/ca.example.sust.edu-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer1.example.sust.edu

  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.example.sust.edu -M ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer1.example.sust.edu/msp --csr.hosts peer1.example.sust.edu --tls.certfiles ${PWD}/fabric-ca/sust/tls-cert.pem

  cp ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/msp/config.yaml ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer1.example.sust.edu/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.example.sust.edu -M ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer1.example.sust.edu/tls --enrollment.profile tls --csr.hosts peer1.example.sust.edu --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/sust/tls-cert.pem

  cp ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer1.example.sust.edu/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer1.example.sust.edu/tls/ca.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer1.example.sust.edu/tls/signcerts/* ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer1.example.sust.edu/tls/server.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer1.example.sust.edu/tls/keystore/* ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/peers/peer1.example.sust.edu/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p crypto-config-ca/peerOrganizations/example.sust.edu/users
  mkdir -p crypto-config-ca/peerOrganizations/example.sust.edu/users/User1@example.sust.edu

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.example.sust.edu -M ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/users/User1@example.sust.edu/msp --tls.certfiles ${PWD}/fabric-ca/sust/tls-cert.pem

  mkdir -p crypto-config-ca/peerOrganizations/example.sust.edu/users/Admin@example.sust.edu

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://sustadmin:sustadminpw@localhost:7054 --caname ca.example.sust.edu -M ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/users/Admin@example.sust.edu/msp --tls.certfiles ${PWD}/fabric-ca/sust/tls-cert.pem

  cp ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/msp/config.yaml ${PWD}/crypto-config-ca/peerOrganizations/example.sust.edu/users/Admin@example.sust.edu/msp/config.yaml

}

# createcertificatesForsust

createCertificateForStarTech() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /crypto-config-ca/peerOrganizations/example.startech.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.example.startech.com --tls.certfiles ${PWD}/fabric-ca/startech/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-example-startech-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-example-startech-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-example-startech-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-example-startech-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.example.startech.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/startech/tls-cert.pem
   

  echo
  echo "Register peer1"
  echo
   
  fabric-ca-client register --caname ca.example.startech.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/startech/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.example.startech.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/startech/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.example.startech.com --id.name startechadmin --id.secret startechadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/startech/tls-cert.pem
   

  mkdir -p crypto-config-ca/peerOrganizations/example.startech.com/peers
  mkdir -p crypto-config-ca/peerOrganizations/example.startech.com/peers/peer0.example.startech.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.example.startech.com -M ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer0.example.startech.com/msp --csr.hosts peer0.example.startech.com --tls.certfiles ${PWD}/fabric-ca/startech/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/msp/config.yaml ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer0.example.startech.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.example.startech.com -M ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer0.example.startech.com/tls --enrollment.profile tls --csr.hosts peer0.example.startech.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/startech/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer0.example.startech.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer0.example.startech.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer0.example.startech.com/tls/signcerts/* ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer0.example.startech.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer0.example.startech.com/tls/keystore/* ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer0.example.startech.com/tls/server.key

  mkdir ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer0.example.startech.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/tlsca
  cp ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer0.example.startech.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/tlsca/tlsca.example.startech.com-cert.pem

  mkdir ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/ca
  cp ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer0.example.startech.com/msp/cacerts/* ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/ca/ca.example.startech.com-cert.pem

  # --------------------------------------------------------------------------------
  #  Peer 1
  echo
  echo "## Generate the peer1 msp"
  echo
   
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.example.startech.com -M ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer1.example.startech.com/msp --csr.hosts peer1.example.startech.com --tls.certfiles ${PWD}/fabric-ca/startech/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/msp/config.yaml ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer1.example.startech.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.example.startech.com -M ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer1.example.startech.com/tls --enrollment.profile tls --csr.hosts peer1.example.startech.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/startech/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer1.example.startech.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer1.example.startech.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer1.example.startech.com/tls/signcerts/* ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer1.example.startech.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer1.example.startech.com/tls/keystore/* ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/peers/peer1.example.startech.com/tls/server.key
  # -----------------------------------------------------------------------------------

  mkdir -p crypto-config-ca/peerOrganizations/example.startech.com/users
  mkdir -p crypto-config-ca/peerOrganizations/example.startech.com/users/User1@example.startech.com

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.example.startech.com -M ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/users/User1@example.startech.com/msp --tls.certfiles ${PWD}/fabric-ca/startech/tls-cert.pem
   

  mkdir -p crypto-config-ca/peerOrganizations/example.startech.com/users/Admin@example.startech.com

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://startechadmin:startechadminpw@localhost:8054 --caname ca.example.startech.com -M ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/users/Admin@example.startech.com/msp --tls.certfiles ${PWD}/fabric-ca/startech/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/msp/config.yaml ${PWD}/crypto-config-ca/peerOrganizations/example.startech.com/users/Admin@example.startech.com/msp/config.yaml

}

# createCertificateForstartech

createCretificateForOrderer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p crypto-config-ca/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config-ca/ordererOrganizations/example.com

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml

  echo
  echo "Register orderer"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register orderer2"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register orderer3"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register the orderer admin"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  mkdir -p crypto-config-ca/ordererOrganizations/example.com/orderers
  # mkdir -p crypto-config-ca/ordererOrganizations/example.com/orderers/example.com

  # ---------------------------------------------------------------------------
  #  Orderer

  mkdir -p crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/msp --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls --enrollment.profile tls --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/signcerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/keystore/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.key

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts
  # cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/msp --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls --enrollment.profile tls --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/signcerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/keystore/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.key

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts
  # cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # ---------------------------------------------------------------------------

  mkdir -p crypto-config-ca/ordererOrganizations/example.com/users
  mkdir -p crypto-config-ca/ordererOrganizations/example.com/users/Admin@example.com

  echo
  echo "## Generate the admin msp"
  echo
   
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml

}

# createCretificateForOrderer

sudo rm -rf crypto-config-ca/*
# sudo rm -rf fabric-ca/*
createcertificatesForSUST
createCertificateForStarTech
createCretificateForOrderer

