package net.i2p.crypto.elgamal.spec;

import java.security.spec.AlgorithmParameterSpec;

public class ElGamalGenParameterSpec
    implements AlgorithmParameterSpec
{
    private final int primeSize;

    /*
     * @param primeSize the size (in bits) of the prime modulus.
     */
    public ElGamalGenParameterSpec(
        int     primeSize)
    {
        this.primeSize = primeSize;
    }

    /**
     * Returns the size in bits of the prime modulus.
     *
     * @return the size in bits of the prime modulus
     */
    public int getPrimeSize()
    {
        return primeSize;
    }
}
