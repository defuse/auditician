# Security Audit False Positive Prevention Guide

This guide helps auditing and issue-valdating agents identify common false positive patterns to improve audit accuracy.

## ⚠️ CRITICAL WARNING

**Issues can be real vulnerabilities even if they resemble these patterns!** This guide identifies common false positive patterns, but each issue must be carefully validated on its own merits. Do NOT simply pattern-match against this list - use it as a starting point for deeper investigation. A vulnerability that looks like a false positive pattern might still be exploitable due to specific implementation details or context.

## 📝 IMPORTANT NOTE ON BUGS WITHOUT SECURITY IMPACT

**Real bugs should still be reported, even without security consequences!** If you find an actual bug in the code (like an off-by-one error, logic mistake, or performance issue) that doesn't create a security vulnerability, it should still be reported as a valid issue with **Info** severity. Only mark issues as invalid if they are not real bugs at all. Examples:
- Loop counter bug that wastes resources but doesn't create vulnerability → Valid (Info severity)
- Inefficient algorithm that works correctly but slowly → Valid (Info severity)
- Claimed "vulnerability" that's actually intended behavior → Invalid

## Core Principle: Context Is Everything

Always ask: **"Can a **real** attacker actually exploit this in production to affect **real** users?"**

## Common False Positive Patterns

### 1. **Valid Assumptions Flagged as Vulnerabilities**

**Pattern:** Security tools or auditors incorrectly flag code as vulnerable for relying on properties that attackers cannot violate: externally-enforced invariants, unbreakable assumptions, and guarantees from trusted components that attackers cannot circumvent.

**Real vulnerability would be:** Making assumptions about user-controlled input or data without guarantees.

**Key Question:** *Is the assumed-faulty assumption actually guaranteed by other application components, the larger protocol, real-world deployment practices? Can real world attackers actually cause the assumption to be violated?*

**⚠️ Important:** This should only be classified as a real vulnerability if a clear, realistic attack path exists for violating the assumption. Simply saying "what if X changes or isn't true" is not sufficient without showing how an attacker could really trigger or exploit the issue in practice (there should be a demonstrable attack path).

**Examples (Blockchain):**

- **Hardcoded cryptographic sizes**
  - "Equihash solution hardcoded to 1344 bytes could overflow"
  - Zcash protocol defines and enforces this exact size
  - All valid solutions are exactly 1344 bytes by definition
  - Changing would require consensus-breaking hard fork
  - Real issue: assuming unvalidated user input has similar guarantees

- **Fixed block size limits**
  - "Buffer overflow if block exceeds 1MB"
  - Bitcoin protocol enforces max 1MB blocks
  - Network would reject larger blocks
  - Real issue: assuming the block size is 1MB *before* that validation step has occurred at all.

**Examples (Database):**

- **Primary key uniqueness**
  - "Assumes database ID is unique without checking"
  - RDBMS guarantees primary key uniqueness at the engine level
  - This is enforced by B-tree/index structure, not just application code
  - Violation = database corruption
  - Real issue: assuming uniqueness on non-constrained fields

**Examples (Network):**

- **TCP sequence number wrapping**
  - "32-bit sequence numbers could wrap and cause confusion"
  - TCP protocol handles wrapping by design (RFC 793)
  - All TCP stacks implement proper sequence number comparison
  - Real issue: assuming application-level sequence numbers won't wrap

**Examples (Command Injection):**

- **exec() with only system-controlled paths**
  - "Command injection via exec('/usr/bin/gcc ' + tempfile)"
  - Tempfile is system-generated like `/tmp/` + `rand()` + `.c`
  - No user input reaches the exec() call
  - Real issue: exec() with actual user-controlled input

- **Command with integer-only variables**
  - "Injection via exec('sleep ' + (int)$seconds)"
  - $seconds is cast to integer or validated as numeric
  - Integer conversion prevents injection of shell metacharacters
  - Real issue: using unvalidated string input in commands

**How to validate:** 

- **Demonstrate that a real-world attacker can actually violate the assumption.**
- Don't just claim "what if X isn't true" - show HOW an attacker could make X untrue.
- If the entire system would be obviously broken in a way that developers would have already detected if the assumption were untrue, it's almost certainly not a real vulnerability.
- Focus on practical attack paths, not theoretical scenarios.
- Be willing to think hard to uncover attack paths that are not obvious.

### 2. **Localhost/Internal Services Marked as Network Vulnerable**

**Pattern:** Security issues in services that only communicate locally or internally.

**Key Question:** *Can external attackers actually reach this?*

