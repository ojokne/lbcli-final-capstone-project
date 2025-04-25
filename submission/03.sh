# Which tx in block 216,351 spends the coinbase output of block 216,128?

# Get coinbase txid from block 216128
block216128=$(bitcoin-cli -signet getblockhash 216128)

coinbaseTransactionId=$(bitcoin-cli -signet getblock "$block216128" | jq -r ".tx[0]")

# Get block hash of block 216351
block216351=$(bitcoin-cli -signet getblockhash 216351)

# Get all transactions in block 216351
transactions=$(bitcoin-cli -signet getblock "$block216351" | jq -r ".tx[]")

# Loop through each tx to find one that spends the coinbase output
for tx in $transactions; do
  vins=$(bitcoin-cli -signet getrawtransaction "$tx" true | jq -r ".vin[] | .txid")
  for vin in $vins; do
    if [ "$vin" == "$coinbaseTransactionId" ]; then
      echo "$tx"
      exit 0
    fi
  done
done

