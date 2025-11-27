# Example: Security Properties for Proof-Based Auditing

This document provides a concrete example of well-formulated security properties for the security prover agent. These properties were developed for the Zcash implementation audit and demonstrate the recommended approach for defining properties at appropriate scales.

## Key Principles Demonstrated

1. **Properties are user-focused**: Each property describes what the user expects, not implementation details
2. **Properties are falsifiable**: Each can be proven or disproven with concrete evidence
3. **Scale matches complexity**: Micro for invariants, Medium for cross-component flows, Large for protocol-level
4. **Prioritization by impact**: Fund theft properties come first

---

## Category A: User Cannot Lose Funds Without Consent (6 properties)

These are the highest-priority properties - if any fails, users can lose money.

| # | Property | Scale | Rationale |
|---|----------|-------|-----------|
| **1** | **"The total ZEC leaving the user's control equals the sum of all non-change output values displayed on screen"** | Medium (~200 lines) | This is THE core property. Requires tracing: check.rs value validation → parse.rs total calculation → GUI display. The sapling-value-sum and fee-calculation-underflow bugs violated this. |
| **2** | **"An output is marked as change (is_change=true) if and only if the device cryptographically verifies the recipient is derivable from the user's seed"** | Medium (~200 lines) | The orchard-internal-ovk-change-spoofing bug violated this. Requires analyzing OVK decryption logic and P2SH change detection. |
| **3** | **"The device will not sign a spend that transfers value from a note the user does not own"** | Small (~50 lines) | Focus on fingerprint/derivation path matching and fail-closed behavior. |
| **4** | **"The fee displayed equals actual_inputs - actual_outputs for the transaction that will be broadcast"** | Medium (~200 lines) | Requires verifying fee calculation path through all three pools and ensuring the signed transaction matches displayed values. |
| **5** | **"Every external output address displayed on screen matches the recipient who will receive funds"** | Small (~50 lines) | Focus on where recipient vs user_address vs decoded address are compared. |
| **6** | **"Signing cannot proceed if any cryptographic commitment verification fails (cv_net, cmx, nullifier)"** | Medium (~200 lines) | Trace error propagation from verify functions through to sign rejection. |

---

## Category B: Value Integrity Across Pools (4 properties)

Cross-pool attacks are subtle - each pool has different validation.

| # | Property | Scale | Rationale |
|---|----------|-------|-----------|
| **7** | **"Orchard value_sum displayed equals the independently calculated sum of (spend.value - output.value) for all actions"** | Micro (~5-10 lines) | Direct proof of value_sum recalculation. This is the ONLY value_sum that's validated. |
| **8** | **"Transparent input values come from the UTXO's script_pubkey amount, not from untrusted PCZT metadata"** | Small (~50 lines) | Verify that input.value() is validated against script_pubkey. |
| **9** | **"If Sapling components exist, a warning is ALWAYS shown AND the user is told amounts may be inaccurate"** | Small (~50 lines) | A bug showed has_sapling check was insufficient - value_sum could be set without triggering warning. |
| **10** | **"No pool's value_sum can cause an integer underflow in fee/amount calculations"** | Micro (~5-10 lines) | Focus on arithmetic operations with signed/unsigned conversion. |

---

## Category C: Derivation Path Security (3 properties)

Path manipulation can redirect funds to attacker addresses.

| # | Property | Scale | Rationale |
|---|----------|-------|-----------|
| **11** | **"BIP32 derivation paths in transparent inputs/outputs are validated to produce the expected public key before marking as 'mine'"** | Small (~50 lines) | Check the xpub.derive → compare flow. |
| **12** | **"ZIP32 derivation paths in Orchard spends match exactly m/32'/coin_type'/account' for the configured account before verification"** | Micro (~5-10 lines) | Path comparison logic. |
| **13** | **"Signing uses the derivation path from the PCZT, and that path MUST have passed validation during check phase"** | Medium (~200 lines) | This is the check-before-sign guarantee. |

---

## Category D: Signature Commitment Integrity (3 properties)

What the user approves must equal what gets signed.

