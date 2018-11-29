// James Eli
// 9/9/2018
// C++ calling asembly function demonstration.
#include <iostream>
#include <cassert>

// Prototype for extern "isPrime" function (in an asm file).
extern "C" int _stdcall isPrime(int);

int main()
{
	const char* source = "Enter a number: ";
	const char* source1 = "The number is prime.";
	const char* source2 = "The number is not prime.";
	int n;

	// Assert isPrime by counting primes between -100 and 100.
	int primeCount = 0;
	for (n = -100; n <= 100; n++)
		if (isPrime(n))
			primeCount++;
	assert(primeCount == 50);

	// User enter number.
	std::cout << source;
	std::cin >> n;
	printf("%s\n", (isPrime(n) ? source1 : source2));

	return 0;
}
