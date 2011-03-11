#
#
#            Nimrod's Runtime Library
#        (c) Copyright 2011 Tom Krauss
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#
##
## This module contains functions for list processing.
##


proc all*[T](List: openarray[T], F: proc (x: T): bool): bool =
  ## Returns true if `F(Elem)` returns true for all elements `Elem`
  ## in `List`, otherwise false.
  result = true
  for x in items(List):
    if not F(x):
      result = false
      break


proc any*[T](List: openarray[T], F: proc (x: T): bool): bool = 
  ## Returns true if `F(Elem)` returns true for any element `Elem` in 
  ## `List`, otherwise false.
  result = false
  for x in items(List):
    if F(x):
      result = true
      break


proc dropwhile*[T](List: openarray[T], F: proc (x: T): bool): seq[T] =
  ## Drops elements `Elem` from `List` while `F(Elem)` returns true and 
  ## returns the remaining list.
  result = @[]
  for x in items(List):
    if not F(x):
      result.add(x)


proc duplicate*[T](Elem: T, N: int): seq[T] =
  ## Returns a list which contains `N` copies of the term `Elem`.
  result.newSeq(N)
  for i in 0..N-1:
    result[i] = Elem


proc filter*[T](List: openarray[T], F: proc (x: T): bool): seq[T] =
  ## Returns the list of all elements `Elem` in `List` for which `F(Elem)`
  ## returns true.
  result = @[]
  for x in items(List):
    if F(x):
      result.add(x)


proc fold*[T](List: openarray[T], F: proc (x: T, y: T): T, Acc0: T): T =
  ## Calls `F(Elem, Acc)` on successive elements A of List, starting with 
  ## Acc == Acc0. `F` must return a new accumulator which is passed to the 
  ## next call. The function returns the final value of the accumulator.
  ## `Acc0` is returned if the list is empty.
  result = Acc0
  for x in items(List):
    result = F(x,result)


proc last*[T](List: openarray[T]): T =
  ## Returns the last element in `List`.
  result = List[len(List)-1]


proc nth*[T](List: openarray[T], N: int): T =
  ## Returns the element at the Nth position in `List`.  Elements are numbered starting at 1.
  result = List[N-1]


proc nthtail*[T](List: openarray[T], N: int): seq[T] =
  ## Returns the Nth tail of `List`, that is, the sublist of `List` starting 
  ## at position N+1 and continuing up to the end of the list.
  result = @[]
  for i in N..len(List)-1:
    result.add(List[i])


proc partition*[T](List: openarray[T], F: proc (x: T): bool): array[0..1, seq[T]] =
  ## Partitions `List` into two lists, where the first list contains all elements for 
  ## which `F(Elem)` returns true, and the second list contains all elements for which
  ## `F(Elem)` returns false.
  result[0] = @[]
  result[1] = @[]
  for x in items(List):
    if F(x):
      result[0].add(x)
    else:
      result[1].add(x)


proc reverse*[T](List: openarray[T]): seq[T] =
  ## Returns a list with the elements in `List` in reverse order.
  result.newSeq(len(List))
  var N = len(List)
  for i in 0..N-1:
    result[i] = List[N-1-i]


proc sequence*[T](Start: T, Stop: T, Increment: T): seq[T] =
  ## Returns a sequence of values which starts with `Start` and contains the
  ## successive results of adding `Increment` to the previous element, until 
  ## `Stop` has been reached or passed (in the latter case, `Stop` is not an
  ## element of the sequence).
  result = @[]
  result.add(Start)
  var current = Start
  while current+Increment <= Stop:
    current = current + Increment
    result.add(current)


proc split*[T](List: openarray[T], N: int): array[0..1, seq[T]] =
  ## Splits List into two lists. The first returned list contains the first
  ## `N` elements while the second list contains the rest of the elements
  ## (the Nth tail).
  result[0] = @[]
  result[1] = @[]
  for i in 0..N-1:
    result[0].add(List[i])
  for i in N..len(List)-1:
    result[1].add(List[i])


