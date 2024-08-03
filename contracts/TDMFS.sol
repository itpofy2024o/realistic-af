// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract ToDoMFers {
    struct JustDoIt {
        uint256 id;
        string header;
        string[] tasks;
        bool done;
    }

    JustDoIt[] public jdis;
    mapping(uint256 => bool) hs;

    event DidIt(uint256 id, string header, string[] tasks, bool done);
    event ChangedIt(uint256 id, bool done);
    event HidIt(uint256 id);

    function ToBeDone(string memory headerANew, string[] memory tasksANew) public {
        jdis.push(JustDoIt({
            id: jdis.length,
            header:headerANew,
            tasks:tasksANew,
            done:false
        }));
        emit DidIt(jdis.length, headerANew, tasksANew, false);
    }

    function AllDid() public view returns (JustDoIt[] memory) {
        return jdis;
    }

    function AllDidNotDone() public view returns (JustDoIt[] memory) {
        
    }

    function DidOne(uint256 did) public view returns (JustDoIt memory) {
        if (jdis[did].id==did) {
            return jdis[did];
        } else {
            revert("No such instance");
        }
    }

    function ChangedOne(uint256[] memory dids) public {
        for (uint d = 0; d< dids.length;d++) {
            if (jdis[dids[d]].id==d) {
                if (jdis[dids[d]].done==false) {
                    jdis[dids[d]].done=!jdis[dids[d]].done;
                    emit ChangedIt(dids[d], true);
                } else {
                    
                }
            } else {
                
            }
        }
    }

    function HidLots(uint256[] memory dids) public {
        for (uint s=0;s<dids.length;s++) {

        }
    }
}