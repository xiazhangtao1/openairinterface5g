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
  --set config.trackingAreaCode=1 \
  --set-string plmn.mcc=460 \
  --set-string plmn.mnc=11 \
  --set-string plmn.sd=0x010101
```

When the AMF runs in the same Kubernetes cluster, use the AMF N2 service
ClusterIP for `amf.ip`. The AMF served GUAMI, supported TAI, SMF PLMN, SMF
S-NSSAI, UPF DNN list, WebUI subscriber, gNB PLMN, and nrUE UICC values must all
use the same PLMN/DNN/S-NSSAI. The default OAI values use PLMN `460/11`, TAC
`000001`, DNN `cmnet`, and S-NSSAI `sst=1, sd=010101`. The nrUE does not set a
TAC; it reads TAI from the gNB broadcast.

The OAI gNB runtime rejects TAC `0`; `tracking_area_code` must be in the range
`1..65533`. If the AMF logs `Cannot find Served TAI`, configure the AMF
`supportTaiList` TAC to match the gNB value, for example `000001`.
