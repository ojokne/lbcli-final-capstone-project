# Which tx in block 216,351 spends the coinbase output of block 216,128?

# get block hashes
BLOCK_216128=$(bitcoin-cli -signet getblockhash 216128)
BLOCK_216351=$(bitcoin-cli -signet getblockhash 216351)

# get the coinbase txid from block 216128
COINBASE_TXID=$(bitcoin-cli -signet getblock "$BLOCK_216128" | jq -r '.tx[0]')

# check if the coinbase output is spent (vout 0)
SPENT=$(bitcoin-cli -signet gettxout "$COINBASE_TXID" 0)

if [[ "$SPENT" != "null" ]]; then
  echo "Coinbase output from block 216128 is still unspent."
  exit 0
fi

# search for the transaction in block 216351 that spends it
SPENDER_TXID=$(bitcoin-cli -signet getblock "$BLOCK_216351" 2 | jq -r --arg txid "$COINBASE_TXID" '
  .tx[] | select(.vin[]?.txid == $txid) | .txid')


echo "$SPENDER_TXID"
