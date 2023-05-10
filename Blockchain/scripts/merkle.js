const crypto = require("crypto");

class MerkleTree {
  constructor(transactions) {
    this.transactions = transactions;
    this.pastTrees = [];
    this.root = this.generateTree(transactions);
  }

  generateTree(transactions) {
    const newTransactions = [];
    for (let i = 0; i < transactions.length; i += 2) {
      const left = transactions[i];
      const right = i + 1 === transactions.length ? left : transactions[i + 1];
      const combinedHash = crypto
        .createHash("sha256")
        .update(left + right)
        .digest("hex");
      newTransactions.push(combinedHash);
    }

    if (newTransactions.length === 1) {
      this.pastTrees.push(newTransactions[0]);
      return newTransactions[0];
    } else {
      this.pastTrees.push(newTransactions);
      return this.generateTree(newTransactions);
    }
  }
}

const createdTree = new MerkleTree([
  "0x01",
  "0x02",
  "0x03",
  "0x04",
  "0x05",
  "0x06",
  "0x07",
  "0x08",
  "0x09",
  "0x0a",
  "0x0b",
  "0x0c",
  "0x0d",
  "0x0e",
  "0x0f",
  "0x10",
]);
// const exludedLeaves = createdTree.pastTrees;
// exludedLeaves.shift();

console.log(createdTree.pastTrees);
