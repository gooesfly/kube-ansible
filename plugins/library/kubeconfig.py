#!/usr/bin/python3

# Copyright: (c) 2018, Xiao Mo <95112082@qq.com>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

ANSIBLE_METADATA = {
    'metadata_version': '1.1',
    'status': ['preview'],
    'supported_by': 'community'
}

DOCUMENTATION = '''
---
module: kubeconfig

short_description: This is kubernetes kubeconfig module

version_added: "2.4"

description:
    - "create or update kubernetes kubeconfig file"

options:
    path:
        description:
            - path to kubeconfig file
        required: true
    type:
        description:
            - kubeconfig type
        required: true
    embed: 
        description:
            - embed certs
        required: false
    server:
        description:
            - APIServer URL
        required: false 
    ca:
        description:
            - kubernetes ca certificate
        required: false
author:
    - XiaoMo (95112082@qq.com)
'''

EXAMPLES = '''
# Create a cluster on kubeconfig
- name: Create a cluster on kubeconfig
  kubeconfig:
    path: /etc/kubernetes/admin.kubeconfig
    type: cluster
    name: kubernetes
    server: https://127.0.0.1:6443
    ca: /etc/kubernetes/pki/ca.crt

# Create a user on kubeconfig
- name: Create a user on kubeconfig
  kubeconfig:
    path: /etc/kubernetes/admin.kubeconfig
    type: user
    name: admin
    certificate: /etc/kubernetes/pki/admin.crt
    certificate_key: /etc/kubernetes/pki/admin.key

# Create a context on kubeconfig
- name: Create a context on kubeconfig
  kubeconfig:
    path: /etc/kubernetes/admin.kubeconfig
    type: context
    name: admin@kubernetes
    user: admin
    cluster: kubernetess
    default: true
'''

RETURN = '''
# type=cluster
path:
    description: kubeconfig file path
    type: str
    returned: always
name: 
    description: name of user or cluster
    type: str
    returned: always
'''

import os
import yaml
from ansible.module_utils.basic import AnsibleModule

def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        path=dict(type='str', required=True),
        type=dict(type='str', required=True),
        name=dict(type='str', required=False),
        server=dict(type='str', required=False),
        embed=dict(type='str', required=False, default=False),
        ca=dict(type='str', required=False),
        certificate=dict(type='str', required=False),
        certificate_key=dict(type='str', required=False),
        user=dict(type='str', required=False),
        cluster=dict(type='str', required=False),
        default=dict(type='bool', required=False, default=False)
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # change is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        path='',
        name=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    if os.path.exists(module.params['path']):
        with open(module.params['path']) as f:
            kubeconfig = yaml.load(f, Loader=yaml.FullLoader)
    else:
        kubeconfig = dict(
            apiVersion='v1',
            kind='Config',
            clusters=[],
            contexts=[],
            users=[],
            preferences={}
        )
        result['changed'] = False

    if module.params['type'] == "cluster":
        cluster = {
            "name": module.params['name'],
            "cluster": {
                "server": module.params['server'],
                "certificate-authority": module.params['ca']
            }
        }
        index = kubeconfig['clusters'].count(cluster)
        if index != 0:
            if kubeconfig['clusters'][index - 1]['cluster']['server'] == module.params['server'] and kubeconfig['clusters'][index - 1]['cluster']['certificate-authority'] == module.params['ca']:
                kubeconfig['clusters'].pop(index -1)
                result['changed'] = False
            else:
                result['changed'] = True
        
        kubeconfig['clusters'].append(cluster)

    elif module.params['type'] == "user":
        user = {
            "name": module.params['name'],
            "user": {
                "client-certificate": module.params['certificate'],
                "client-key": module.params['certificate_key']
            }
        }
        index = kubeconfig['users'].count(user)
        if index != 0:
            if kubeconfig['users'][index - 1]['user']['client-certificate'] == module.params['certificate'] and kubeconfig['users'][index - 1]['user']['client-key'] == module.params['certificate_key']:
                kubeconfig['users'].pop(kubeconfig['users'].count(user) -1 )
                result['changed'] = False
            else:
                result['changed'] = True
        kubeconfig['users'].append(user)

    elif module.params['type'] == "context":
        context = {
            "name": module.params['name'],
            "context": {
                "cluster": module.params['cluster'],
                "user": module.params['user']
            }
        }
        index = kubeconfig['contexts'].count(context)
        if index != 0:
            if kubeconfig['contexts'][index - 1]['context']['cluster'] == module.params['cluster'] and kubeconfig['contexts'][index - 1]['context']['user'] == module.params['user']:
                kubeconfig['contexts'].pop(kubeconfig['contexts'].count(context) -1 )
                result['changed'] = False
            else:
                result['changed'] = True
        kubeconfig['contexts'].append(context)

        if module.params['default']:
            kubeconfig['current-context'] = module.params['name']

    else:
        pass

    with open(module.params['path'], 'w') as f:
        documents = yaml.dump(kubeconfig, f)

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    result['path'] = module.params['path']
    result['name'] = module.params['name']

    # during the execution of the module, if there is an exception or a
    # conditional state that effectively causes a failure, run
    # AnsibleModule.fail_json() to pass in the message and the result
    if module.params['name'] == 'fail me':
        module.fail_json(msg='You requested this to fail', **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)

def main():
    run_module()

if __name__ == '__main__':
    main()