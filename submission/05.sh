# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb

txid=b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb
tx=$(bitcoin-cli -signet getrawtransaction $txid true)

outputs=$(echo $tx | jq '[.vout[].value] | add')

inputs=0
for txin in $(echo $tx | jq -r '.vin[].txid'); do
  vout=$(echo $tx | jq -r ".vin[] | select(.txid == \"$txin\") | .vout")
  prevtx=$(bitcoin-cli -signet getrawtransaction $txin true)
  value=$(echo $prevtx | jq ".vout[$vout].value")
  inputs=$(echo "$inputs + $value" | bc)
done

fee_btc=$(echo "$inputs - $outputs" | bc -l)
fee_sats=$(echo "$fee_btc * 100000000 / 1" | bc)
echo "$fee_sats"
