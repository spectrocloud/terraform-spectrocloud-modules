# Spectrocloud Terraform Modules YAML validation. ####

Spectro Cloud Terraform Modules provides validation for input YAML files used 
to provision clusters. Validation schema is based on specification ```json-schema.org/draft/2019-09/schema```
Each cloud provider has its own schema to validate cluster.yaml file and mapping is documented below.

### The list of Spectro Cloud module supported cloud types and validation schemas are:
* VMware - vmware-schema.json
* Edge - edge-schema.json


# Prepare environment for validation. ####
Recommended environment to run yaml validation against schema as an example requires to install 
```ajv-cli```, ```yaml-validator``` and ```npx``` using npm package manager(```https://www.npmjs.com/package/npm```). 
* ```npm install -g npx```
* ```npm install -g ajv-cli```

 
# Steps to validate a yaml file. ###
<pre>
1. Check that the YAML file has valid syntax:<br>
   > npx yaml-validator medium-cluster.yaml

2. Check that the yaml file is valid against schema:<br>
   > npx ajv-cli validate -s schema.json -d medium-cluster.yaml 
</pre>

#### Expected ouput from step 1: output should be absent.

#### Errorneous output from step 1:
<pre>
bad indentation of a mapping entry (2:11)

 1 | name: ${APPLIANCE_ID}
 2 |  cloudType: libvirt
</pre>

#### Expected ouput from step 2:
<pre>
ehs-medium-cluster.yaml valid
</pre>

#### Errorneous output from step 2:
<pre>
ehs-medium-cluster.yaml invalid
[
  {
    instancePath: '/profiles/addons/0',
    schemaPath: '#/required',
    keyword: 'required',
    params: { missingProperty: 'version' },
    message: "must have required property 'version'",
    schema: [ 'name', 'version' ],
    parentSchema: {
      type: 'object',
      additionalProperties: false,
      properties: [Object],
      required: [Array],
      title: 'Addon'
    },
    data: { name: 'ehs-bootstrap' }
  }
]
</pre>

#### More information for validation options
<pre>
https://www.npmjs.com/package/yaml-validator/v/1.2.0
https://ajv.js.org/packages/ajv-cli.html#test-validation-result
</pre>




