# -*- coding: utf-8 -*-
$p = {}        #parent へのポインタ
$child = {}    #子へのポインタ
$left = {}     #左側の兄弟へのポインタ
$right = {}    #右側の兄弟へのポインタ
$degree = {}   #次数
$mark = {}     #接点の子になった後に子を失ったか？
$min = {}      #最小の接点を保持するポインタ
$n = {}        #接点数を保持するポインタ
$key = {}      #要素のキーを保持するポインタ


class FibHeap
end

def lg(a)
  Math.log(a)/Math.log(2) ;end

def maxd(n)
  lg(n).floor ;end

def node_list
  $key.keys.sort{|a,b| a.to_s <=> b.to_s}.each do |key|
    printf(":%s L: :%s  R: :%s  P: :%s  C: :%s \n",
           key, $left[key], $right[key], $p[key], $child[key])  end;end

def dump(x)
  tmphash = {}
  siblings(x).each do |sibling|
    tmphash[sibling] = nil
    children(sibling).each do |child|
      tmphash[sibling] = dump(child) ;end;end
  return tmphash  ;end

def make_node(x,key)
  $key[x] = key
  return x ;end

def children(x)
  children = []
  child = $child[x]

  if child != nil
    children = siblings(child) ;end

  return children ;end

def siblings(x)
  siblings = [x]
  left = $left[x]
  while(left != x)
    siblings << left
    left = $left[left] ;end
  return siblings ;end

def make_fib_heap
  h = FibHeap.new
  $min[h] = nil
  $n[h] = 0
  return h ;end

def concat_root_list(x,y)
  x_most_right = $left[x]
  x_most_left = x
  y_most_left = y
  y_most_right = $left[y]
  $left[x_most_left] = y_most_right
  $right[y_most_right] = x_most_left
  $right[x_most_right] = y_most_left
  $left[y_most_left] = x_most_right ;end

def add_root_list(y,x)
  y_most_left = y
  y_most_right = $left[y]
  $right[x] = y_most_left
  $left[y_most_left] = x
  $left[x] = y_most_right
  $right[y_most_right] = x ;end

def delete_from_root_list(x)
  left = $left[x]
  right = $right[x]
  $right[left] = right
  $left[right] = left ;end

def fib_heap_insert(h, x)
  $degree[x] = 0
  $p[x] = nil
  $child[x] = nil
  $left[x] = x
  $right[x] = x
  $mark[x] = false
  if $min[h] != nil then concat_root_list($min[h],x) end
  if $min[h] == nil or $key[x] < $key[$min[h]]
    then $min[h] = x   ;end
  $n[h] = $n[h] + 1    ;end

def fib_heap_minimum(h)
  return $min[h] ;end

def fib_heap_union(h1,h2)
  h = make_fib_heap
  $min[h] = $min[h1]
  concat_root_list($min[h],$min[h2])
  if ($min[h1] == nil) or ($min[h2] != nil and ($key[$min[h2]] < $key[$min[h1]]))
    then $min[h] = $min[h2] ;end
  $n[h] = $n[h1] + $n[h2]
  return h ;end

def fib_heap_extract_min(h)
  z = $min[h]
  if z != nil then
    for x in children(z) do
      add_root_list($min[h],x)
      $p[x] = nil  ;end
    delete_from_root_list(z)
    if z == $right[z] then
      $min[h] = nil
    else
      $min[h] = $right[z]
      consolidate(h) ;end
    $n[h] = $n[h] - 1 ;end
  return z ;end;

def consolidate(h)
  a = []
  0.upto(maxd($n[h])) do
    a << nil ;end
  for w in siblings($min[h]) do
    x = w
    d = $degree[x]
    while a[d] != nil do
      y = a[d]
      if $key[x] > $key[y] then
        x, y = y, x ;end
      fib_heap_link(h,y,x)
      a[d] = nil
      d = d + 1 ;end
    a[d] = x ;end
  $min[h] = nil
  0.upto(maxd($n[h])) do |i|
    if a[i] != nil then
      #concat_root_list($min[h],a[i]) if $min[h]
      if $min[h] == nil or $key[a[i]] < $key[$min[h]] then
        $min[h] = a[i]   ;end;end;end;end

def fib_heap_link(h,y,x)
  delete_from_root_list(y)
  fib_heap_add_child(x,y)
  $degree[x] = $degree[x] + 1
  $mark[y] = false ;end

def fib_heap_add_child(x,y)
  $left[y] = $right[y] = y
  if child = $child[x] then
    tmpleft = $left[child]
    $left[child] = y
    $right[y] = child
    $left[y] = tmpleft
    $right[tmpleft] = y
  else
    $child[x] = y ;end
  $p[y] = x ;end

def fib_heap_decrease_key(h,x,k)
  if k > $key[x]
    then rise "新しいキー値は現在のキー値より大きい" ;end
  $key[x] = k
  y = $p[x]
  if y != nil and $key[x] < $key[y] then
    cut(h,x,y)
    cascading_cut(h,y) ;end
  if $key[x] < $key[$min[h]]
    then $min[h] =x ;end;end

def cut(h,x,y)
  delete_from_children(x)
  $degree[y] = $degree[y] -1
  add_root_list($min[h],x);
  $p[x] = nil
  $mark[x] = false ;end

def delete_from_children(child)
  parent = $p[child]
  if $child[parent] == child #child ポインタが自分だったら
    if $left[child] != child
      $child[parent] = $left[child]
    else
      $child[parent] = nil ;end;end
  left = $left[child]
  right = $right[child]
  $right[left] = right
  $left[right] = left ;end

def cascading_cut(h,y)
  z = $p[y]
  if z != nil then
    if $mark[y] == false then
      $mark[y] = true
    else
      cut(h,y,z)
      cascading_cut(h,z) ;end;end;end

Infinit = 9999999999999999999999

def fib_heap_delete(h,x)
  fib_heap_decrease_key(h,x,-Infinit)
  fib_heap_extract_min(h) ;end

# H1 = make_fib_heap
# fib_heap_insert(H1,make_node(:a,1))
# fib_heap_insert(H1,make_node(:b,2))
# fib_heap_insert(H1,make_node(:c,3))
# p dump($min[H1])

# H2 = make_fib_heap
# fib_heap_insert(H2,make_node(:d,7))
# fib_heap_insert(H2,make_node(:e,8))
# fib_heap_insert(H2,make_node(:f,9))

# H = fib_heap_union(H1,H2)
# p dump($min[H])

# p fib_heap_extract_min(H)
# p dump($min[H])
# p $key

# fib_heap_decrease_key(H,:e,6)
# p dump($min[H])
# p $key
