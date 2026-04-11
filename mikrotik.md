---
title: "Network Configuration — MikroTik CRS354"
subtitle: "Network Infrastructure Documentation — Kubernetes Cluster"
author:
  - "Alex"
  - "Michał"
date: "2026-04-11"
subject: "Network Team"
keywords: [MikroTik, Kubernetes, LACP, CRS354, network]
---

\newpage

## Changelog

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.0 | 2026-04-11 | Alex, Michał | Initial version — CRS317-1G-16S+, 10G SFP+ LACP topology |
| 1.1 | 2026-04-11 | Michał | Detailed port assignment, topology diagram |
| 1.2 | 2026-04-11 | Michał | Added CONFIG.rsc data, bridge-wan configuration |
| 2.0 | 2026-04-11 | Alex | Switch replaced with CRS354-48G-4S+2Q+RM — 1G RJ45 ports (SFP+ instability at 80°C) |
| 2.1 | 2026-04-11 | Michał | Config update: node ports in bonds, management configuration |
| 2.2 | 2026-04-11 | Alex, Michał | Simplified notes section, removed threat table |
| 3.0 | 2026-04-11 | Alex, Michał | Updated from RouterOS 7.18.2 export — second uplink ether48, ether11/12 in bridge |
| 3.1 | 2026-04-11 | Alex, Michał | Distribution panel PD1 ports (ether9, 11–12, 21–24) |
| 3.2 | 2026-04-11 | Alex, Michał | MAC addresses for all assigned ports, QSFP+ sub-lanes, ether49 |
| 3.3 | 2026-04-11 | Alex, Michał | Review: port layout, bridge MAC, sfp-sfpplus1, inferred MACs |
| 3.4 | 2026-04-11 | Alex, Michał | Translated to English |

\newpage

### Device

- **Model:** CRS354-48G-4S+2Q+RM
- **Serial:** HK60AM6CECJ
- **RouterOS:** 7.18.2
- **Software ID:** WFM1-CBPK

### Nodes — Apple Mac Pro

- 4x Apple Mac Pro
- Each node: 2x 1Gbps RJ45 in LACP (2Gbps per node)
- Network: 10.254.254.0/25

| Node | IP | MAC (bond) |
|------|----|------------|
| Node 1 | `10.254.254.118` | `60:d0:39:ad:57:9f` |
| Node 2 | `10.254.254.113` | `60:d0:39:a0:a7:e2` |
| Node 3 | `10.254.254.117` | `60:d0:39:af:23:6a` |
| Node 4 | `10.254.254.116` | `60:d0:39:a2:4e:34` |

### Switch — MikroTik CRS354-48G-4S+2Q+RM

- 48x Gigabit Ethernet RJ45 (ether1–48, switch1)
- 1x GE (ether49, switch2)
- 4x SFP+ 10Gbps (sfp-sfpplus1–4)
- 2x QSFP+ 40Gbps, each split into 4x 10G sub-lanes (qsfpplus1-1..4, qsfpplus2-1..4)
- 1U rack

#### Port Assignment

**Bridge — bridge-wan**

> Bridge MAC address requires verification via `/interface bridge print` on the device.

| Interface | MAC | Usage | Active |
|-----------|-----|-------|--------|
| sfp-sfpplus1 | `04:F4:1C:8F:76:9C` | FO uplink — WAN-FIBRE | no |
| ether48 | `04:F4:1C:8F:76:CF` | Copper uplink — WAN-ETH | yes |
| bond1 | `04:F4:1C:8F:76:A0` | Node 1 | yes |
| bond2 | `04:F4:1C:8F:76:A1` | Node 2 | yes |
| bond3 | `04:F4:1C:8F:76:B8` | Node 3 | yes |
| bond4 | `04:F4:1C:8F:76:B9` | Node 4 | yes |
| ether9 | `04:F4:1C:8F:76:A8` | PD1/124 | yes |
| ether11 | `04:F4:1C:8F:76:AA` | PD1/122 | yes |
| ether12 | `04:F4:1C:8F:76:AB` | PD1/123 | yes |
| ether21 | `04:F4:1C:8F:76:B4` | PD1/120 | yes |
| ether22 | `04:F4:1C:8F:76:B5` | PD1/121 | yes |
| ether23 | `04:F4:1C:8F:76:B6` | PD1/119 | yes |
| ether24 | `04:F4:1C:8F:76:B7` | PD1/118 | yes |