**Examples (Web Applications):**
- **Local Database connection without TLS**
  - App and database on same server using 127.0.0.1
  - Intercepting localhost requires system compromise
  - If attacker has root, TLS doesn't matter
  - Real issue: a connection to a remote database is used without TLS.

**Examples (Mobile Apps):**
- **IPC without encryption**
  - Android app components communicating via Intents
  - Only same-app components, not exported
  - Real issue: exported components without protection

**Examples (IoT/Embedded):**
- **UART debug interface**
  - Requires physical access to device
  - Often disabled in production firmware
  - Real Critical: debug interface exposed over the network or is accessible to untrusted components

**Examples (Smart Contracts):**
- **Internal function visibility**
  - Function marked `internal` not `private`
  - Can only be called by same/derived contracts
  - Real issue: function should be `internal` but is `public`/`external`

**Real vulnerability would be:** Same issues on internet-facing services or cross-privilege boundaries

### 3. **Information Disclosure Severity Overstated**

**Pattern:** Information that only aids reconnaissance or is already public marked as High/Critical severity.

**Key Question:** *What can an attacker actually DO with this information? Is it even sensitive?*

**Real vulnerability would be:** Exposing passwords, API keys, PII, user-specific data, or information that directly enables attacks

**Examples:**
- **Stack traces in error messages** (marked High → should be Low)
  - Only shows function names without actual variable contents
  - No passwords, keys, or user data exposed
  - Only helps with reconnaissance, doesn't bypass security
  - Real Issue: stack traces or messages containing database passwords or other sensitive information

- **Software version headers**
  - `Server: nginx/1.21.6` or `X-Powered-By: Express`
  - Version detectable through fingerprinting anyway
  - Public information for open source software
  - Real Issue: exposing private information such as behavior of users

- **Directory listings enabled** (marked High → should be Low)
  - Shows only static asset file names (CSS, images)
  - No source code or sensitive files exposed
  - Real Issue: directory listing exposing .env files, database backups, or source code

- **Timing attacks on public operations**
  - 10ms vs 100ms reveals cache hit/miss on public data
  - No user-specific information leaked
  - Real Issue: timing attack revealing keys or actual private information

- **Exposing public catalog data** (marked Medium → should be N/A)
  - Product prices, descriptions, inventory counts
  - Same data on public website
  - Real Issue: exposing customer purchase history

- **Application metrics exposed** (marked Medium → should be Low)
  - Request counts, response times, error rates
  - No user-specific data
  - Real Issue: metrics that can be used as a side-channel to reveal individual user activity

### 4. **Test/Debug Code Marked as Production Issues**

**Pattern:** Vulnerabilities in test files, debug modes, or development features that don't run in production.

**Real vulnerability would be:** Same issues in production code paths or enabled by default

**Key Question:** *Does this code/feature actually run in production?*

**Examples (Web/API):**
- **Hardcoded credentials in test files** (marked Critical → should be N/A)
  - Password in `test/fixtures/mock_auth_test.py`
  - Test files not deployed to production
  - Real Issue: hardcoded production environment keys, insecure deployment practices

**Examples (Mobile):**
- **Certificate pinning disabled in debug** (marked Critical → should be Info)
  - `if (BuildConfig.DEBUG) skipCertValidation()`
  - Release builds have `DEBUG = false`
  - Real Issue: certificate checking might be disabled in the releases users actually use

**Examples (Smart Contracts):**
- **Test contracts with mint functions** (marked Critical → should be N/A)
  - `TestToken.sol` in `contracts/test/`
  - Never deployed to mainnet
  - Real Issue: bug that allows anyone to mint funds on mainnet.

**Examples (Desktop):**
- **Verbose logging in debug builds** (marked High → should be N/A)
  - `#ifdef DEBUG` blocks with sensitive logs
  - Stripped from release builds
  - Real Issue: sensitive data logged in release

### 5. **Impractical Resource Exhaustion Attacks**

**Pattern:** DoS vulnerabilities requiring unrealistic attacker resources or already mitigated by infrastructure.

**Real vulnerability would be:** Amplification attacks where small input causes disproportionate resource use

**Key Question:** *What resources would the attacker need, and what would stop them?*

**Examples:**
- **Requesting entire database** (marked Critical → should be Low)
  - API allows requesting millions of records
  - Would require downloading 100GB over hours
  - CloudFlare/nginx timeouts trigger after 60 seconds
  - Monitoring alerts on unusual traffic patterns
  - Real Issue: 1KB request causing 1GB memory allocation

- **Unlimited concurrent connections** (marked High → should be Low)
  - No application-level connection limit
  - OS limits (ulimit), nginx (worker_connections), firewall rules apply first
  - Each connection uses minimal resources
  - Real Issue: single connection consuming unbounded resources

