# what block height was this tx mined ?
# 49990a9c8e60c8cba979ece134124695ffb270a98ba39c9824e42c4dc227c7eb

txid="49990a9c8e60c8cba979ece134124695ffb270a98ba39c9824e42c4dc227c7eb"
# get block hash
hash=$(bitcoin-cli -signet getrawtransaction "$txid" true | jq -r '.blockhash')

# get block height
height=$(bitcoin-cli -signet getblock "$hash" | jq -r '.height')

echo "$height"