> MAC addresses for ether21 and ether22 were not visible in `print` output — derived from sequence.

> Bond MAC addresses (bond1–bond4) are the MAC addresses of the first slave port (ether1, ether2, ether25, ether26) — default RouterOS behaviour. Confirm via `/interface bonding print`.

**Bonds — slave ports**

| Bond | Port | MAC |
|------|------|-----|
| bond1 | ether1 | `04:F4:1C:8F:76:A0` |
| bond1 | ether13 | `04:F4:1C:8F:76:AC` |
| bond2 | ether2 | `04:F4:1C:8F:76:A1` |
| bond2 | ether14 | `04:F4:1C:8F:76:AD` |
| bond3 | ether25 | `04:F4:1C:8F:76:B8` |
| bond3 | ether37 | `04:F4:1C:8F:76:C4` |
| bond4 | ether26 | `04:F4:1C:8F:76:B9` |
| bond4 | ether38 | `04:F4:1C:8F:76:C5` |

> MAC address for ether14 was not visible in `print` output — derived from sequence.

#### Topology

```
        Upstream network
               |
           ether48 (WAN-ETH)
               |
           bridge-wan (L2)
      /      |       |       |
  bond1   bond2   bond3   bond4
 (1+13) (2+14) (25+37) (26+38)
   |       |       |       |
 Node 1  Node 2  Node 3  Node 4

CRS354-48G-4S+2Q+RM — physical port layout
(odd ports on top row, even ports on bottom row)

pos:  1    2    3    4    5    6    7  ...  13  ...  19  ...  24
top:  1    3    5    7   [9] [11] [13] ... [25] ... [37] ...  47
bot:  2    4    6    8   10  [12] [14] ... [26] ... [38] ... [48]

[] = assigned port   9,11,12=PD   48=WAN
```

Each bond's ports are 6 physical positions apart (12 port numbers) in the same row — intentionally distributed across separate switch processors (ASICs), providing LACP resilience against single-block failure.

#### LACP Configuration (802.3ad)

| Bond | Ports | Node | Hash policy |
|------|-------|------|-------------|
| bond1 | ether1 + ether13 | Node 1 | layer-2-and-3 |
| bond2 | ether2 + ether14 | Node 2 | layer-2-and-3 |
| bond3 | ether25 + ether37 | Node 3 | layer-2-and-3 |
| bond4 | ether26 + ether38 | Node 4 | layer-2-and-3 |

- Throughput per node: 2x 1Gbps = 2Gbps
- Total node throughput: 4x 2Gbps = 8Gbps

#### Comparison with Previous Switch (CRS317)

CRS317 replaced due to SFP+ transceiver instability and overheating to ~80°C.

| | CRS317-1G-16S+ | CRS354-48G-4S+2Q+RM |
|-|----------------|----------------------|
| Node ports | 10G SFP+ | 1G RJ45 |
| Throughput per node | 20Gbps | 2Gbps |
| Total node throughput | 80Gbps | 8Gbps |
| Stability | SFP+ issues (80°C) | Stable copper links |
| Free ports | 7x SFP+ | 39x RJ45 + 3x SFP+ + 2x QSFP+ |

#### Management Configuration

- Telnet: disabled
- WWW (HTTP): disabled
- Neighbor discovery: disabled on dynamic interfaces
- Recommended access: SSH or Winbox

#### High Availability (HA)

Cable-level redundancy is provided — each node is connected via two physical links in LACP (802.3ad). Failure of a single cable or port does not interrupt connectivity.

Switch-level redundancy **is not provided** — the entire infrastructure relies on a single CRS354 device. Switch failure results in loss of connectivity for the entire cluster.

#### Notes

Apple Mac Pro has built-in 10GbE — the switch limits connections to 1G. Returning to 10G requires stable SFP+ transceivers or a switch with native 10G RJ45 ports.
