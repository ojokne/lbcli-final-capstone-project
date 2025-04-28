# what is the coinbase tx in this block 243,834

# get block hash
hash=$(bitcoin-cli -signet getblockhash 243834)

tx=$(bitcoin-cli -signet getblock "$hash" | jq -r '.tx[0]')
echo "$tx"