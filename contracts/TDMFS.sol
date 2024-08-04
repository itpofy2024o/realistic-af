// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract ToDoMFers {
    struct JustDoIt {
        uint256 id;
        string header;
        string[] tasks;
        bool done;
        string[] comments;
    }

    JustDoIt[] public jdis;
    uint256[] ds;

    event DidIt(uint256 id, string header, string[] tasks, bool done);
    event DoneIt(uint256 id, bool done);

    function ToBeDone(string memory headerANew, string[] memory tasksANew) public {
        string[] memory emptyTags;
        jdis.push(JustDoIt({
            id: jdis.length,
            header:headerANew,
            tasks:tasksANew,
            done:false,
            comments:emptyTags
        }));
        emit DidIt(jdis.length, headerANew, tasksANew, false);
    }

    function AllDid() public view returns (JustDoIt[] memory) {
        return jdis;
    }

    function AllDidNotDone() public view returns (JustDoIt[] memory) {
        JustDoIt[] memory jdisnd = new JustDoIt[](jdis.length-ds.length);
        for (uint g=0;g<jdis.length;g++) {
            if (jdis[g].done==false) {
                jdisnd[jdisnd.length]=jdis[g];
            }
        }
        return jdisnd;
    }

    function DidOne(uint256 did) public view returns (JustDoIt memory) {
        if (jdis[did].id==did) {
            return jdis[did];
        } else {
            revert("No such instance");
        }
    }

    function DoneLots(uint256[] memory dids) public {
        for (uint d = 0; d< dids.length;d++) {
            if (jdis[dids[d]].id==d) {
                if (jdis[dids[d]].done==false) {
                    jdis[dids[d]].done=!jdis[dids[d]].done;
                    ds.push(dids[d]);
                    emit DoneIt(dids[d], true);
                } else {
                    
                }
            } else {
                
            }
        }
    }
}