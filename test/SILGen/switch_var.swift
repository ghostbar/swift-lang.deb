// RUN: %target-swift-frontend -emit-silgen %s | FileCheck %s

// TODO: Implement tuple equality in the library.
// BLOCKED: <rdar://problem/13822406>
func ~= (x: (Int, Int), y: (Int, Int)) -> Bool {
  return x.0 == y.0 && x.1 == y.1
}

// Some fake predicates for pattern guards.
func runced() -> Bool { return true }
func funged() -> Bool { return true }
func ansed() -> Bool { return true }

func runced(x x: Int) -> Bool { return true }
func funged(x x: Int) -> Bool { return true }
func ansed(x x: Int) -> Bool { return true }

func foo() -> Int { return 0 }
func bar() -> Int { return 0 }
func foobar() -> (Int, Int) { return (0, 0) }

func foos() -> String { return "" }
func bars() -> String { return "" }

func a() {}
func b() {}
func c() {}
func d() {}
func e() {}
func f() {}
func g() {}

func a(x x: Int) {}
func b(x x: Int) {}
func c(x x: Int) {}
func d(x x: Int) {}

func a(x x: String) {}
func b(x x: String) {}

func aa(x x: (Int, Int)) {}
func bb(x x: (Int, Int)) {}
func cc(x x: (Int, Int)) {}

// CHECK-LABEL: sil hidden @_TF10switch_var10test_var_1FT_T_
func test_var_1() {
  // CHECK:   function_ref @_TF10switch_var3fooFT_Si
  switch foo() {
  // CHECK:   [[XADDR:%.*]] = alloc_box $Int
  // CHECK-NOT: br
  case var x:
  // CHECK:   function_ref @_TF10switch_var1aFT1xSi_T_
  // CHECK:   load [[XADDR]]
  // CHECK:   release [[XADDR]]
  // CHECK:   br [[CONT:bb[0-9]+]]
    a(x: x)
  }
  // CHECK: [[CONT]]:
  // CHECK:   function_ref @_TF10switch_var1bFT_T_
  b()
}

// CHECK-LABEL: sil hidden @_TF10switch_var10test_var_2FT_T_
func test_var_2() {
  // CHECK:   function_ref @_TF10switch_var3fooFT_Si
  switch foo() {
  // CHECK:   [[XADDR:%.*]] = alloc_box $Int
  // CHECK:   function_ref @_TF10switch_var6runcedFT1xSi_Sb
  // CHECK:   load [[XADDR]]
  // CHECK:   cond_br {{%.*}}, [[CASE1:bb[0-9]+]], [[NO_CASE1:bb[0-9]+]]
  // -- TODO: Clean up these empty waypoint bbs.
  case var x where runced(x: x):
  // CHECK: [[CASE1]]:
  // CHECK:   function_ref @_TF10switch_var1aFT1xSi_T_
  // CHECK:   load [[XADDR]]
  // CHECK:   release [[XADDR]]
  // CHECK:   br [[CONT:bb[0-9]+]]
    a(x: x)
  // CHECK: [[NO_CASE1]]:
  // CHECK:   [[YADDR:%.*]] = alloc_box $Int
  // CHECK:   function_ref @_TF10switch_var6fungedFT1xSi_Sb
  // CHECK:   load [[YADDR]]
  // CHECK:   cond_br {{%.*}}, [[CASE2:bb[0-9]+]], [[NO_CASE2:bb[0-9]+]]
  case var y where funged(x: y):
  // CHECK: [[CASE2]]:
  // CHECK:   function_ref @_TF10switch_var1bFT1xSi_T_
  // CHECK:   load [[YADDR]]
  // CHECK:   release [[YADDR]]
  // CHECK:   br [[CONT]]
    b(x: y)
  // CHECK: [[NO_CASE2]]:
  // CHECK:   br [[CASE3:bb[0-9]+]]
  case var z:
  // CHECK: [[CASE3]]:
  // CHECK:   [[ZADDR:%.*]] = alloc_box $Int
  // CHECK:   function_ref @_TF10switch_var1cFT1xSi_T_
  // CHECK:   load [[ZADDR]]
  // CHECK:   release [[ZADDR]]
  // CHECK:   br [[CONT]]
    c(x: z)
  }
  // CHECK: [[CONT]]:
  // CHECK:   function_ref @_TF10switch_var1dFT_T_
  d()
}

