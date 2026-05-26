# OAI gNB Helm Chart

This chart deploys the OpenAirInterface gNB container. The default values target
the RFsimulator scenario used by `ci-scripts/yaml_files/5g_rfsimulator`.

For cross-node or cross-cluster deployments, set `amf.ip`,
`network.n2Address`, `network.n3Address`, and expose the RFsimulator service
with a routable address. The N2 address must be reachable by the AMF over SCTP
38412, and the N3 address must be reachable by the UPF over UDP 2152.

This first version targets one RFsim gNB and one RFsim nrUE only.

Example:

```bash
helm install gnb charts/oai-gnb \
  --set amf.ip=192.168.71.132 \
  --set network.n2Address=192.168.71.140 \
  --set network.n3Address=192.168.71.140
```
