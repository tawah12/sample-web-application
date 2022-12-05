// currentBuild.displayName = "Web App_Demo # "+currentBuild.number

//    def getDockerTag(){
//         def tag = sh script: 'git rev-parse HEAD', returnStdout: true
//         return tag
//         }
        

// pipeline{
//         agent any  
//         environment{
// 	    Docker_tag = getDockerTag()
//         }
        
//         stages{


//               stage('Quality Gate Statuc Check'){

//                agent {
//                 docker {
//                 image 'maven'
//                 args '-v $HOME/.m2:/root/.m2'
//                 }
//             }
//                   steps{
//                       script{
//                       withSonarQubeEnv('sonarserver') { 
//                       sh "mvn sonar:sonar"
//                        }
//                       timeout(time: 1, unit: 'HOURS') {
//                       def qg = waitForQualityGate()
//                       if (qg.status != 'OK') {
//                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
//                       }
//                     }
// 		          // sh "mvn clean install"
//                   }
//                 }  
//               }



//               stage('Build sample web app Image')
//                 {
//               steps{
//                   script{
//                    sh 'docker build . -t devtraining/sample-web-app:$Docker_tag'
//                        }
//                     }
//                  }
		
//               stage('Push backend image')
//                 {
//               steps{
//                   script{
//                    sh 'docker build . -t devtraining/sample-web-app:$Docker_tag'
// 		   withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
				    
// 				  sh 'docker login -u deekshithsn -p $docker_password'
// 				  sh 'docker push deekshithsn/devops-training:$Docker_tag'
// 			}
//                        }
//                     }
//                  }
		
		 

// }




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

                //sh "mvn clean install"
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


      }
   
}