// CHECK-LABEL: sil hidden  @_TF10switch_var10test_var_3FT_T_
func test_var_3() {
  // CHECK:   function_ref @_TF10switch_var3fooFT_Si
  // CHECK:   function_ref @_TF10switch_var3barFT_Si
  switch (foo(), bar()) {
  // CHECK:   [[XADDR:%.*]] = alloc_box $(Int, Int)
  // CHECK:   function_ref @_TF10switch_var6runcedFT1xSi_Sb
  // CHECK:   tuple_element_addr [[XADDR]]#1 : {{.*}}, 0
  // CHECK:   cond_br {{%.*}}, [[CASE1:bb[0-9]+]], [[NO_CASE1:bb[0-9]+]]
  case var x where runced(x: x.0):
  // CHECK: [[CASE1]]:
  // CHECK:   function_ref @_TF10switch_var2aaFT1xTSiSi__T_
  // CHECK:   load [[XADDR]]
  // CHECK:   release [[XADDR]]
  // CHECK:   br [[CONT:bb[0-9]+]]
    aa(x: x)
  // CHECK: [[NO_CASE1]]:
  // CHECK:   [[YADDR:%.*]] = alloc_box $Int
  // CHECK:   [[Z:%.*]] = alloc_box $Int
  // CHECK:   function_ref @_TF10switch_var6fungedFT1xSi_Sb
  // CHECK:   load [[YADDR]]
  // CHECK:   cond_br {{%.*}}, [[CASE2:bb[0-9]+]], [[NO_CASE2:bb[0-9]+]]
  case (var y, var z) where funged(x: y):
  // CHECK: [[CASE2]]:
  // CHECK:   function_ref @_TF10switch_var1aFT1xSi_T_
  // CHECK:   load [[YADDR]]
  // CHECK:   function_ref @_TF10switch_var1bFT1xSi_T_
  // CHECK:   load [[Z]]
  // CHECK:   release [[ZADDR]]
  // CHECK:   release [[YADDR]]
  // CHECK:   br [[CONT]]
    a(x: y)
    b(x: z)
  // CHECK: [[NO_CASE2]]:
  // CHECK:   [[WADDR:%.*]] = alloc_box $(Int, Int)
  // CHECK:   function_ref @_TF10switch_var5ansedFT1xSi_Sb
  // CHECK:   tuple_element_addr [[WADDR]]#1 : {{.*}}, 0
  // CHECK:   cond_br {{%.*}}, [[CASE3:bb[0-9]+]], [[NO_CASE3:bb[0-9]+]]
  case var w where ansed(x: w.0):
  // CHECK: [[CASE3]]:
  // CHECK:   function_ref @_TF10switch_var2bbFT1xTSiSi__T_
  // CHECK:   load [[WADDR]]
  // CHECK:   br [[CONT]]
    bb(x: w)
  // CHECK: [[NO_CASE3]]:
  // CHECK:   release [[WADDR]]
  // CHECK:   br [[CASE4:bb[0-9]+]]
  case var v:
  // CHECK: [[CASE4]]:
  // CHECK:   [[VADDR:%.*]] = alloc_box $(Int, Int) 
  // CHECK:   function_ref @_TF10switch_var2ccFT1xTSiSi__T_
  // CHECK:   load [[VADDR]]
  // CHECK:   release [[VADDR]]
  // CHECK:   br [[CONT]]
    cc(x: v)
  }
  // CHECK: [[CONT]]:
  // CHECK:   function_ref @_TF10switch_var1dFT_T_
  d()
}

protocol P { func p() }

struct X : P { func p() {} }
struct Y : P { func p() {} }
struct Z : P { func p() {} }

