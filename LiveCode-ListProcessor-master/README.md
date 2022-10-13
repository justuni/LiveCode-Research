# LiveCode-ListProcessor

Simple list processing - first, last, next, prior, head, tail, ahead, behind, peek, poke, remove, append, insert, etc..

The current implementation of ListProcessor uses LiveCode arrays to store a list and its index. The design and code have not been optimised in anyway. My first objective is to get basic list processing working and then to improve on it. 

## Currently implemented functions

### LP.makeList
This function creates a list. A variable in which to "put" the created list.
```
  arguments
    pStringList     The items to put in the list
    pDelimiter      The separator used in the string between items in the list
  returns           The list or empty
```

### LP.ahead
Returns the next item in the list from the current index or empty if the index is at the tail of the list.
```
  argument
    pList         The list
  returns         The next item in the list or empty
```

### LP.append
Appends an item to the end of the list and returns the appended item
```
  arguments
    pList         The list
    pVal          The value
  returns         The first item in the list or empty
```

### LP.behind 
Returns the previous item in the list or empty if the list is at its head
```
  argument
    pList         The list
  returns         The previous item in the list or empty
```

### LP.copy
Returns a copy of the complete list
```
  argument
    pList         The list
  returns         A copy of the list
```

### LP.copyToTail
Returns a copy of the list from the current index
```
  argument
    pList         The list
  returns         A copy of the list from the current index
```

### LP.clear
Empties a list and returns the empty list or empty
```
  arguments
    pList         The list
  returns         The emptied list
```

### LP.detachLast
Removes the last item in the list and returns that item or empty
```
  argument
    pList         The list
  returns         The removed item or empty
```

### LP.first
Returns the item at the current index or empty
```
  argument
    pList         The list
  returns         The item at the current index or empty
```

### LP.head
Sets the index to the first item and returns the first item
```
  argument
    pList         The list
  returns         The first item in the list or empty
```

### LP.index
Returns the value of the current index
```
  argument
    pList         The list
  returns         The value of the current index
```

### LP.insert
Inserts an item at the current index and returns the inserted item
```
  arguments
    pList         The list
    pVal          The value
  returns         The inserted item in the list or empty
```

### LP.isAtHead
Returns true if the index is set to the first item in the list
```
  argument
    pList         The list
  returns         True or false
```
### LP.isAtTail
Returns true if the index is set to the last item in the list
```
  argument
    pList         The list
  returns         True or false
```
### LP.isEmpty
Returns true if the list is empty
```
  argument
    pList         The list
  returns         True or false
```

### LP.last
Returns the item at the tail of the list or empty
```
  argument
    pList         The list
  returns         The item at the tail of the list or empty
```
### LP.load
Loads a saved list from a URL and returns the restored list
```
  argument
    pURL          The URL
  returns         The List
```

### LP.length
Returns the number of items in the list based on the current index
```
  argument
    pList         The list
  returns         The number of items in the list from the current index
```

### LP.next
Moves to the next item in the list and returns that item or empty
```
  argument
    pList         The list
  returns         The now first item or empty
```
### LP.peek
Returns the nth item based on the current index
```
  arguments
    pList         The list
    pPos          The position of the element requested
  returns         The item or empty
```

### LP.poke
Replaces the nth item based on the current index with the supplied value
```
  arguments
    pList         The list
    pPos          The position of the element requested
    pVal          The value to be poked into the list
  returns         The item or empty
```
  
### LP.prior
Moves to the prior item in the list and returns that item or empty
```
  argument
    pList         The list
  returns         The now first item or empty
```

### LP.remove
Removes the item at the current index and returns the removed item
```
  argument
    pList         The list
  returns         The removed item or empty
```

### LP.save
Saves the list and returns an arrayEncoded copy of the list
```
  arguments
    pList         The list
    pURL          The URL
  returns         An arrayEncoded copy of the list
```

### LP.tail
Sets the index to the last item and returns the last item
```
  argument
    pList         The list
  returns         The last item in the list or empty
```
