# Only one tx in block 243,821 signals opt-in RBF. What is its txid?

# get the block hash for block height 243821
blockhash=$(bitcoin-cli -signet getblockhash 243821)

# get all txids in that block
txids=$(bitcoin-cli -signet getblock $blockhash | jq -r '.tx[]')

# loop through each tx and check if any input has sequence < 0xfffffffe
for txid in $txids; do
  vin_sequences=$(bitcoin-cli -signet getrawtransaction $txid true | jq '[.vin[].sequence]')
  if echo $vin_sequences | jq 'any(.[]; . < 4294967294)' | grep -q true; then
    echo "$txid"
    break
  fi
done
