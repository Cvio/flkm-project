## Truffle Commands Cheat Sheet

### General Commands

- **Initialize a new Truffle project**:  
  truffle init

- **Compile contracts**:  
  truffle compile

- **Run migrations to deploy contracts**:  
  truffle migrate

- **Run specific migration**:  
  truffle migrate -f <migration_number>

- **Run migrations on a specific network**:  
  truffle migrate --network <network_name>

- **Reset and re-run all migrations**:  
  truffle migrate --reset

### Test Commands

- **Run all tests**:  
  truffle test

- **Run specific test file**:  
  truffle test ./path/to/test/file.js

### Console and Networks

- **Open Truffle console**:  
  truffle console

- **Open Truffle console on a specific network**:  
  truffle console --network <network_name>
  "truffle console --development" for example

- **List all available networks**:  
  truffle exec scripts/accts.js

### Other Commands

- **Create a new migration file**:  
  touch ./migrations/<timestamp>\_<name_of_migration>.js

- **Create a new contract file**:  
  touch ./contracts/<ContractName>.sol

- **Create a new test file**:  
  touch ./test/<test_file_name>.js

- **Flatten a contract**:  
  truffle-flattener ./contracts/YourContract.sol > ./FlatYourContract.sol
