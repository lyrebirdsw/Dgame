/*
 *******************************************************************************************
 * Dgame (a D game framework) - Copyright (c) Randy Schütt
 * 
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from
 * the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 
 * 1. The origin of this software must not be misrepresented; you must not claim
 *    that you wrote the original software. If you use this software in a product,
 *    an acknowledgment in the product documentation would be appreciated but is
 *    not required.
 * 
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 
 * 3. This notice may not be removed or altered from any source distribution.
 *******************************************************************************************
 */
module Dgame.Math.Vector2;

private {
	debug import std.stdio : writeln;
	import std.math : pow, sqrt, acos, PI;
	import std.traits : isNumeric;
}

/**
 * Vector2 is a structure that defines a two-dimensional point.
 *
 * Author: rschuett
 */
struct Vector2(T) if (isNumeric!T) {
	/**
	 * x coordinate
	 */
	T x = 0;
	/**
	 * y coordinate
	 */
	T y = 0;
	
	/**
	 * CTor
	 */
	this(T x, T y) pure nothrow {
		this.x = x;
		this.y = y;
	}
	
	/**
	 * CTor
	 */
	this(U)(U x, U y) pure nothrow if (isNumeric!U && !is(U : T)) {
		this(cast(T) x, cast(T) y);
	}
	
	/**
	 * CTor
	 */
	this(U)(U[2] pos) pure nothrow if (isNumeric!U) {
		this(pos[0], pos[1]);
	}
	
	/**
	 * CTor
	 */
	this(U)(ref const Vector2!U vec) pure nothrow {
		this(vec.x, vec.y);
	}
	
//	debug(Dgame)
//	this(this) {
//		writeln("Postblit Vector2");
//	}
	
	/**
	 * Supported operation: +=, -=, *=, /= and %=
	 */
	ref Vector2 opOpAssign(string op)(ref const Vector2 vec) pure {
		switch (op) {
			case "+":
				this.x += vec.x;
				this.y += vec.y;
				break;
			case "-":
				this.x -= vec.x;
				this.y -= vec.y;
				break;
			case "*":
				this.x *= vec.x;
				this.y *= vec.y;
				break;
			case "/":
				this.x /= vec.x;
				this.y /= vec.y;
				break;
			case "%":
				this.x %= vec.x;
				this.y %= vec.y;
				break;
			default: throw new Exception("Unsupported operator " ~ op);
		}
		
		return this;
	}
	
	/**
	 * Supported operation: +=, -=, *=, /= and %=
	 */
	ref Vector2 opOpAssign(string op)(T number) pure {
		switch (op) {
			case "+":
				this.x += number;
				this.y += number;
				break;
			case "-":
				this.x -= number;
				this.y -= number;
				break;
			case "*":
				this.x *= number;
				this.y *= number;
				break;
			case "/":
				this.x /= number;
				this.y /= number;
				break;
			case "%":
				this.x %= number;
				this.y %= number;
				break;
			default: throw new Exception("Unsupported operator " ~ op);
		}
		
		return this;
	}
	
	/**
	 * Supported operation: +, -, *, / and %
	 */
	Vector2 opBinary(string op)(ref const Vector2 vec) const pure {
		switch (op) {
			case "+": return Vector2(vec.x + this.x, vec.y + this.y);
			case "-": return Vector2(vec.x - this.x, vec.y - this.y);
			case "*": return Vector2(vec.x * this.x, vec.y * this.y);
			case "/": return Vector2(vec.x / this.x, vec.y / this.y);
			case "%": return Vector2(vec.x % this.x, vec.y % this.y);
			default: throw new Exception("Unsupported operator " ~ op);
		}
	}
	
	/**
	 * Supported operation: +, -, *, / and %
	 */
	Vector2 opBinary(string op)(T number) const pure {
		switch (op) {
			case "+": return Vector2(number + this.x, number + this.y);
			case "-": return Vector2(number - this.x, number - this.y);
			case "*": return Vector2(number * this.x, number * this.y);
			case "/": return Vector2(number / this.x, number / this.y);
			case "%": return Vector2(number % this.x, number % this.y);
			default: throw new Exception("Unsupported operator " ~ op);
		}
	}
	
	/**
	 * Returns a negated copy of this Vector.
	 */
	Vector2 opNeg() const pure nothrow {
		return Vector2(-this.x, -this.y);
	}
	
	/**
	 * Negate this Vector
	 */
	void negate() pure nothrow {
		this.x = -this.x;
		this.y = -this.y;
	}
	
	/**
	 * Compares two vectors by checking whether the coordinates are equals.
	 */
	bool opEquals(ref const Vector2 vec) const pure nothrow {
		return vec.x == this.x && vec.y == this.y;
	}

	/**
	 * Checks if this vector is empty. This means that his coordinates are 0.
	 */
	bool isEmpty() const pure nothrow {
		return this.x == 0 && this.y == 0;
	}
	
	/**
	 * Calculate the scalar product.
	 */
	float scalar(ref const Vector2 vec) const pure nothrow {
		return this.x * vec.x + this.y * vec.y;
	}
	
	/**
	 * alias for scalar
	 */
	alias dot = scalar;
	
	/**
	 * Calculate the length.
	 */
	@property
	float length() const pure nothrow {
		if (this.isEmpty())
			return 0f;
		
		return sqrt(pow(this.x, 2f) + pow(this.y, 2f));
	}
	
	/**
	 * Calculate the angle between two vectors.
	 * If the second paramter is true, the return value is converted to degrees.
	 * Otherwise, radiant is used.
	 */
	float angle(ref const Vector2 vec, bool degrees = true) const pure nothrow {
		float angle = acos(this.scalar(vec) / (this.length * vec.length));
		
		if (degrees)
			return angle * 180f / PI;
		
		return angle;
	}
	
	/**
	 * Calculate the diff between two vectors.
	 */
	float diff(ref const Vector2 vec) const pure nothrow {
		return sqrt(pow(this.x - vec.x, 2f) + pow(this.y - vec.y, 2f));
	}
	
	/**
	 * Normalize the vector in which the coordinates are divided by the length.
	 */
	ref Vector2 normalize() pure nothrow {
		const float len = this.length;
		if (len != 0) {
			this.x /= len;
			this.y /= len;
		}
		
		return this;
	}
	
	/**
	 * Set new coordinates.
	 */
	void set(T x, T y) pure nothrow {
		this.x = x;
		this.y = y;
	}
	
	/**
	 * Move the current coordinates.
	 */
	void move(T x, T y) pure nothrow {
		this.x += x;
		this.y += y;
	}
	
	/**
	 * Returns the Vector as static array.
	 */
	T[2] asArray() const pure nothrow {
		return [this.x, this.y];
	}
} unittest {
	Vector2f vec;
	assert(vec.isEmpty());
	vec += 1;
	assert(vec.x == 1f && vec.y == 1f);
	assert(!vec.isEmpty());
}

/**
 * Alias for short Vector
 */
alias Vector2s = Vector2!(short);
/**
 * Alias for float Vector
 */
alias Vector2f = Vector2!(float);
/**
 * Alias for byte Vector
 */
alias Vector2b = Vector2!(byte);
