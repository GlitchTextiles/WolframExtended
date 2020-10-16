class Register {

  BitSet bits;
  private int nBits;

  Register(int _length) {
    bits = new BitSet(_length);
    nBits = _length;
  }

  void debug() {
    print("bits: ");
    for (int i = nBits - 1; i >= 0; i--) {
      print(int(bits.get(i)));
    }
    println();
  }

  BitSet rev() {
    BitSet temp = new BitSet(nBits);
    for (int i = 0; i < this.size(); i++) {
      temp.set((this.size()-1) - i, bits.get(i));
    }
    bits = temp;
    return bits;
  }

  BitSet inv() {
    for (int i = 0; i < this.size(); i++) {
      bits.set(i, !bits.get(i));
    }
    return bits;
  }

  BitSet shiftLeft() {
    BitSet temp = new BitSet(nBits);
    for (int i = 0; i < this.size()-1; i++) {
      temp.set(i-1, bits.get(i));
    }
    bits = temp;
    return bits;
  }

  BitSet shiftLeft(boolean _input) {
    BitSet temp = new BitSet(this.size());
    temp.set(0, _input);
    for (int i = 0; i < this.size()-1; i++) {
      temp.set(i+1, bits.get(i));
    }
    bits = temp;
    return bits;
  }

  BitSet shiftRight() {
    BitSet temp = new BitSet(this.size());
    for (int i = 0; i < this.size()-1; i++) {
      temp.set(i, bits.get((i+1)));
    }
    bits=temp;
    return bits;
  }

  BitSet shiftRight(boolean _input) {
    BitSet temp = new BitSet(this.size());
    for (int i = 0; i < this.size()-1; i++) {
      temp.set(i, bits.get((i+1)));
    }
    temp.set(this.size()-1, _input);
    bits=temp;
    return bits;
  }

  BitSet inc() {
    boolean carry = false;
    for (int i = 0; i < this.size(); i++) {
      if (i == 0) {
        if (bits.get(i)) {
          bits.set(i, false);
          carry=true;
        } else {
          bits.set(i, true);
        }
      } else {
        if (carry) {
          if (bits.get(i)) {
            bits.set(i, false);
            carry=true;
          } else {
            bits.set(i, true);
            carry=false;
          }
        } else {
          break;
        }
      }
    }
    return bits;
  }

  BitSet dec() {
    boolean carry = false;
    for (int i = 0; i < this.size(); i++) {
      if (i == 0) {
        if (bits.get(i)) {
          bits.set(i, false);
        } else {
          bits.set(i, true);
          carry=true;
        }
      } else {
        if (carry) {
          if (bits.get(i)) {
            bits.set(i, false);
            carry=false;
          } else {
            bits.set(i, true);
            carry=true;
          }
        } else {
          break;
        }
      }
    }
    return bits;
  }

  void randomize() {
    for (int i = 0; i < this.size(); i++) {
      bits.set(i, random(1) < 0.5 );
    }
  }

  int size() {
    return nBits;
  }

  boolean get(int _i) {
    return bits.get(_i);
  }

  BitSet get() {
    return bits;
  }

  void set(int _i, boolean _value) {
    bits.set(_i, _value);
  }

  void set(BitSet _bits) {
    bits = _bits;
  }

  void clear() {
    bits.clear();
  }

  String toString() {
    String _theRule = new String();
    for (int i = bits.size()-1; i >= 0; i--) {
      _theRule += int(bits.get(i));
    }
    return _theRule;
  }
}