- **Large file upload DoS** (marked High → should be Low-Medium)
  - Can upload 1GB files
  - Requires attacker to have 1GB upload bandwidth per attempt
  - CDN/proxy usually limits to much less
  - Real Issue: 1KB upload triggering gigabytes of processing/memory

### 6. **Intentional Design Decisions Marked as Vulnerabilities**

**Pattern:** Architectural choices or business requirements flagged as security issues.

**Real vulnerability would be:** Missing security controls due to a design oversight rather than an intentional choice.

**Key Question:** *Is this a bug or a feature? Would "fixing" it break the application?*

**Examples (Web):**
- **No authentication on public APIs** (marked Critical → should be N/A)
  - Weather API, public documentation
  - Designed to be publicly accessible
  - Real Issue: missing auth on user account APIs

- **CSRF on stateless public services** (marked High → should be N/A)
  - "CSRF vulnerability in calculator/assembler service"
  - Service is stateless, doesn't modify user data
  - No user accounts or private data involved
  - Real Issue: CSRF on actions that change user account state or access private data

**Examples (Blockchain/Smart Contracts):**
- **No admin functions** (marked High → should be By Design)
  - Immutable contract by design
  - Adding admin functions would break trust model
  - Real Issue: a way to handle a likely failure scenario hasn't been accounted for in an immutable contract

**Examples (IoT):**
- **Firmware updates without rollback** (marked High → should be Design Tradeoff)
  - Device has limited storage
  - Rollback would double storage requirements
  - Real Issue: no signature verification on updates

**Examples (Gaming/Desktop):**
- **Client-side physics calculations** (marked High → should be By Design)
  - Required for responsive gameplay
  - Server validates important actions
  - Real Issue: client authoritative for game economy

**Examples (Cryptography):**
- **Stream cipher with zero nonce** (marked High → should be By Design)
  - "Stream cipher uses all-zero nonce, vulnerable to nonce reuse"
  - Each message encrypted with a new random key per protocol design
  - Key uniqueness intentionally prevents nonce reuse issues
  - Real Issue: zero nonce with key reuse across messages

- **Client-side web cryptography** (marked Critical → should be Medium at most)
  - "JavaScript encryption can be manipulated if server is compromised"
  - This is an inherent limitation of web-based cryptography, not a vulnerability
  - All web crypto has this trust boundary issue - server serves the crypto code
  - Real Issue: storing passwords/keys in JavaScript source code or using weak crypto algorithms

### 7. **Configuration-Dependent Issues**

**Pattern:** Issues that only apply with explicitly insecure configurations.

**Key Question:** *What specific configuration enables this vulnerability? Will insecure configurations really be used in practice without the user knowing about the insecurity?*

**Examples:**
- **Debug mode information leakage** (marked High → should be Low)
  - Only with `DEBUG=true` or `--verbose` flag
  - Production uses `DEBUG=false` by default
  - Real Issue: sensitive data logged at default log levels

- **Insecure protocol support** (marked Critical → should be Low)
  - SSLv3 supported if explicitly enabled
  - Disabled by default
  - Real Issue: insecure protocols enabled by default

- **Insecure flags that communicate their own security** (marked Critical → should be N/A)
  - A command line argument like `--dangerously-skip-permissions` which allows arbitrary code execution.
  - The flag or feature itself communicates its danger to the user.
  - Real Issue: The flag is only called `--skip-permissions`, not indicating to the user that it is dangerous.

### 8. **Requires System to Already Be Compromised**

**Pattern:** Issues that require the attacker to already have compromised the system, gained physical access, or achieved a level of control that makes the "vulnerability" moot.

**Real vulnerability would be:** Issues exploitable without requiring existing compromise, or issues that would allow an attacker to escalate their level of compromise.

**Key Question:** *If an attacker can do this, haven't they already won?*

**Examples (Physical Access):**
- **USB debugging enabled** (marked High → should be Physical/Info)
  - Requires physical USB connection to device
  - Often disabled in production firmware
  - Real Issue: ADB over network enabled without authentication

**Examples (Root/Admin Required):**
- **Local privilege escalation from root** (marked High → should be N/A)
  - "Root user can modify system files"
  - If attacker has root, system is already fully compromised
  - Real Issue: escalation from normal user to root

- **Memory dumps contain secrets** (marked Critical → should be Low/Expected)
  - Requires ability to dump process memory
  - If attacker can read memory, they already have high privileges
  - Real Issue: secrets logged to world-readable files

