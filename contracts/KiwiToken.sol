//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20VotesComp.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KiwiToken is Context, AccessControlEnumerable, ERC20Burnable, ERC20Permit, ERC20VotesComp {
  address public constant initialLiquidityProvider = 0xedEA1d58Ad20E30Ff03a660A773757E1c8209D13;
  address public constant devWallet = 0xa15C8F207c1DD6790e231E5ba2e415b163007441;
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  
  bool public init = true;

  constructor () ERC20("KIWI", "KIWI") ERC20Permit("KIWI") {
    _mint(initialLiquidityProvider, 10 * (10 ** 18));

    _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

    _setupRole(MINTER_ROLE, _msgSender());

    init = false;
  }

  function _afterTokenTransfer(address from, address to, uint256 amount) internal override (ERC20, ERC20Votes) {
    ERC20Votes._afterTokenTransfer(from, to, amount);
  }

  function _mint (address account, uint256 amount) internal override (ERC20, ERC20Votes) {
    // Allocate an extra 10% of minted tokens to project development
    if (!init) {
      ERC20Votes._mint(devWallet, amount / 100 * 18);
    }

    ERC20Votes._mint(account, amount);
  }

  function _burn (address account, uint256 amount) internal override (ERC20, ERC20Votes) {
    ERC20Votes._burn(account, amount);
  }

  function mint(address to, uint256 amount) public virtual {
    require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
    _mint(to, amount);
  }
}