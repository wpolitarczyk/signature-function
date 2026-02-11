# (Twisted) Signature functions of Generalized Algebraic Knots

This project allows calculating knot invariants for linear combinations of iterated torus knots.
It was created as part of the proof for the main lemma from the paper **"On the slice genus of generalized algebraic knots"** (Maria Marchwicka and Wojciech Politarczyk).
Majority of the code was written by Maria Marchwicka.

## Project Structure

The project is organized as follows:

* **`gaknot/`**: Contains the source code (SageMath and Python files). This is the main package directory.
* **`notebooks/`**: Contains Jupyter notebooks for testing and reproducing calculations (e.g., `lemma.ipynb`, `LT-signature.ipynb`).

## Requirements

* **SageMath**: This project relies on the SageMath kernel. Ensure you have a working installation of SageMath (e.g., via Conda or a native install).

## Usage

To use the package, ensure the parent directory of `gaknot` is in your Python path. You can then import modules directly.

### 1. Levine-Tristram Signature (`LT_signature`)

The `LT_signature` module computes the Levine-Tristram signature function for torus knots $T(p,q)$. It implements the formulas defined in Litherland's paper *"Signature of iterated torus knots"*.

**Example: Computing the signature of T(2,3)**

```python
import gaknot
from gaknot.LT_signature import LT_signature_torus_knot

# Calculate the signature function for Torus Knot T(2,3)
# Note: p and q must be relatively prime
sig = LT_signature_torus_knot(2, 3)

# Print the jump points and values
print(sig)
# Output: 0: 0, 1/6: -1, 5/6: 1, 1: 0.
```

**Example: Operations and Plotting**

The resulting object is a SignatureFunction, which supports evaluation, algebraic operations, and plotting.

```python
from gaknot.signature import SignaturePloter

# Evaluate the function at a specific point (theta)
val_at_half = sig(1/2)

# Calculate the total signature jump
total_jump = sig.total_sign_jump()

# Plot the step function
SignaturePloter.plot(sig, title="Signature of T(2,3)")
```

### 2. Reproducing Proofs

To recreate the exact calculations done for the proof of Lemma 3.2, please refer to the lemma.ipynb file located in the notebooks/ directory.

## Documentation
For a more detailed description of the classes and internal logic, please refer to the docstrings within the gaknot package files.
