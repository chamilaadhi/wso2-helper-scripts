#!/bin/bash

########################### configuration ############################
#admin credentials. Add tenant admin credentials to create tenant users. 
adminUser=admin
#admin user for tenant
#adminUser=admin@wso2.com
adminPassword=admin

#Custom roles
role_array=( 
    'role1' 
    'role2' 
    'roleX'
    'roleY'
)

#Users and roles list. These users will be created with the given role
#User and roles are seperated with ::, roles are seperated with ','
#Note: if single role, add a ',' at the end
user_array=(
    'creator::Internal/creator,'
    'publisher::Internal/publisher,'
    'subscriber::Internal/subscriber,'
    'user1::Internal/subscriber,roleX'
    'user2::Internal/subscriber,roleY'
    'creator1::Internal/creator,role1'
    'creator2::Internal/creator,role2'
    'publisher1::Internal/publisher,'
    'publisher2::Internal/publisher,'
)

#######################################################################

########################## functions ##################################
#add users
function createAllUsers() {
    echo "Create users and assign roles"
    for index in "${user_array[@]}" ; do
        KEY="${index%%::*}"
        VALUE="${index##*::}"
        echo "user:$KEY  role:$VALUE" $(addUserWithRole "$KEY" "$VALUE")
    done
}

#add custom roles
function addAllCustomRoles() {
    echo "\n Create custom roles"
    for i in "${role_array[@]}"
    do
        echo Role $i  :$(addRole "$i")
    done
}

function addUserWithRole () {
    role1="${2%%\,*}"
    role2="${2##*\,}"
    curl -k -X POST \
            https://localhost:9443/services/UserAdmin \
            -u $adminUser:$adminPassword \
            -H 'Content-Type: text/xml' \
            -H 'SOAPAction: "urn:addUser"' \
            -d '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://org.apache.axis2/xsd" xmlns:xsd1="http://common.mgt.user.carbon.wso2.org/xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <xsd:addUser>
                    <xsd:userName>'$1'</xsd:userName>
                    <xsd:password>admin</xsd:password>
                    <xsd:roles>'$role1'</xsd:roles>
                    <xsd:roles>'$role2'</xsd:roles>
                </xsd:addUser>
            </soapenv:Body>
            </soapenv:Envelope>' --write-out "%{http_code}\n" --silent --output /dev/null 
}

function addRole () {
    curl -k -X POST \
            https://localhost:9443/services/UserAdmin \
            -u $adminUser:$adminPassword \
            -H 'Content-Type: text/xml' \
            -H 'SOAPAction: "urn:addRole"' \
            -d '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://org.apache.axis2/xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <xsd:addRole>
                        <xsd:roleName>'$1'</xsd:roleName>
                        <xsd:isSharedRole>false</xsd:isSharedRole>
                    </xsd:addRole>
                </soapenv:Body>
                </soapenv:Envelope>' --write-out "%{http_code}\n" --silent --output /dev/null 
}

function deleteRole () {
}
########################## execution flow ################################
#add custom roles
addAllCustomRoles
#create defined users
createAllUsers


echo "\n Done."
