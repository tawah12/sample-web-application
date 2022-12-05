
// currentBuild.displayName = "Web App_Demo # "+currentBuild.number

// pipeline{
//     agent{
//         docker{
//             image 'maven'
//             args '-v $HOME/.m2:/root.m2'
//          }
//     }  
//       stages{
//         stage('Quality Gate Status Check'){
//            steps{
//                 script{
//             withSonarQubeEnv('sonarserver') {
//             sh "mvn sonar:sonar"
//                  }

//             timeout(time: 1, unit: 'HOURS'){
//             def qg = waitForQualityGate()
//                 if (qg.status != 'OK'){
//                 error "Pipeline abort due to quality gate failure: ${qg:status}"
//                 }
//                }
//               }
//            }
//         }
//         stage('Maven build'){
//            steps{
//                 script{
//             sh "mvn clean install"
//                  }
//            }
//         }

//         stage('Build Web app image') {
//             steps{
//                   script{
// 		    docker.withRegistry("https://index.docker.io/v1/", "Docker_Hub" ) {
//               sh 'docker build -t devtraining/sample-web-app .'				    
// 			          }
// 		          }
//            }
//        }
        
//         stage('Push Web app image') {
//             steps{
//                   script{
// 		    docker.withRegistry("https://index.docker.io/v1/", "Docker_Hub" ) {
//               sh 'docker push devtraining/sample-web-app:latest'			    
			          
// 		}
//            }
//         }

//       }
//       stage('Trigger ManifestUpdate') {
// 	    steps{
// 		script{
// 		  echo "triggering k8s-sample-web-app-deployment job"
//              build job: 'k8s-sample-web-app-deployment', parameters: [string(name: 'DOCKERTAG', value: env.BUILD_NUMBER)]
// 	      }
//           }
//        }
//    }
// }








currentBuild.displayName = "Final_Demo # "+currentBuild.number

   def getDockerTag(){
        def tag = sh script: 'git rev-parse HEAD', returnStdout: true
        return tag
        }
        

pipeline{
        agent any  
        environment{
	    Docker_tag = getDockerTag()
        }
        
        stages{


              stage('Quality Gate Statuc Check'){

               agent {
                docker {
                image 'maven'
                args '-v $HOME/.m2:/root/.m2'
                }
            }
                  steps{
                      script{
                      withSonarQubeEnv('sonarserver') { 
                      sh "mvn sonar:sonar"
                       }
                      timeout(time: 1, unit: 'HOURS') {
                      def qg = waitForQualityGate()
                      if (qg.status != 'OK') {
                           error "Pipeline aborted due to quality gate failure: ${qg.status}"
                      }
                    }
		    sh "mvn clean install"
                  }
                }  
              }



              stage('build')
                {
              steps{
                  script{
		 //sh 'cp -r ../devops-training@2/target .'
                   //sh 'docker build . -t devtraining/sample-web-app:$Docker_tag'
		   docker.withRegistry("https://index.docker.io/v1/", "Docker_Hub" ) {
		   sh 'docker build . -t devtraining/sample-web-app:$Docker_tag'
				    
				  //sh 'docker login -u deekshithsn -p $docker_password'
				  //sh 'docker push devtraining/sample-web-app:$Docker_tag'
			}
                       }
                    }
                 }
		 
		
              stage('push')
                {
              steps{
                  script{
		   docker.withRegistry("https://index.docker.io/v1/", "Docker_Hub" ) {
                   sh 'docker push . -t devtraining/sample-web-app:$Docker_tag'
				  //sh 'docker login -u deekshithsn -p $docker_password'
				  //sh 'docker push devtraining/sample-web-app:$Docker_tag'
			}
                       }
                    }
                 }
		 
		stage('ansible playbook'){
			steps{
			 	script{
				    sh '''final_tag=$(echo $Docker_tag | tr -d ' ')
				     echo ${final_tag}test
				     sed -i "s/docker_tag/$final_tag/g"  deployment.yaml
				     '''
				    ansiblePlaybook become: true, installation: 'ansible', inventory: 'hosts', playbook: 'ansible.yaml'
				}
			}
		}
		
	
		
               }
	       
	       
	       
	      
    
}














