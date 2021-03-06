// RUN: %target-parse-verify-swift

func f0(x: Int, y: Int, z: Int) { }
func f1(x: Int, while: Int) { }
func f2(x: Int, `let` _: Int) { }

func test01() {
  _ = f0(_:y:z:)
  _ = f0(:y:z:) // expected-error{{an empty argument label is spelled with '_'}}{{10-10=_}}
  _ = f1(_:`while`:) // expected-warning{{keyword 'while' does not need to be escaped in argument list}}{{12-13=}}{{18-19=}}
  _ = f2(_:`let`:)
}

struct S0 {
  func f0(x: Int, y: Int, z: Int) { }
  func f1(x: Int, while: Int) { }
  func f2(x: Int, `let` _: Int) { }

  func testS0() {
    _ = f0(_:y:z:)
    _ = f0(:y:z:) // expected-error{{an empty argument label is spelled with '_'}}{{12-12=_}}
    _ = f1(_:`while`:) // expected-warning{{keyword 'while' does not need to be escaped in argument list}}{{14-15=}}{{20-21=}}
    _ = f2(_:`let`:)
    
    _ = self.f0(_:y:z:)
    _ = self.f0(:y:z:) // expected-error{{an empty argument label is spelled with '_'}}{{17-17=_}}
    _ = self.f1(_:`while`:) // expected-warning{{keyword 'while' does not need to be escaped in argument list}}{{19-20=}}{{25-26=}}
    _ = self.f2(_:`let`:)
  }

  static func f3(x: Int, y: Int, z: Int) -> S0 { return S0() }
}

// Determine context from type.
let s0_static: S0 = .f3(_:y:z:)(0, y: 0, z: 0)

class C0 {
  init(x: Int, y: Int, z: Int) { }

  convenience init(all: Int) {
    self.init(x:y:z:)(x: all, y: all, z: all)
  }

  func f0(x: Int, y: Int, z: Int) { }
  func f1(x: Int, while: Int) { }
  func f2(x: Int, `let` _: Int) { }
}

class C1 : C0 {
  init(all: Int) {
    super.init(x:y:z:)(x: all, y: all, z: all)
  }

  func testC0() {
    _ = f0(_:y:z:)
    _ = f0(:y:z:) // expected-error{{an empty argument label is spelled with '_'}}{{12-12=_}}
    _ = f1(_:`while`:) // expected-warning{{keyword 'while' does not need to be escaped in argument list}}{{14-15=}}{{20-21=}}
    _ = f2(_:`let`:)
    
    _ = super.f0(_:y:z:)
    _ = super.f0(:y:z:) // expected-error{{an empty argument label is spelled with '_'}}{{18-18=_}}
    _ = super.f1(_:`while`:) // expected-warning{{keyword 'while' does not need to be escaped in argument list}}{{20-21=}}{{26-27=}}
    _ = self.f2(_:`let`:)
  }
}

