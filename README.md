# OpenFL: Decentralized Federated Learning on Public Blockchain Systems

```
//   ___                   _____ _     
//  / _ \ _ __   ___ _ __ |  ___| |    
// | | | | '_ \ / _ \ '_ \| |_  | |    
// | |_| | |_) |  __/ | | |  _| | |___ 
//  \___/| .__/ \___|_| |_|_|   |_____|
//       |_|                           
// by Anton Wahrstätter, Sajjad Khan and Davor Svetinovic
```


We propose and implement a decentralized federated learning environment that builds on top of the Ethereum blockchain.

This repository contains the following code:
```c++
* contracts/PubFLManager.sol -> Solidity
* contracts/PubFLModel.sol   -> Solidity
* api/smartcontracts.py -> Python3
* api/pytorch_model.py  -> Python3
* experiments/mnist_ropsten_experiment.ipynb -> Jupyter Notebook
* experiments/cifar10_ganache_experiment.ipynb -> Jupyter Notebook
```

## Run the MNIST Notebook
The MNIST notebook expects:
- Compiled contract artifacts in `build/`
- A local RPC endpoint in `rpc_endpoint.txt` (Anvil)
- A Python environment with the required dependencies

### 1) Create a Python environment and install dependencies
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 2) Compile the contracts (Foundry)
Install Foundry (`forge`), then:
```bash
./scripts/build_contracts.sh
```
This writes:
- `build/abi.txt`
- `build/bytecode.txt`
- `build/abi_model.txt`
- `build/bytecode_model.txt`

### 3) Configure RPC files
```bash
cp rpc_endpoint.txt.example rpc_endpoint.txt
```
Set:
- `rpc_endpoint.txt` to local Anvil endpoint (`http://127.0.0.1:8545`)
- Optional: `rpc_fork_url.txt` for upstream fork RPC (Alchemy/Infura/etc.)
- If `rpc_fork_url.txt` is missing or empty, `start_anvil.sh` runs a pure local chain.

### 4) Start Anvil fork (recommended)
The notebook uses `manual_ganache_setup=True`, so start local node manually:
```bash
./scripts/start_anvil.sh
```

### 5) Launch Jupyter
```bash
./scripts/run_notebook.sh
```
Open `experiments/mnist_ropsten_experiment.ipynb`.

### Notes
- In the notebook, keep `FORK = True` for local Anvil fork usage.
- If you set `FORK = False`, you must provide `private_keys.txt` and adapt chain settings
  in `api/smartcontracts.py` (`buildNonForkTx` is hardcoded with `chainId=3`).
- With `FORK = True`, you do not need `private_keys.txt`.
  (see `private_keys.txt.example`).

We deploy our contracts to the following addresses (Ropsten Testnet):
* 0x8CDcb2082091c48BC90677C112fde145541dC519 ([Manager Contract](https://ropsten.etherscan.io/address/0x8CDcb2082091c48BC90677C112fde145541dC519#code))
* 0x059bff304F4653a1C290E368FE14cC36cB41461B ([Challenge Contract](https://ropsten.etherscan.io/address/0x059bff304f4653a1c290e368fe14cc36cb41461b))


![alt text](./charts/experiments.png)
