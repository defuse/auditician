# Security Audit False Positive Prevention Guide

This guide helps auditing and issue-valdating agents identify common false positive patterns to improve audit accuracy.

## ⚠️ CRITICAL WARNING

**Issues can be real vulnerabilities even if they resemble these patterns!** This guide identifies common false positive patterns, but each issue must be carefully validated on its own merits. Do NOT simply pattern-match against this list - use it as a starting point for deeper investigation. A vulnerability that looks like a false positive pattern might still be exploitable due to specific implementation details or context.

## Core Principle: Context Is Everything

Always ask: **"Can a **real** attacker actually exploit this in production to affect **real** users?"**

## Common False Positive Patterns

### 1. **Valid Assumptions Flagged as Vulnerabilities**

**Pattern:** Security tools or auditors incorrectly flag code as vulnerable for relying on properties that attackers cannot violate: externally-enforced invariants, unbreakable assumptions, and guarantees from trusted components that attackers cannot circumvent.

**Real vulnerability would be:** Making assumptions about user-controlled input or data without guarantees.

**Key Question:** *Is the assumed-faulty assumption actually guaranteed by other application components, the larger protocol, real-world deployment pratices? Can real world attackers actually cause the assumption to be violated?*

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

**Examples (Web Standards):**

- **HTTP method properties**
  - "Code assumes GET requests have no body"
  - HTTP spec requires GET bodies be ignored
  - All major servers/proxies enforce this
  - Real issue: assuming POST can't have empty body

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

**Pattern:** Information that only aids reconnaissance marked as High/Critical severity.

**Key Question:** *What can an attacker actually DO with this information?*

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

### 7. **Configuration-Dependent Issues**

**Pattern:** Issues that only apply with non-default or explicitly insecure configurations.

**Key Question:** *What specific configuration enables this vulnerability? Will insecure configurations really be used in practice?*

**Examples:**
- **Debug mode information leakage** (marked High → should be Info)
  - Only with `DEBUG=true` or `--verbose` flag
  - Production uses `DEBUG=false` by default
  - Real Issue: sensitive data logged at default log levels

- **Insecure protocol support** (marked Critical → should be Low)
  - SSLv3 supported if explicitly enabled
  - Disabled by default
  - Real Issue: insecure protocols enabled by default

- **Development features in production** (marked Critical → should be Low)
  - Requires `ENABLE_DEV_FEATURES=true`
  - Admin must explicitly enable, documentation warns against it
  - Real Critical: dev features auto-enabled in production

### 8. **Misunderstanding Data Sensitivity**

**Pattern:** Treating public or non-sensitive data as confidential.

**Key Question:** *Is this data actually sensitive? What's the real harm?*

**Examples:**
- **Exposing public catalog data** (marked Medium → should be N/A)
  - Product prices, descriptions, inventory counts
  - Same data on public website
  - Real Medium: exposing customer purchase history

- **Application metrics exposed** (marked Medium → should be Low)
  - Request counts, response times, error rates
  - No user-specific data
  - Real Medium: metrics that can be used as a side-channel to reveal individual user activity in privacy-sensitive applications

- **Cache headers on static assets** (marked Low → should be N/A)
  - CDN cache hit/miss for public CSS/JS files
  - No security implications
  - Real issue: cache poisoning attacks are possible

### 9. **Requires System to Already Be Compromised**

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
- [ ] Attack is not blocked by other code in the target or ther infrastructure (such as blockchain consensus rules)
- [ ] Not an intentional design decision
- [ ] It's not the case that if this flaw existed, the app's functionality would already be obviously super broken

**Remember:** Focus on **exploitable vulnerabilities that cause real harm**, not theoretical musings.