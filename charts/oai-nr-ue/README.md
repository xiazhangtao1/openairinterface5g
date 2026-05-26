# OAI nrUE Helm Chart

This chart deploys the OpenAirInterface nrUE container. The default values target
the RFsimulator scenario used by `ci-scripts/yaml_files/5g_rfsimulator`.

The nrUE requires `/dev/net/tun`, `NET_ADMIN`, `NET_RAW`, and `SYS_NICE` to
create `oaitun_ue1`, run ping, and keep the modem scheduler usable.

This first version targets one RFsim gNB and one RFsim nrUE only.

Example:

```bash
helm install nrue charts/oai-nr-ue \
  --set rfsimulator.serveraddr=gnb-oai-gnb \
  --set uicc.imsi=208990100001100
```

After registration, validate the user plane from the nrUE pod:

```bash
kubectl exec deploy/nrue-oai-nr-ue -- ifconfig oaitun_ue1
kubectl exec deploy/nrue-oai-nr-ue -- ping -I oaitun_ue1 <ext-dn-ip> -c 4
```
