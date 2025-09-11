Invariant-Centric Threat Modeling
==================================

This document describes a methodology for writing more effective threat models. The key
difference between this methodology and others like STRIDE is
that instead of trying to identify possible attacks and threats (a process prone
to [failure of
imagination](https://en.wikipedia.org/wiki/Failure_of_imagination)), we start
with an assumption of *no security* and only document *security invariants* once
we become confident that they are actually guaranteed. Inverting the threat model
like this has the following benefits.

1. It helps ensure users' security expectations are being met. When you have an
   explicit list of all of the invariants that are supposed to be provided, it's
   easier to tell when users are relying on properties that aren't on that list.
2. It helps security auditors discover vulnerabilities, because the security
   invariants should be a *complete* list of attack targets. The invariants'
   preconditions describe the valid starting points for an attack, which can
   help generate novel attack ideas.
3. It helps integrate forward-thinking security into the software development
   life cycle, since security is seen as a set of "features" that need to be
   planned in advance, rather than a seemingly-endless stream of problems that
   turn up after the code has been written. Following this methodology also
   forces security engineers to consider the user experience and business
   outcomes.

## The Methodology

The threat model should have a clear target audience in mind, which could either
be an end-user or a developer if the software is a library. The threat model
consists of a series of **security invariants**, which are written in language
that the audience understands. These are the security properties that the user
(or developer) should be able to safely rely on. For example, a security
invariant for full-disk encryption software might be:

> If I use a strong password and an adversary obtains my encrypted disk while
> my computer is turned off, they cannot learn anything about the contents.

Writing the invariants in terms the audience can understand emphasizes the
importance of aligning users' expectations with the actual guarantees. If users
assume they're getting some security property and they're actually not, that's
a security bug, even if there's nothing wrong with your software. If you're
having a hard time stating the security invariants in language your users can
understand, that's a sign that it's too hard to understand how to use your
software securely and it's likely being used in insecure ways.

The opposite of a security invariant is a **known weakness**. An example for
full-disk encryption software might be:

> If an adversary obtains my encrypted disk and then I receive it back from
> them, I cannot be sure that they haven't modified the contents.

The threat model is a natural place to document known security issues, primarily
so that security auditors don't waste time confirming already-known problems.
A known weaknesses list can also be helpful to UX engineers aiming to accurately
communicate counterintuitive risks. Unlike other threat modeling methodologies,
attacks and weaknesses are *not* the primary focus; it's okay for the known
weaknesses list to be incomplete.

Whether or not an attack is possible depends on how the software is being used
and the capabilities of the attacker. There should be a separate security
invariant for every combination of use case and set of assumptions about the
attacker. This tends to blow up the number of security invariants exponentially,
so it's helpful to compress the list by defining **adversaries**, **adversary
classes**, and **usage scenarios** to be referenced in the security invariants.
It can also help to collapse many adversaries with different capabilities into
a single adversary with all of those capabilities, whenever the finer
granularity isn't needed. If it's hard to compress the threat model down to
a reasonable size, that's another sign that it's too hard for your users to
understand how to use your software securely.

### Full-Disk Encryption Example

Here's a very-incomplete example threat model for full-disk encryption software.

**Adversaries**
- EVE can read the contents of the encrypted disk one time.
- MALLORY can read and write to the encrypted disk.
- MALWARE has installed malware on the user's computer.

**Adversary Classes**
- ACTIVE: {MALLORY, MALWARE}

**Usage Scenarios**

- Strong Password: The user chose a long random password that hasn't been used
  for anything else.

**Security Invariants**

- In the Strong Password scenario, EVE cannot learn any information about the
  plaintext contents of the disk.

**Known Weaknesses**

- ACTIVE adversaries can modify the contents of the disk without detection by
  the user.
- MALWARE can steal the encryption key, password, and plaintext content.
- MALLORY can potentially learn information about the contents of the disk by
  modifying some ciphertext and then observing the result of the user's software
  processing that modified data.

### Bugs in the Threat Model

A threat model can be incorrect in at least five different ways.

First, it can fail to list a security invariant that is actually satisfied. In
this case, the missing invariant can either be added to the threat model or
intentionally left out to communicate that the invariant is not expected to hold
true in future versions of the software.

Second, the threat model can fail to list a security invariant that is widely
expected by users. If users are relying on an invariant that is not satisfied,
then they are at risk and this should be treated like a security bug and
prioritized accordingly. You can fix this either by satisfying the invariant or
making UX changes to correct users' expectations.

Third, the threat model can list an invariant that is not satisfied. This means
there's a security bug in the software.

Fourth, the threat model can simply fail to be detailed enough. For example, in
the full-disk encryption example above, there is no mention of what the
user can expect if an adversary makes a copy of their disk, waits for the user
to make some changes, and then the steals another copy. Most users probably
don't care, but usually this leaks information about what changed, so for
rarer/unintended use cases (like cloud backups), it matters.

Fifth, the threat model can be ambiguous. This can happen when usage scenarios
make implicit assumptions about the adversary, or vice-versa, and the
assumptions conflict such that it's not clear what an invariant actually means.

### Versioning

The threat model should be versioned alongside the software that it applies to.
This way, later versions of the software can have new improved security
invariants documented without confusing anyone into thinking that the older
versions satisfied those invariants too.

When semantic versioning is in use, removing a security invariant should bump
the major version. It counts as an incompatible API change (even if nothing
would break) because downstream users may become vulnerable by upgrading.
Bumping the major version makes it more likely they'll notice the change.

### Software Boundaries

Security bugs are often found at the boundaries between software written by
different people. This happens because one side of the divide assumes the
software on the other side has some property that it in fact does not. Usually,
the assumption is something reasonable, and it's hard to realize it's false
without digging into detailed documentation or code. There's no substitute for
carefully reading the documentation for all of the libraries you use and making
sure you're using them correctly, but threat models can help elevate the
pitfalls that really matter for security.

If your threat model makes mention of a separate software component, then you
should carefully check that the preconditions in your security invariants don't
assume anything more than what's guaranteed by the other component's threat
model (or its more detailed documentation).

## Conclusion

This threat modeling methodology works better to...

**Ensure users' security expectations are being met.**

Users should not rely on any property that is not a documented security
invariant. If they do, either the threat model is not being communicated to them
effectively, or whatever they're relying on is an important missing feature that
should be added. The known weaknesses list can aid communications and UX efforts
to set user expectations appropriately; you shouldn't assume end-users will read
the threat model!

**Help security auditors discover vulnerabilities and rate their severity.**

The security invariants tell the security auditors what their attack targets are,
i.e. any security vulnerability they find should be a violation of a security
invariant. The invariants' preconditions tell them what they can assume as
a valid starting point for an attack. The severity of a vulnerability can be
judged by the consequences of the invariant being violated and the number of
users that are relying on that invariant. Auditors should invest significant
effort into identifying mistakes/omissions in the threat model (see the five
kinds of mistakes above).

## Credit

My line of thinking here originated from [Eleanor Saitta's tweet](https://twitter.com/Dymaxion/status/1151214240658837506)