// CHECK-LABEL: sil hidden  @_TF10switch_var10test_var_4FT1pPS_1P__T_
func test_var_4(p p: P) {
  // CHECK:   function_ref @_TF10switch_var3fooFT_Si
  switch (p, foo()) {
  // CHECK:   [[PAIR:%.*]] = alloc_stack $(P, Int)
  // CHECK:   store
  // CHECK:   [[PAIR_0:%.*]] = tuple_element_addr [[PAIR]] : $*(P, Int), 0
  // CHECK:   [[T0:%.*]] = tuple_element_addr [[PAIR]] : $*(P, Int), 1
  // CHECK:   [[PAIR_1:%.*]] = load [[T0]] : $*Int
  // CHECK:   [[TMP:%.*]] = alloc_stack $X
  // CHECK:   checked_cast_addr_br copy_on_success P in [[PAIR_0]] : $*P to X in [[TMP]] : $*X, [[IS_X:bb[0-9]+]], [[IS_NOT_X:bb[0-9]+]]

  // CHECK: [[IS_X]]:
  // CHECK:   [[T0:%.*]] = load [[TMP]] : $*X
  // CHECK:   [[XADDR:%.*]] = alloc_box $Int
  // CHECK:   store [[PAIR_1]] to [[XADDR]]
  // CHECK:   function_ref @_TF10switch_var6runcedFT1xSi_Sb
  // CHECK:   load [[XADDR]]
  // CHECK:   cond_br {{%.*}}, [[CASE1:bb[0-9]+]], [[NO_CASE1:bb[0-9]+]]
  case (is X, var x) where runced(x: x):
  // CHECK: [[CASE1]]:
  // CHECK:   function_ref @_TF10switch_var1aFT1xSi_T_
  // CHECK:   release [[XADDR]]
  // CHECK:   dealloc_stack [[TMP]]
  // CHECK:   destroy_addr [[PAIR_0]] : $*P
  // CHECK:   dealloc_stack [[PAIR]]
  // CHECK:   br [[CONT:bb[0-9]+]]
    a(x: x)

  // CHECK: [[NO_CASE1]]:
  // CHECK:   release [[XADDR]]
  // CHECK:   dealloc_stack [[TMP]]
  // CHECK:   br [[NEXT:bb[0-9]+]]
  // CHECK: [[IS_NOT_X]]:
  // CHECK:   dealloc_stack [[TMP]]
  // CHECK:   br [[NEXT]]

  // CHECK: [[NEXT]]:
  // CHECK:   [[TMP:%.*]] = alloc_stack $Y
  // CHECK:   checked_cast_addr_br copy_on_success P in [[PAIR_0]] : $*P to Y in [[TMP]] : $*Y, [[IS_Y:bb[0-9]+]], [[IS_NOT_Y:bb[0-9]+]]

  // CHECK: [[IS_Y]]:
  // CHECK:   [[T0:%.*]] = load [[TMP]] : $*Y
  // CHECK:   [[YADDR:%.*]] = alloc_box $Int
  // CHECK:   store [[PAIR_1]] to [[YADDR]]
  // CHECK:   function_ref @_TF10switch_var6fungedFT1xSi_Sb
  // CHECK:   load [[YADDR]]
  // CHECK:   cond_br {{%.*}}, [[CASE2:bb[0-9]+]], [[NO_CASE2:bb[0-9]+]]

  case (is Y, var y) where funged(x: y):
  // CHECK: [[CASE2]]:
  // CHECK:   function_ref @_TF10switch_var1bFT1xSi_T_
  // CHECK:   load [[YADDR]]
  // CHECK:   release [[YADDR]]
  // CHECK:   dealloc_stack [[TMP]]
  // CHECK:   destroy_addr [[PAIR_0]] : $*P
  // CHECK:   dealloc_stack [[PAIR]]
  // CHECK:   br [[CONT]]
    b(x: y)

  // CHECK: [[NO_CASE2]]:
  // CHECK:   release [[YADDR]]
  // CHECK:   dealloc_stack [[TMP]]
  // CHECK:   br [[NEXT:bb[0-9]+]]
  // CHECK: [[IS_NOT_Y]]:
  // CHECK:   dealloc_stack [[TMP]]
  // CHECK:   br [[NEXT]]

  // CHECK: [[NEXT]]:
  // CHECK:   [[ZADDR:%.*]] = alloc_box $(P, Int)
  // CHECK:   function_ref @_TF10switch_var5ansedFT1xSi_Sb
  // CHECK:   tuple_element_addr [[ZADDR]]#1 : {{.*}}, 1
  // CHECK:   cond_br {{%.*}}, [[CASE3:bb[0-9]+]], [[DFLT_NO_CASE3:bb[0-9]+]]
  case var z where ansed(x: z.1):
  // CHECK: [[CASE3]]:
  // CHECK:   function_ref @_TF10switch_var1cFT1xSi_T_
  // CHECK:   tuple_element_addr [[ZADDR]]#1 : {{.*}}, 1
  // CHECK:   release [[ZADDR]]
  // CHECK-NEXT: dealloc_stack [[PAIR]]
  // CHECK:   br [[CONT]]
    c(x: z.1)

  // CHECK: [[DFLT_NO_CASE3]]:
  // CHECK:   release [[ZADDR]]
  // CHECK:   br [[CASE4:bb[0-9]+]]
  case (_, var w):
  // CHECK: [[CASE4]]:
  // CHECK:   [[PAIR_0:%.*]] = tuple_element_addr [[PAIR]] : $*(P, Int), 0
  // CHECK:   [[WADDR:%.*]] = alloc_box $Int
  // CHECK:   function_ref @_TF10switch_var1dFT1xSi_T_
  // CHECK:   load [[WADDR]]
  // CHECK:   release [[WADDR]]
  // CHECK:   destroy_addr [[PAIR_0]] : $*P
  // CHECK:   dealloc_stack [[PAIR]]
  // CHECK:   br [[CONT]]
    d(x: w)
  }
  e()
}

