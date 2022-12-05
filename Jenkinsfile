
currentBuild.displayName = "Web App_Demo # "+currentBuild.number

pipeline{
    agent{
        docker{
            image 'maven'
            args '-v $HOME/.m2:/root.m2'
         }
    }  
      stages{
        stage('Quality Gate Status Check'){
           steps{
                script{
            withSonarQubeEnv('sonarserver') {
            sh "mvn sonar:sonar"
                 }

            timeout(time: 1, unit: 'HOURS'){
            def qg = waitForQualityGate()
                if (qg.status != 'OK'){
                error "Pipeline abort due to quality gate failure: ${qg:status}"
                }
                        }
                 }
           }
        }
        stage('Maven build'){
           steps{
                script{
            sh "mvn clean install"
                 }
           }
        }

        stage('Build Web app image') {
            steps{
                  script{
		    docker.withRegistry("https://index.docker.io/v1/", "Docker_Hub" ) {
              sh 'docker build -t devtraining/sample-web-app .'				    
			          }
		          }
           }
       }
        
        stage('Push Web app image') {
            steps{
                  script{
		    docker.withRegistry("https://index.docker.io/v1/", "Docker_Hub" ) {
              sh 'docker push devtraining/sample-web-app:latest'			    
			          
		}
           }
        }

      }
      stage('Trigger ManifestUpdate') {
	    steps{
		script{
		  echo "triggering k8s-sample-web-app-deployment job"
             build job: 'k8s-sample-web-app-deployment', parameters: [string(name: 'DOCKERTAG', value: env.BUILD_NUMBER)]
	      }
          }
       }
   }
}



