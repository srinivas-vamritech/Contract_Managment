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

		def testClass = "YourTestClass" // Replace with your actual test class name
		    def result = sh returnStatus: true, script: """
		    ${toolbelt}/sfdx force:apex:test:run -u ${HUB_ORG} -t ${testClass} -r json
		    """
		    if (result == 0) {
		        // Test execution successful
		    } else {
		        // Handle test execution failure
		    }
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
	stage('Run Tests and Get Coverage') {
    	def coverageResult
	if (isUnix()) {
	    // Run tests
	    sh """
	    ${toolbelt}/sfdx force:apex:test:run -u ${HUB_ORG} -c -w 10 -r json > test-result.json
	    """
	    coverageResult = sh returnStdout: true, script: """
${toolbelt}/sfdx force:apex:test:report -i \$(jq -r '.result.testRunId' test-result.json) -u "${HUB_ORG}" -w 10 -r json
"""

	} else {
	    // Run tests in Windows
	    bat """
	    "${toolbelt}/sfdx" force:apex:test:run -u ${HUB_ORG} -c -w 10 -r json > test-result.json
	    """
	    coverageResult = bat returnStdout: true, script: """
"${toolbelt}/sfdx" force:apex:test:report -i %testRunId% -u "${HUB_ORG}" -w 10 -r json
"""

	}
	    
	}
    }
}
