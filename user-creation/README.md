# Script to create users with roles

Password for every user is 'admin'

Following users with roles are created

| User       |      Roles                    | 
|------------|-------------------------------|
| creator    |  Internal/creator             |
| publisher  |  Internal/publisher           |
| subscriber |  Internal/subscriber          | 
| user1      |  Internal/subscriber, roleX   | 
| user2      |  Internal/subscriber, roleY   | 
| creator1   |  Internal/creator, role1      |
| creator2   |  Internal/creator, role2      |
| publisher1 |  Internal/publisher           |
| publisher2 |  Internal/publisher           |


## To setup same users in tenant domain, Change following in the script to tenant credentials
    adminUser=admin
    adminPassword=admin