// CHECK-LABEL: sil hidden @_TF10switch_var10test_var_5FT_T_ : $@convention(thin) () -> () {
func test_var_5() {
  // CHECK:   function_ref @_TF10switch_var3fooFT_Si
  // CHECK:   function_ref @_TF10switch_var3barFT_Si
  switch (foo(), bar()) {
  // CHECK:   [[XADDR:%.*]] = alloc_box $(Int, Int)
  // CHECK:   cond_br {{%.*}}, [[CASE1:bb[0-9]+]], [[NO_CASE1:bb[0-9]+]]
  case var x where runced(x: x.0):
  // CHECK: [[CASE1]]:
  // CHECK:   br [[CONT:bb[0-9]+]]
    a()
  // CHECK: [[NO_CASE1]]:
  // CHECK:   [[YADDR:%[0-9]+]] = alloc_box $Int
  // CHECK:   [[ZADDR:%[0-9]+]] = alloc_box $Int
  // CHECK:   cond_br {{%.*}}, [[CASE2:bb[0-9]+]], [[NO_CASE2:bb[0-9]+]]
  case (var y, var z) where funged(x: y):
  // CHECK: [[CASE2]]:
  // CHECK:   release [[ZADDR]]
  // CHECK:   release [[YADDR]]
  // CHECK:   br [[CONT]]
    b()
  // CHECK: [[NO_CASE2]]:
  // CHECK:   release [[ZADDR]]
  // CHECK:   release [[YADDR]]
  // CHECK:   cond_br {{%.*}}, [[CASE3:bb[0-9]+]], [[NO_CASE3:bb[0-9]+]]
  case (_, _) where runced():
  // CHECK: [[CASE3]]:
  // CHECK:   br [[CONT]]
    c()
  // CHECK: [[NO_CASE3]]:
  // CHECK:   br [[CASE4:bb[0-9]+]]
  case _:
  // CHECK: [[CASE4]]:
  // CHECK:   br [[CONT]]
    d()
  }
  // CHECK: [[CONT]]:
  e()
}

// CHECK-LABEL: sil hidden @_TF10switch_var15test_var_returnFT_T_ : $@convention(thin) () -> () {
func test_var_return() {
  switch (foo(), bar()) {
  case var x where runced():
    // CHECK: [[XADDR:%[0-9]+]] = alloc_box $(Int, Int)
    // CHECK: function_ref @_TF10switch_var1aFT_T_
    // CHECK: release [[XADDR]]
    // CHECK: br [[EPILOG:bb[0-9]+]]
    a()
    return
  // CHECK: [[YADDR:%[0-9]+]] = alloc_box $Int
  // CHECK: [[ZADDR:%[0-9]+]] = alloc_box $Int
  case (var y, var z) where funged():
    // CHECK: function_ref @_TF10switch_var1bFT_T_
    // CHECK: release [[ZADDR]]
    // CHECK: release [[YADDR]]
    // CHECK: br [[EPILOG]]
    b()
    return
  case var w where ansed():
    // CHECK: [[WADDR:%[0-9]+]] = alloc_box $(Int, Int)
    // CHECK: function_ref @_TF10switch_var1cFT_T_
    // CHECK-NOT: release [[ZADDR]]
    // CHECK-NOT: release [[YADDR]]
    // CHECK: release [[WADDR]]
    // CHECK: br [[EPILOG]]
    c()
    return
  case var v:
    // CHECK: [[VADDR:%[0-9]+]] = alloc_box $(Int, Int)
    // CHECK: function_ref @_TF10switch_var1dFT_T_
    // CHECK-NOT: release [[ZADDR]]
    // CHECK-NOT: release [[YADDR]]
    // CHECK: release [[VADDR]]
    // CHECK: br [[EPILOG]]
    d()
    return
  }
}

