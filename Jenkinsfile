#!groovy
import groovy.json.JsonSlurperClassic
node {

    def BUILD_NUMBER=env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    //def HUB_ORG=env.HUB_ORG_DH
    def HUB_ORG='nareshcmdev2@vamritech.com'
    def SFDC_HOST = env.SFDC_HOST_DH
    def JWT_KEY_CRED_ID = env.JWT_CRED_ID_DH
    //def CONNECTED_APP_CONSUMER_KEY=env.CONNECTED_APP_CONSUMER_KEY_DH
    def CONNECTED_APP_CONSUMER_KEY='3MVG9VTfpJmxg1yjrCJEKP.bhvULwGLTAQWu0jqW3fS5ve9WkwuwyqArPaqSGK3T2AKyiBdyI1Nd7utBz58Nv'
 	
    def TEST_LEVEL='RunLocalTests'
	
    println 'KEY IS' 
    println JWT_KEY_CRED_ID
    println HUB_ORG
    println SFDC_HOST
    println CONNECTED_APP_CONSUMER_KEY
    def toolbelt = tool 'toolbelt'

    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Deploye Code') {
            if (isUnix()) {
                rc = sh returnStatus: true, script: "${toolbelt}/sfdx force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
	    }else{
                 rc = bat returnStatus: true, script: "\"${toolbelt}/sfdx\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile \"${jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
            }
            if (rc != 0) { error 'hub org authorization failed' }
			println rc
			// need to pull out assigned username
			if (isUnix()) {
			rmsg = sh returnStdout: true, script: "${toolbelt}/sfdx force:source:deploy --manifest manifest/package.xml -u ${HUB_ORG}"
			}else{
			rmsg = bat returnStdout: true, script: "\"${toolbelt}/sfdx\" force:source:deploy --manifest manifest/package.xml -u ${HUB_ORG}"
			}
			  
            printf rmsg
            println('Hello from a Job DSL script!')
            println(rmsg)
        }
    stage('Run Tests In Test Scratch Org') {
	//rc = command "${toolbelt}/sfdx apex run test --target-org ciorg --wait 10 --result-format tap --code-coverage --test-level ${TEST_LEVEL}"
	rc = command "\"${toolbelt}/sfdx\" apex run test --target-org ciorg --wait 10 --result-format tap --code-coverage --test-level ${TEST_LEVEL}"
	if (rc != 0) {
	    error 'Salesforce unit test run in test scratch org failed.'
	}
    }
    }
}
def command(script) {
    if (isUnix()) {
        return sh(returnStatus: true, script: script);
    } else {
        return bat(returnStatus: true, script: script);
    }
}
