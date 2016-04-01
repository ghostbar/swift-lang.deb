// RUN: %target-swift-frontend -emit-silgen %s | FileCheck %s

func foo(var x: Int) -> () -> Int {
  return { x }
}
// CHECK-LABEL: sil shared @_TFF19capture_typed_boxes3fooFSiFT_SiU_FT_Si : $@convention(thin) (@owned @box Int) -> Int {
// CHECK:       bb0(%0 : $@box Int):

func closure(var f: Int -> Int) -> Int {
  func bar(x: Int) -> Int {
    return f(x)
  }

  return bar(0)
}
// CHECK-LABEL: sil shared @_TFF19capture_typed_boxes7closureFFSiSiSiL_3barfSiSi : $@convention(thin) (Int, @owned @box @callee_owned (Int) -> Int) -> Int {
// CHECK:       bb0(%0 : $Int, %1 : $@box @callee_owned (Int) -> Int):

func closure_generic<T>(var f: T -> T, x: T) -> T {
  func bar(x: T) -> T {
    return f(x)
  }

  return bar(x)
}
// CHECK-LABEL: sil shared @_TFF19capture_typed_boxes15closure_generic{{.*}} : $@convention(thin) <T> (@out T, @in T, @owned @box @callee_owned (@out T, @in T) -> ()) -> () {
// CHECK-LABEL: bb0(%0 : $*T, %1 : $*T, %2 : $@box @callee_owned (@out T, @in T) -> ()):