// When all of the bindings in a column are immutable, don't emit a mutable
// box. <rdar://problem/15873365>
// CHECK-LABEL: sil hidden @_TF10switch_var8test_letFT_T_ : $@convention(thin) () -> () {
func test_let() {
  // CHECK: [[FOOS:%.*]] = function_ref @_TF10switch_var4foosFT_SS
  // CHECK: [[VAL:%.*]] = apply [[FOOS]]()

  // CHECK: retain_value [[VAL]]
  // CHECK: function_ref @_TF10switch_var6runcedFT_Sb
  // CHECK: cond_br {{%.*}}, [[CASE1:bb[0-9]+]], [[NO_CASE1:bb[0-9]+]]
  switch foos() {
  case let x where runced():
    // CHECK: [[CASE1]]:
    // CHECK: [[A:%.*]] = function_ref @_TF10switch_var1aFT1xSS_T_
    // CHECK: retain_value [[VAL]]
    // CHECK: apply [[A]]([[VAL]])
    // CHECK: release_value [[VAL]]
    // CHECK: release_value [[VAL]]
    // CHECK: br [[CONT:bb[0-9]+]]
    a(x: x)
  // CHECK: [[NO_CASE1]]:
  // CHECK:   release_value [[VAL]]
  // CHECK:   br [[TRY_CASE2:bb[0-9]+]]
  // CHECK: [[TRY_CASE2]]:
  // CHECK:   retain_value [[VAL]]
  // CHECK:   function_ref @_TF10switch_var6fungedFT_Sb
  // CHECK:   cond_br {{%.*}}, [[CASE2:bb[0-9]+]], [[NO_CASE2:bb[0-9]+]]
  case let y where funged():
    // CHECK: [[CASE2]]:
    // CHECK: [[B:%.*]] = function_ref @_TF10switch_var1bFT1xSS_T_
    // CHECK: retain_value [[VAL]]
    // CHECK: apply [[B]]([[VAL]])
    // CHECK: release_value [[VAL]]
    // CHECK: release_value [[VAL]]
    // CHECK: br [[CONT]]
    b(x: y)
  // CHECK: [[NO_CASE2]]:
  // CHECK:   retain_value [[VAL]]
  // CHECK:   function_ref @_TF10switch_var4barsFT_SS
  // CHECK:   retain_value [[VAL]]
  // CHECK:   cond_br {{%.*}}, [[YES_CASE3:bb[0-9]+]], [[NO_CASE3:bb[0-9]+]]
  // CHECK: [[YES_CASE3]]:
  // CHECK:   release_value [[VAL]]
  // CHECK:   release_value [[VAL]]
  // ExprPatterns implicitly contain a 'let' binding.
  case bars():
    // CHECK:   function_ref @_TF10switch_var1cFT_T_
    // CHECK:   br [[CONT]]
    c()
  // CHECK: [[NO_CASE3]]:
  // CHECK:   release_value [[VAL]]
  // CHECK:   br [[LEAVE_CASE3:bb[0-9]+]]
  // CHECK: [[LEAVE_CASE3]]:
  case _:
    // CHECK:   release_value [[VAL]]
    // CHECK:   function_ref @_TF10switch_var1dFT_T_
    // CHECK:   br [[CONT]]
    d()
  }
  // CHECK: [[CONT]]:
  // CHECK:   return
}

// If one of the bindings is a "var", allocate a box for the column.
// CHECK-LABEL: sil hidden @_TF10switch_var18test_mixed_let_varFT_T_ : $@convention(thin) () -> () {
func test_mixed_let_var() {
  // CHECK: [[FOOS:%.*]] = function_ref @_TF10switch_var4foosFT_SS
  // CHECK: [[VAL:%.*]] = apply [[FOOS]]()
  switch foos() {
  case var x where runced():
    // CHECK: [[BOX:%.*]] = alloc_box $String, var, name "x"
    // CHECK: store [[VAL]] to [[BOX]]
    // CHECK: [[A:%.*]] = function_ref @_TF10switch_var1aFT1xSS_T_
    // CHECK: [[X:%.*]] = load [[BOX]]
    // CHECK: retain_value [[X]]
    // CHECK: apply [[A]]([[X]])
    a(x: x)
  case let y where funged():
    // CHECK: [[B:%.*]] = function_ref @_TF10switch_var1bFT1xSS_T_
    // CHECK: retain_value [[VAL]]
    // CHECK: apply [[B]]([[VAL]])
    b(x: y)
  case bars():
    c()
  case _:
    d()
  }
}
