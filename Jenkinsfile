def SLACK_SEND_COLOR = '#ff0000'
pipeline {
  agent {
    node {
      label 'mac'
    }
  }

  triggers {
    pollSCM '* * * * *'
  }

  environment {
    SONAR_AUTH_TOKEN = credentials('SONAR_AUTH_TOKEN')
  }

  options {
    disableConcurrentBuilds()
    timeout(60)
  }

  stages {
    stage('Git Checkout') {
      steps {
        echo "Git Checkout"
        checkout scmGit(branches: [
          [name: '**']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-cred',
            refspec: '+refs/tags/*:refs/remotes/origin/tags/dev-v*', url: 'https://github.com/maverick-poc/maverick-poc-ios-app.git']])
      }
    }

    stage('Unit Test') {
      steps {
        echo 'Testing..'
      }
    }
    stage('SonarQube Test') {
      steps {
        echo 'Sonar....'
        echo 'Sonar....'
        sh ""
        "
        cat > sonar.sh << EOF\ nexport PATH = $PATH: /Users/ec2 - user / Downloads / sonar - scanner - 4.8 .0 .2856 - macosx / bin\ nsonar - scanner - Dproject.settings = sonarqube.properties - Dsonar.login = "${env.SONAR_AUTH_TOKEN}" - Dsonar.url = http: //pipeline.mavipoc.com:9090\nEOF
          ""
        "
        sh 'cat sonar.sh'
        sh 'chmod +x sonar.sh'
        sh './sonar.sh'
      }
    }

    stage('Pod Install') {
      steps {
        sh 'chmod +x ./pod_install.sh'
        sh './pod_install.sh'
      }
    }

    stage('Build Archive') {
      steps {
        echo 'wait'
        sh ""
        "
        xcodebuild - scheme BNIMobile - workspace BNIMobile.xcworkspace - archivePath. / BNIMobile.xcarchive - configuration Release CODE_SIGN_IDENTITY = 'Apple Distribution: Muhammad Naratama Memontifada Krismawan'
        PROVISIONING_PROFILE_SPECIFIER = BNI_POC_AD_HOC archive ""
        "
      }
    }

    stage('Export IPA') {
      steps {
        sh ""
        "
        cat > exportOptions.plist << EOF\ n < ? xml version = "1.0"
        encoding = "UTF-8" ? > \n < !DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd" > \n < plist version = "1.0" > \n < dict > \n < key > method < /key>\n<string>same-as-archive</string > \n < key > teamID < /key>\n<string>MY65R8DR6S</string > \n < key > uploadSymbols < /key>\n<true/ > \n < key > uploadBitcode < /key>\n<false/ > \n < key > signingCertificate < /key>\n<string>Apple Distribution: Muhammad Naratama Memontifada Krismawan</string > \n < key > provisioningProfiles < /key>\n<dict>\n<key>com.ibm.BNIMobile</key > \n < string > BNI_POC_AD_HOC < /string>\n</dict > \n < /dict>\n</plist > \nEOF ""
        "
        sh 'cat exportOptions.plist'
        sh "xcodebuild -exportArchive -archivePath BNIMobile.xcarchive -exportPath ./BNI-ipa -exportOptionsPlist exportOptions.plist"
        sh "pwd && ls -al"
        sh "cd BNI-ipa && ls -al"
        sh "cd .."
      }
    }

    stage('Dependency Check') {
      steps {
        echo 'Dependency Check....'
        dependencyCheck additionalArguments: '', odcInstallation: 'Dependency-Check'
        dependencyCheckPublisher pattern: 'dependency-check-report.xml'
      }
    }

    stage('Upload to AppCenter') {
      environment {
        APP_CENTER_TOKEN_IOS = credentials('APP_CENTER_TOKEN_IOS')
      }
      steps {
        echo 'Deploying....'
        appCenter apiToken: "${env.APP_CENTER_TOKEN_IOS}", appName: 'Maverick-iOS', branchName: '', buildVersion: '', commitHash: '', distributionGroups: 'Maverick-iOS-Group', mandatoryUpdate: false, notifyTesters: true, ownerName: 'maverick-poc', pathToApp: 'BNI-ipa/BNIMobile.ipa', pathToDebugSymbols: '', pathToReleaseNotes: '', releaseNotes: 'Enjoy New Version of this App.'
        script {
          SLACK_SEND_COLOR = '#66cdaa'
        }
      }
    }
  }
  post {
    always {
      echo 'I will always say Hello again!'
      slackSend color: "${SLACK_SEND_COLOR}", message: "Jenkins Job ${env.JOB_NAME} With Build Number ${env.BUILD_NUMBER} Completed with ${currentBuild.currentResult}. To view logs click (<${env.BUILD_URL}|Open>)"
    }
  }
}
