//1: Call Function
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IHero {
    function alert() external;
}

contract Sidekick {
    function sendAlert(address hero) external {
        // TODO: alert the hero using the IHero interface
        IHero(hero).alert();
    }
}


//2: Signature
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Sidekick {
    function sendAlert(address hero) external {
        // TODO: fill in the function signature in the ""
        bytes4 signature = bytes4(keccak256("alert()"));

        (bool success, ) = hero.call(abi.encodePacked(signature));

        require(success);
    }
}


//3: With Signature
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Sidekick {
    function sendAlert(address hero, uint enemies, bool armed) external {
        (bool success, ) = hero.call(
            /* TODO: alert the hero with the proper calldata! */
            abi.encodeWithSignature("alert(uint256,bool)", enemies, armed)            
        );

        require(success);
    }
}

//4: Arbitrary Alert
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Sidekick {
    function relay(address hero, bytes memory data) external {
        // send all of the data as calldata to the hero
        (bool s, ) = hero.call(data);
        require(s);
    }
}

//5: Fallback
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Sidekick {
    function makeContact(address hero) external {
        // TODO: trigger the hero's fallback function!
        hero.call("");
    }
}

//1: Fixed Sum
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Contract {
    function sum(uint[5] calldata integers) external pure returns (uint){
        return integers[0]+integers[1]+integers[2]+integers[3]+integers[4];
    }
}

//2: Dynamic Sum
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Contract {
    function sum(uint[] calldata num) external pure returns (uint){
        uint total = 0;
        for (uint i = 0; i < num.length; i++) {
            total += num[i];
        }
        return total;
    }
}

//3: Filter to Storage
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Contract {
    uint[] public evenNumbers;

    function filterEven(uint[] calldata nums) external {
        for (uint i = 0; i < nums.length; i++) {
            if (nums[i] % 2 == 0) {
                evenNumbers.push(nums[i]);
            }
        }
    }
}

//4: Filter to Memory
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Contract {
    function filterEven(uint[] calldata numbers) 
        external  
		pure
        returns(uint[] memory) 
    {
		uint elements;
		for(uint i = 0; i < numbers.length; i++) {
			if (numbers[i] % 2 == 0) {
                elements++;
            }
		}

		uint[] memory filtered = new uint[](elements);
		uint filledIndex = 0;
		for(uint i = 0; i < numbers.length; i++) {
			if (numbers[i] % 2 == 0) {
				filtered[filledIndex] = numbers[i];
				filledIndex++;
			}
		}
		return filtered;
	}
}

//5: Stack Club 1
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract StackClub {
    address[] public members;

    constructor() {
        members.push(msg.sender);
    }

    function addMember(address newMember) external {
        require(isMember(msg.sender), "");
        members.push(newMember);
    }

    function removeLastMember() external {
        require(isMember(msg.sender), "");
        require(members.length > 0, "");

        members.pop();
    }

    function isMember(address user) public view returns (bool) {
        for (uint i = 0; i < members.length; i++) {
            if (members[i] == user) {
                return true;
            }
        }
        return false;
    }
}

6: Stack Club 2
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract StackClub {
    address[] public members;

    constructor() {
        members.push(msg.sender);
    }

    function addMember(address newMember) external {
        require(isMember(msg.sender), "");
        members.push(newMember);
    }

    function removeLastMember() external {
        require(isMember(msg.sender), "");
        require(members.length > 0, "");

        members.pop();
    }

    function isMember(address user) public view returns (bool) {
        for (uint i = 0; i < members.length; i++) {
            if (members[i] == user) {
                return true;
            }
        }
        return false;
    }
}

//1: Vote Storage
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Contract {
	enum Choices { Yes, No }

	// TODO: create a vote struct and a public state variable
	struct Vote {
        Choices choice;
        address voter;
    }

	Vote public vote;

	function createVote(Choices choice) external {
		// TODO: create a new vote
		 vote = Vote({
            choice: choice,
            voter: msg.sender
        });
	}
}

//2: Vote Memory
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Contract {
	enum Choices { Yes, No }

	struct Vote {
		Choices choice;
		address voter;
	}

	function createVote(Choices _choice) external view returns (Vote memory) {
        return Vote({
            choice: _choice,
            voter: msg.sender
        });
    }
}

//3: Vote Array
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Contract {
	enum Choices { Yes, No }
	
	struct Vote {
		Choices choice;
		address voter;
	}
	
	Vote[] public votes;

	function createVote(Choices choice) external {
        for (uint i = 0; i < votes.length; i++) {
            require(votes[i].voter != msg.sender, "");
        }

		votes.push(Vote({
            choice: choice,
            voter: msg.sender
        }));
	}

	function hasVoted(address user) external view returns (bool) {
        for (uint i = 0; i < votes.length; i++) {
            if (votes[i].voter == user) {
                return true;
            }
        }
        return false;
    }

    function findChoice(address user) external view returns (Choices) {
        for (uint i = 0; i < votes.length; i++) {
            if (votes[i].voter == user) {
                return votes[i].choice;
            }
        }
    }

    function changeVote(Choices newchoice) external {
        for (uint i = 0; i < votes.length; i++) {
            if (votes[i].voter == msg.sender) {
                votes[i].choice = newchoice;
                return;
            }
        }
        revert();
    }
}