proc sort*[T](List: openarray[T], compare: proc (a:T, b:T):bool): seq[T] =
  ## Returns a list containing the sorted elements of `List`, according to the 
  ## ordering function `compare`. `compare(A, B)` should return true if A compares 
  ## less than or equal to B in the ordering, false otherwise.
  if len(list) < 1:
    result = @[]
  else:
    # select and remove a pivot value from array
    var less, greater: seq[T] = @[]
    var pivotIndex = len(list)/%2
    var pivot = list[pivotIndex]
    
    # Check all the indices below the pivot
    for i in 0..pivotIndex-1:
      if compare(list[i],pivot): less.add(list[i])
      else:               greater.add(list[i])
    # Check all the values above the pivot
    for i in pivotIndex+1..len(list)-1:
      if compare(list[i],pivot): less.add(list[i])
      else:               greater.add(list[i])

    result = sort(less,compare) & pivot & sort(greater,compare)


proc sum*[T](List: openarray[T]): T =
  ## Returns the sum of the elements in `List`.
  result = List[0]
  for i in 1..len(List)-1:
    result = result + List[i]


proc takewhile*[T](List: openarray[T], F: proc (x: T): bool ): seq[T] =
  ## Takes elements `Elem` from `List` while `F(Elem)` returns true, that is,
  ## the function returns the longest prefix of the list for which all elements 
  ## satisfy `F`.
  result = @[]
  for i in 0..len(List)-1:
    if F(List[i]):
      result.add(List[i])
    else:
      break


proc zip*[T,U](List1: openarray[T], List2: openarray[U]): seq[ tuple[a: T, b: U] ] =
  ## "Zips" two lists of equal length into one list of two-tuples, where the first
  ## element of each tuple is taken from the `List1` and the second element is
  ## taken from corresponding element in 'List2`.
  result = @[]
  for i in 0..len(List1)-1:
    result.add( (List1[i], List2[i]) )



when isMainModule:
  proc sum(x: int, y: int): int = return x + y
  proc prod(x: int, y: int): int = return x * y
  proc cmpGT0(x: int): bool = return (x>0)
  proc cmpLT0(x: int): bool = return (x<0)
  proc cmp(a: int, b: int): bool = return(a<b)


  var x  = [1,2,3,4,5]
  var y  = [-2,-1,0,1,2]
  var z  = [1,-3,4,1,8,-1]
  var z2 = ['a','b','c','d','e','f']
  
  assert( all(x, cmpGT0) )
  assert( not all(x, cmpLT0) )
  assert( any(x, cmpGT0) )
  assert( not any(x, cmpLT0) )
  assert( sum(x) == 15 )
  assert( fold(x,sum,0) == 15 )
  assert( fold(x,prod,1) == 120 )

  assert( not all(y, cmpGT0) )
  assert( not all(y, cmpLT0) )
  assert( any(y, cmpGT0) )
  assert( any(y, cmpLT0) )
  assert( dropwhile(y,cmpLT0) == @[0,1,2] )
  assert( filter(y,cmpLT0) == @[-2,-1] )
  assert( reverse(y) == @[2,1,0,-1,-2] )
  assert( takewhile(y,cmpLT0) == @[-2,-1] )
  assert( last(y) == 2 )
  assert( nth(y,3) == 0 )
  assert( nthtail(y,3) == @[1,2] )
  var res = partition(y,cmpLT0)
  assert( res[0] == @[-2,-1] )
  assert( res[1] == @[0,1,2] )
  var res2 = split(y,3)
  assert( res2[0] == @[-2,-1,0] )
  assert( res2[1] == @[1,2] )

  #assert( zip(z,z2) == @[(1,'a'), (-3,'b'), (4,'c'), (1,'d'), (8,'e'), (-1,'f')] )    
  assert( sort(z,cmp) == @[-3,-1,1,1,4,8] )
  
  assert( duplicate(10,5) == @[10,10,10,10,10] )
  assert( sequence(5,10,2) == @[5,7,9] )
  
