# broken sprig

test 1:

```
helm template --debug test . 2>/dev/null|grep 'aa_'|awk -F':' '{print $2}'`
```

test 2:

```
helm template --debug test . 2>/dev/null|grep 'tls.crt:'|awk '{print $2}' | base64 -D > crt.crt; openssl x509 -text -noout -in crt.crt -certopt no_subject,no_header,no_version,no_serial,no_signame,no_validity,no_issuer,no_pubkey,no_sigdump,no_aux
```