//4: Choice Lookup
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Contract {
	enum Choices { Yes, No }
	
	struct Vote {
		Choices choice;
		address voter;
	}
	
	Vote[] public votes;

	function createVote(Choices choice) external {
        for (uint i = 0; i < votes.length; i++) {
            require(votes[i].voter != msg.sender, "");
        }

		votes.push(Vote({
            choice: choice,
            voter: msg.sender
        }));
	}

	function hasVoted(address user) external view returns (bool) {
        for (uint i = 0; i < votes.length; i++) {
            if (votes[i].voter == user) {
                return true;
            }
        }
        return false;
    }

    function findChoice(address user) external view returns (Choices) {
        for (uint i = 0; i < votes.length; i++) {
            if (votes[i].voter == user) {
                return votes[i].choice;
            }
        }
    }

    function changeVote(Choices newchoice) external {
        for (uint i = 0; i < votes.length; i++) {
            if (votes[i].voter == msg.sender) {
                votes[i].choice = newchoice;
                return;
            }
        }
        revert();
    }
}

//5: Single Vote
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Contract {
	enum Choices { Yes, No }
	
	struct Vote {
		Choices choice;
		address voter;
	}
	
	Vote[] public votes;

	function createVote(Choices choice) external {
        for (uint i = 0; i < votes.length; i++) {
            require(votes[i].voter != msg.sender, "");
        }

		votes.push(Vote({
            choice: choice,
            voter: msg.sender
        }));
	}

	function hasVoted(address user) external view returns (bool) {
        for (uint i = 0; i < votes.length; i++) {
            if (votes[i].voter == user) {
                return true;
            }
        }
        return false;
    }

    function findChoice(address user) external view returns (Choices) {
        for (uint i = 0; i < votes.length; i++) {
            if (votes[i].voter == user) {
                return votes[i].choice;
            }
        }
    }

    function changeVote(Choices newchoice) external {
        for (uint i = 0; i < votes.length; i++) {
            if (votes[i].voter == msg.sender) {
                votes[i].choice = newchoice;
                return;
            }
        }
        revert();
    }
}

//6: Change Vote
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Contract {
	enum Choices { Yes, No }
	
	struct Vote {
		Choices choice;
		address voter;
	}
	
	Vote[] public votes;

	function createVote(Choices choice) external {
        for (uint i = 0; i < votes.length; i++) {
            require(votes[i].voter != msg.sender, "");
        }

		votes.push(Vote({
            choice: choice,
            voter: msg.sender
        }));
	}

	function hasVoted(address user) external view returns (bool) {
        for (uint i = 0; i < votes.length; i++) {
            if (votes[i].voter == user) {
                return true;
            }
        }
        return false;
    }

    function findChoice(address user) external view returns (Choices) {
        for (uint i = 0; i < votes.length; i++) {
            if (votes[i].voter == user) {
                return votes[i].choice;
            }
        }
    }

    function changeVote(Choices newchoice) external {
        for (uint i = 0; i < votes.length; i++) {
            if (votes[i].voter == msg.sender) {
                votes[i].choice = newchoice;
                return;
            }
        }
        revert();
    }
}

//1: Add Member
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    mapping(address => bool) public members;

    function addMember(address user) external {
        members[user] = true;
    }

    function isMember(address user) external view returns (bool) {
        return members[user];
    }

    function removeMember(address user) external {
        members[user] = false;
    }
}

//2: Is Member
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    mapping(address => bool) public members;

    function addMember(address user) external {
        members[user] = true;
    }

    function isMember(address user) external view returns (bool) {
        return members[user];
    }

    function removeMember(address user) external {
        members[user] = false;
    }
}

//3: Remove Member
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    mapping(address => bool) public members;

    function addMember(address user) external {
        members[user] = true;
    }

    function isMember(address user) external view returns (bool) {
        return members[user];
    }

    function removeMember(address user) external {
        members[user] = false;
    }
}

//4: Map Structs
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
	struct User {
		uint balance;
		bool isActive;
	}

	mapping(address => User) public users;

    function createUser() external {
		if (users[msg.sender].isActive) {
            revert();
        }
		
		users[msg.sender] = User({
			balance: 100,
            isActive: true
        });
    }

	function transfer(address recipient, uint256 amount) external {
        if (!users[msg.sender].isActive || !users[recipient].isActive || users[msg.sender].balance < amount) {
            revert();
        }

        users[msg.sender].balance -= amount;
        users[recipient].balance += amount;
    }
}

//5: Map Structs 2
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
	struct User {
		uint balance;
		bool isActive;
	}

	mapping(address => User) public users;

    function createUser() external {
		if (users[msg.sender].isActive) {
            revert();
        }
		
		users[msg.sender] = User({
			balance: 100,
            isActive: true
        });
    }

	function transfer(address recipient, uint256 amount) external {
        if (!users[msg.sender].isActive || !users[recipient].isActive || users[msg.sender].balance < amount) {
            revert();
        }

        users[msg.sender].balance -= amount;
        users[recipient].balance += amount;
    }
}

//6: Nested Maps
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
	enum ConnectionTypes { 
		Unacquainted,
		Friend,
		Family
	}
	
	mapping(address => mapping(address => ConnectionTypes)) public connections;

	function connectWith(address other, ConnectionTypes connectionType) external {
        connections[msg.sender][other] = connectionType;
	}
}
