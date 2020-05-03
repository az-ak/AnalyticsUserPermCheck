@isTest
public with sharing class AnalyticsUserPermCheck {

    @isTest
    public static void checkPermIntegrationUser() {
        User integrationUser = [SELECT Id from User WHERE ProfileId in (SELECT Id FROM Profile
            WHERE NAME = 'Analytics Cloud Integration User')  LIMIT 1];
        listFields(integrationUser);
    }

    @isTest
    public static void checkPermSecurityUser() {
        User securityUser = [SELECT Id from User WHERE ProfileId in (SELECT Id FROM Profile
            WHERE NAME = 'Analytics Cloud Security User')  LIMIT 1];
        listFields(securityUser);
    }

    static void listFields(User runAsUser) {

        System.runAs(runAsUser) {
            System.debug('*** ' + UserInfo.getName() + ' do not have access to: ***');

            for (SObjectType sot : Schema.getGlobalDescribe().values()){
                if (sot.getDescribe().getKeyPrefix() != null) {
                    String objName = sot.getDescribe().getName();
                    Map<String, SObjectField> fieldMap = sot.getDescribe().fields.getmap();
                    String fieldName;
                    Boolean isAccesible;
                    for (SObjectField sof : fieldMap.values() ) {
                        try {
                            fieldName = sof.getDescribe().getName();
                        } catch (Exception e) {
                            fieldName = 'UNKNOWN';
                        }
                        try {
                            isAccesible = sof.getDescribe().isAccessible();
                            if (!sof.getDescribe().isAccessible()) {
                                System.debug(objName + '.' + fieldName);
                            }
                        } catch (Exception e) {
                            System.debug('Skipped ' + objName + '.' + fieldName + ' Reason: ' + e.getMessage());
                        }
                    }
                }
            }

            System.debug('*** Access Check Completed ***');
        }
    }

}
