import web3

# Connect to ganache
w3 = web3.Web3(web3.HTTPProvider("http://localhost:7545"))

# Get the account address
account_address = "0x8ED45aC4031A831a12e08542B2401A242020682F"

def get_balance(w3, account_address):
    return w3.eth.get_balance(account_address)
