# OAI gNB Helm Chart

This chart deploys the OpenAirInterface gNB container. The default values target
the RFsimulator scenario used by `ci-scripts/yaml_files/5g_rfsimulator`.

For cross-node or cross-cluster deployments, set `amf.ip`,
`network.n2Address`, `network.n3Address`, and expose the RFsimulator service
with a routable address. The N2 address must be reachable by the AMF over SCTP
38412, and the N3 address must be reachable by the UPF over UDP 2152.

This first version targets one RFsim gNB and one RFsim nrUE only.

By default, `network.n2Address` and `network.n3Address` are rendered from the
gNB Pod IP at container start.

The gNB runs privileged by default because OAI creates real-time and RFsim
worker threads during startup. In constrained clusters this can be relaxed only
after validating thread creation and scheduling behavior.

Example:

```bash
helm install gnb charts/oai-gnb \
  --set amf.ip=10.96.125.66 \
  --set plmn.mnc=93 \
  --set plmn.sd=0x010203
```

When the AMF runs in the same Kubernetes cluster, use the AMF N2 service
ClusterIP for `amf.ip`. For the free5GC chart used in this environment, the AMF
supports PLMN `208/93`, TAC `000001`, and S-NSSAI `sst=1, sd=010203`.
