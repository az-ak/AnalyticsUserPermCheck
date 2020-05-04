# Einstein Analytics Internal User Permission Checker

## Background
If you enabled Einstein Analytics in your Salesforce Org, 2 internal users are activated:
* Integration User
* Security User

When digesting Salesforce object data, Einstein Analytics accesses to the Org by Integration User.  So if the user does not have field level access, that field cannot be selected, or sometimes Dataflow fails.

It's easy to grant access to Analytics Cloud Integration User Profile when error occurs. However product doesn't have a feature to list fields which Integration User doesn't have access to.

With this Apex class, you can get the list of fields which Integration User does not have access.

## How to use
1. deploy the class file
2. run test method checkPermIntegrationUser()
3. open debug log and filter it with 'DEBUG'

![DebugLog](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/144149/e9750727-d513-0b9f-f84c-e39c68c3af73.png)
Note: Sometimes debug log size reaches to its maximum.  In that case, adjust trace flags.  Apex Code must be higher than DEBUG, other categories can be NONE.

## Technical Supplement
You can easily get the list of fields which Integration User DOES have access.
```
SELECT Field FROM FieldPermissions WHERE ParentId in (SELECT Id FROM PermissionSet WHERE PermissionSet.Profile.Name = 'Analytics Cloud Integration User')
```
But the field naming format is slightly different from `SObjectField.getDescribe().getName()`.  I couldn't accomplish my purpose by removing the result of above SOQL from all the fields.

In Apex code, usually isAccessible() is used for checking whether current user has a read access.  But, in this case, user we want to check is not current user.  Only in Apex test, we can use runAs() to execute Apex code on behalf of other user.  Results should be checked by debug log.

## License
This software is released under the MIT License, see LICENSE.txt.