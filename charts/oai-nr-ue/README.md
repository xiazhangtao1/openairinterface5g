# OAI nrUE Helm Chart

This chart deploys the OpenAirInterface nrUE container. The default values target
the RFsimulator scenario used by `ci-scripts/yaml_files/5g_rfsimulator`.

The nrUE requires `/dev/net/tun`, `NET_ADMIN`, and `NET_RAW` to create
`oaitun_ue1` and run ping or traffic tests through the UE tunnel. Some clusters
may still require `securityContext.privileged=true` for the OAI runtime; validate
this in the target environment before relaxing the security context.

The default values keep the nrUE container privileged because this RFsim runtime
creates real-time worker threads and locks memory during startup.

This first version targets one RFsim gNB and one RFsim nrUE only.

Example:

```bash
helm install nrue charts/oai-nr-ue \
  --set rfsimulator.serveraddr=gnb-oai-gnb \
  --set-string uicc.imsi=460110000000100 \
  --set-string uicc.key=12345600000000000000000000000000 \
  --set-string uicc.opc=12345600000000000000000000000000 \
  --set uicc.dnn=cmnet \
  --set-string uicc.nssaiSd=0x010101
```

After registration, validate the user plane from the nrUE pod:

```bash
kubectl exec deploy/nrue-oai-nr-ue -- ifconfig oaitun_ue1
kubectl exec deploy/nrue-oai-nr-ue -- ping -I oaitun_ue1 <ext-dn-ip> -c 4
```
