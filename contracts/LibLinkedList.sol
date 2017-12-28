pragma solidity ^0.4.18;

library LinkedList {

    bytes32 constant NULL = 0x0;
    bytes32 constant HEAD = 0x0;
    bool constant PREV = false;
    bool constant NEXT = true;
    
    struct LL {
        mapping (bytes32 => mapping (bool => bytes32)) cll;
    }

    // n: node id  d: direction  r: return node id

    // Return existential state of a list.
    function exists(LL storage self)
        internal view returns (bool)
    {
        if (self.cll[HEAD][PREV] != HEAD || self.cll[HEAD][NEXT] != HEAD)
            return true;
    }
    
    // Returns the number of elements in the list
    function sizeOf(LL storage self)
        internal view returns (uint r)
    {
        bytes32 i = step(self, HEAD, NEXT);
        while (i != HEAD) {
            i = step(self, i, NEXT);
            r++;
        }
        return;
    }

    // Returns the links of a node as and array
    function getNode(LL storage self, bytes32 n)
        internal view returns (bool)
    {
        if ((self.cll[n][PREV] != HEAD || self.cll[n][NEXT] != HEAD ) || ((self.cll[HEAD][NEXT] == n) && (self.cll[HEAD][PREV] == n)))
            return true;
    }

    // Returns the link of a node `n` in direction `d`.
    function step(LL storage self, bytes32 n, bool d)
        internal view returns (bytes32)
    {
        return self.cll[n][d];
    }

    // Can be used before `insert` to build an ordered list
    // `a` an existing node to search from, e.g. HEAD.
    // `b` value to seek
    // `r` first node beyond `b` in direction `d`
    function seek(LL storage self, bytes32 a, bytes32 b, bool d)
        internal view returns (bytes32 r)
    {
        r = step(self, a, d);
        while  ((b!=r) && ((b < r) != d)) r = self.cll[r][d];
        return;
    }

    // Creates a bidirectional link between two nodes on direction `d`
    function stitch(LL storage self, bytes32 a, bytes32 b, bool d) internal {
        self.cll[b][!d] = a;
        self.cll[a][d] = b;
    }

    // Insert node `b` beside existing node `a` in direction `d`.
    function insert(LL storage self, bytes32 a, bytes32 b, bool d) internal {
        bytes32 c = self.cll[a][d];
        stitch (self, a, b, d);
        stitch (self, b, c, d);
    }
    
    // Remove node
    function remove(LL storage self, bytes32 n) internal returns (bytes32) {
        if (n == NULL) return;
        stitch(self, self.cll[n][PREV], self.cll[n][NEXT], NEXT);
        delete self.cll[n][PREV];
        delete self.cll[n][NEXT];
        return n;
    }

    // Push a new node before or after the head
    function push(LL storage self, bytes32 n, bool d) internal {
        insert(self, HEAD, n, d);
    }
    
    // Pop a new node from before or after the head
    function pop(LL storage self, bool d) internal returns (bytes32) {
        return remove(self, step(self, HEAD, d));
    }
}