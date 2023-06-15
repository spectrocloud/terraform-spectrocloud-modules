# How to Override Cluster Profile Parameters in the Cluster YAML File

Follow the steps below to override cluster profile parameters in the [cluster-eks-dev.yaml](https://github.com/spectrocloud/terraform-spectrocloud-modules/blob/0d69af3d473096e715ca8fe8e4a03008c7a75051/examples/eks/config/cluster/cluster-eks-dev.yaml) YAML file.
Note there are several parameters available as described in `params` the [profile-infra.yaml](https://github.com/spectrocloud/terraform-spectrocloud-modules/blob/0d69af3d473096e715ca8fe8e4a03008c7a75051/examples/eks/config/profile/profile-infra.yaml). The example contains two of them.

## Step 1: Locate the Profile Parameter you want to Override

Find the profile parameter in the YAML file that you wish to override. For example, in the cluster profile-infra.yaml provided
there are issuerUrl and clientId that we want to be set to a specific value for each cluster.
Let's create some example names for these parameters: `OIDC_ISSUER_URL` and `OIDC_CLAIM_NAME` are two parameter names we choose to be overwritten.

```yaml
        oidcIdentityProvider:
          identityProviderConfigName: '%OIDC_IDENTITY_PROVIDER_NAME%'       # The name of the OIDC provider configuration
          issuerUrl: '%OIDC_ISSUER_URL%'       # The URL of the OpenID identity provider
          clientId: '%OIDC_CLAIM_NAME%'           # The ID for the client application that makes authentication requests to the OpenID identity provider
          usernameClaim: "email"                     # The JSON Web Token (JWT) claim to use as the username
          usernamePrefix: "-"                        # The prefix that is prepended to username claims to prevent clashes with existing names
          groupsClaim: "groups"                      # The JWT claim that the provider uses to return your groups
          groupsPrefix: "-"                          # The prefix that is prepended to group claims to prevent clashes with existing names
          requiredClaims:                            # The key value pairs that describe required claims in the identity token

```

## Step 2: Find the Parameter in the Cluster YAML

Open your cluster YAML file and locate the profile parameter within the profiles section. The parameters are listed under `params` under each pack within a profile. 
Use parameter names that we selected on the previous steps as keys to replace values in cluster-eks-dev.yaml: `OIDC_ISSUER_URL` and `OIDC_CLAIM_NAME`.

## Step 3: Override the Parameter

To override the parameter, simply replace the existing value with the desired value. Ensure that the value is enclosed in quotes. For example, to override `OIDC_ISSUER_URL`, you would replace the existing value `https://123456-okta.com/111111/hello` with the desired URL. Similarly, to override `OIDC_CLAIM_NAME`, replace `oidc-custom-claim` with the desired claim name.

```yaml
profiles:
  infra:
    name: profile_infra
    packs:
      - name: kubernetes-eks
        registry: Public Repo
        version: "1.20"
        override_type: params #[values, params, template]
        params:
          MACHINE_POOL_ROLE_NAME: MACHINE_POOL_ROLE_NAME_1
          OIDC_IDENTITY_PROVIDER_NAME: eks-oidc # parameter value in cluster profile pack values should be "%OIDC_IDENTITY_PROVIDER_NAME%"
          OIDC_CLAIM_NAME: "new-claim-name" # parameter value in cluster profile pack values should be "%OIDC_CLAIM_NAME%"
          OIDC_ISSUER_URL: "https://new-issuer-url.com" # parameter value in cluster profile pack values should be "%OIDC_ISSUER_URL%"
          
```

In this example, `OIDC_ISSUER_URL` has been changed to `https://new-issuer-url.com` and `OIDC_CLAIM_NAME` has been changed to `new-claim-name`.

Remember that each pack in a profile can have its own parameters overridden. The `params` field is a map, where the key is the name of the parameter and the value is the overridden value. If a pack doesn't have a `params` field, it means there are no parameters to be overridden for that pack.