**Examples (File System Access):**
- **SQLite database not encrypted** (marked High → should be Context-Dependent)
  - Stored in app's private directory
  - If attacker can read this, they've compromised the account
  - Real Issue: database stored in shared/public location

**Examples (Cryptography)**
- **Discrete Log Relation**
  - There would be a vulnerability if an attacker knew a discrete log relation between two or more group elements
  - Those group elements are outputs of a group hash or some other process that guarantees no known dlog relations.
  - Real Issue: A vulnerability that arises from a discrete log relation, and the attacker has an efficient method to find such a relation

### 9. **Obviously Broken Functionality**

**Pattern:** Claiming vulnerabilities that, if they existed, would make the application completely non-functional in obvious ways that would have been discovered immediately during development or testing.

**Key Question:** *If this vulnerability existed, wouldn't the app be obviously broken and unusable?*

**Examples:**
- **Missing database credentials**
  - "Application has no database connection string configured"
  - If true, app wouldn't start or every request would fail
  - Developers/users would notice immediately
  - Real issue: hardcoded credentials in source code

- **Payment processing always fails**
  - "Payment gateway API key is invalid/missing"
  - E-commerce site would have zero successful orders
  - Business would notice immediately (no revenue)
  - Real issue: payment validation can be bypassed

**How to validate:**
- Ask: "Has anyone successfully used this feature?"
- If yes, and so the vulnerability would have obviously been discovered by now, the claimed vulnerability likely doesn't exist

### 10. **False Assumptions About Deployment**

**Pattern:** Assuming vulnerabilities in environments where they don't apply.

**Key Question:** *How is this actually deployed in production?*

**Examples:**
- **File permissions in containers** (marked High → should be N/A)
  - "World-readable" files in single-user container
  - No other users exist to read them
  - Real High: weak permissions on shared hosting

- **Missing network encryption in K8s** (marked High → should be Low/Accepted)
  - Pod-to-pod communication within cluster unencrypted
  - Network policies and service mesh handle security
  - Real High: unencrypted sensitive data over public internet

- **Secrets in environment variables** (marked High → should be Low/Accepted Practice)
  - Standard practice in containerized deployments
  - Container orchestration secures them
  - Real High: secrets in public git repositories

## Important Edge Cases Where These Patterns Break Down

### When "Localhost" IS Vulnerable

- **Container environments with shared network namespaces** - Multiple containers sharing network can intercept localhost
- **Developer practices** - SSH tunnels, port forwarding, or remote development environments expose "localhost" services
- **Reverse proxies** - Some configurations forward localhost services to external interfaces
- **Always verify**: Check actual network topology and deployment architecture

## Validation Questions

For each potential issue, ask in order:

1. **Can a real-world attacker reach this?** (No → Not a vulnerability)
2. **What can they actually do with it?** (Just recon → Low severity max)
3. **Is this production code?** (Test/debug → Not a vulnerability)
4. **Is this realistic to exploit?** (Requires massive resources → Downgrade)
5. **Is this by design?** (Yes → Not a vulnerability)
6. **How does this impact real users?** (Won't affect any real world users → Low severity max)

## Severity Quick Reference

| What Attacker Achieves | Maximum Severity |
|------------------------|------------------|
| Real bug but no security impact (logic errors, performance) | Info |
| Reads public/non-sensitive data | Info |
| Learns system internals (recon only) | Low |
| Causes DoS with significant effort | Medium |
| Reads sensitive user data, violates integrity guarantees | High |
| Steals funds, compromises many users' systems | Critical |

## Real vs False Positive Examples

| Issue Type | ✅ REAL Vulnerability | ❌ FALSE Positive |
|------------|----------------------|-------------------|
| **No Auth** | Admin panel without login | Public weather API |
| **Info Disclosure** | Returns user passwords | Shows stack trace |
| **DoS** | 1KB request → 1GB RAM | Must send 100GB data |
| **Hardcoded Secret** | API key in production code | Password in test file |
| **No TLS** | User login over public internet HTTP | Localhost database connection |

## Final Checklist

Before marking as vulnerability:
- [ ] Attacker can realistically reach this code / exploit this vulnerability
- [ ] Impact and difficulty of exploitation justifies the severity level
- [ ] Not a test/debug/example file
- [ ] Attack is not blocked by other code in the target or other infrastructure (such as blockchain consensus rules)
- [ ] Not an intentional design decision
- [ ] It's not the case that if this flaw existed, the app's functionality would already be obviously super broken

Note that real vulnerabilities should still be marked as valid even if they are outside the scope of the audit.

**Remember:** Focus on **exploitable vulnerabilities that cause real harm**, not theoretical musings.