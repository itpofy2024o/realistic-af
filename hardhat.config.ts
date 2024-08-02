import type { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";
import '@matterlabs/hardhat-zksync-deploy';
import '@matterlabs/hardhat-zksync-solc';

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  defaultNetwork: "zkSyncTestnet",
  networks: {
    zkSyncTestnet: {
      url: "https://testnet.era.zksync.dev",
      ethNetwork: "goerli", // Can also use a Goerli RPC URL or your Alchemy/Infura project
      zksync: true
    },
  },
};

export default config;