| # | Property | Scale | Rationale |
|---|----------|-------|-----------|
| **14** | **"The sighash commits to all outputs - no output can be modified after signing"** | Large (~1000 lines) | Requires analyzing signature hash construction per protocol specification. |
| **15** | **"Only SIGHASH_ALL is used - partial signing modes that allow output modification are rejected"** | Micro (~5-10 lines) | Verify the SIGHASH_ALL hardcoding and any assertions. |
| **16** | **"The transaction expiry_height and lock_time displayed match what is committed in the signature"** | Small (~50 lines) | Verify these aren't modifiable post-signature. |

---

## Category E: FFI Boundary Safety (2 properties)

The Rust-C boundary is a trust boundary.

| # | Property | Scale | Rationale |
|---|----------|-------|-----------|
| **17** | **"Null pointers from C do not cause undefined behavior in Rust FFI functions"** | Medium (~200 lines) | Analyze all FFI functions for null handling. |
| **18** | **"Memory passed from C (seed, fingerprint, bytes) is validated before cryptographic use"** | Small (~50 lines) | Focus on pointer extraction macros. |

---

## Category F: Key Material Protection (2 properties)

Seeds must never leak.

| # | Property | Scale | Rationale |
|---|----------|-------|-----------|
| **19** | **"After signing completes, no seed material remains in the returned transaction data"** | Small (~50 lines) | Verify redaction removes all key-adjacent data. |
| **20** | **"The seed_fingerprint alone cannot be used to derive or guess any key material"** | Micro (~5-10 lines) | Verify fingerprint is one-way (uses hashing). |

---

## Recommended Execution Order

**Phase 1 - Critical Fund Safety (do these first):**
- #1, #2, #4 (Core value and change detection - where confirmed bugs were)
- #7 (Value_sum - the only validated one)

**Phase 2 - Pool-Specific Validation:**
- #8, #9, #10 (Edge cases in different transaction components)
- #11, #12 (Derivation path validation)

**Phase 3 - Signature Integrity:**
- #14, #15 (Sighash commitment)
- #13 (Check-before-sign)

**Phase 4 - Defense in Depth:**
- #3, #5, #6 (Secondary security properties)
- #16, #17, #18 (Boundary safety)
- #19, #20 (Key material handling)

---

## Scale Distribution Summary

| Scale | Count | Best For |
|-------|-------|----------|
| Micro (~5-10 lines) | 5 | Specific invariants, arithmetic checks, single-function proofs |
| Small (~50 lines) | 8 | Single-component validation, boundary checks |
| Medium (~200 lines) | 6 | Cross-component data flows, attack chains |
| Large (~1000 lines) | 1 | Protocol-level properties, signature schemes |

---

## Why These Properties Work

### Good Property Characteristics:

1. **Specific and falsifiable**
   - BAD: "Signing is secure"
   - GOOD: "The sighash commits to all outputs - no output can be modified after signing"

2. **User-centric language**
   - BAD: "verify_cv_net returns success"
   - GOOD: "The total ZEC leaving the user's control equals what is displayed"

3. **Includes failure condition**
   - BAD: "Change detection works"
   - GOOD: "An output is marked as change if and only if the device cryptographically verifies..."

4. **Implies attack scenario when false**
   - If #2 is false → attacker can mark their address as change → fund theft
   - If #9 is false → attacker can manipulate fees without warning → unexpected costs

### Property Categories Map to Attack Goals:

| Category | Attacker Goal if Property Fails |
|----------|--------------------------------|
| A (Fund Safety) | Direct fund theft |
| B (Value Integrity) | Hidden value extraction, fee manipulation |
| C (Derivation) | Redirect funds via path manipulation |
| D (Signature) | Post-approval transaction modification |
| E (FFI) | Undefined behavior, potential code execution |
| F (Key Material) | Key extraction, privacy compromise |

---

## Generating Properties for Other Components

When generating security properties for a new component:

1. **Start with user expectations**: What does the user believe this component guarantees?

2. **Identify trust boundaries**: Where does untrusted data enter? Where do trusted operations occur?

3. **Map to attack goals**: For each property, ask "if this is false, what can an attacker do?"

4. **Choose appropriate scale**:
   - Micro: Single function, arithmetic invariant
   - Small: One component, clear input/output
   - Medium: Multiple components, data flow across trust boundary
   - Large: Full subsystem, protocol-level guarantee

5. **Prioritize by impact**: Fund theft > Privacy breach > DoS > Code quality

6. **Learn from existing bugs**: Properties that would have caught known vulnerabilities are highest value
