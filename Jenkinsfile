currentBuild.displayName = "Web App_Demo # "+currentBuild.number

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
		          // sh "mvn clean install"
                  }
                }  
              }



              stage('build')
                {
              steps{
                  script{
		 sh 'cp -r ../devops-training@2/target .'
                   sh 'docker build . -t deekshithsn/devops-training:$Docker_tag'
		   withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
				    
				  sh 'docker login -u deekshithsn -p $docker_password'
				  sh 'docker push deekshithsn/devops-training:$Docker_tag'
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







// // currentBuild.displayName = "Final_Demo # "+currentBuild.number


// node {
//     def sample-web-appImage
//     docker.withRegistry("https://index.docker.io/v1/", "Docker_Hub" ) {
//       stage('Clone repo') {
//         checkout scm
//       }
      
// //       #Run sonar scan
//       stage('Quality Gate Status Check'){
//               agent{
      
//                 docker{
//                 image 'maven'
//                 args '-v $HOME/.m2:/root.m2'
//                 }
//                }  
//                 steps{
//                     script{
//                 withSonarQubeEnv('sonarserver') {
//                 sh "mvn sonar:sonar"
                
//                 timeout(time: 1, unit: 'HOURS'){
//                 def qg = waitForQualityGate()
//                     if (qg.status != 'OK'){
//                      error "Pipeline abort due to quality gate failure: ${qg:status}"
//                     }
//                         }
//                  sh "mvn clean install"
//                  }
//                 }
//                }
//             }

// // #build docker image
//       stage('Build sample web app Image') {
//         sample-web-appImage = docker.build("devtraining/sample-web-app:v1.0.0")
//       }



// // #Push docker image
//       stage('Push backend image') {
//           sample-web-appImage.push("${env.BUILD_NUMBER}")
//           sample-web-appImage.push()
//       }
// #trigger deployment
//       stage('Trigger k8s-sample-web-app-deployment') {
//                 echo "triggering k8s-sample-web-app-deployment job"
//                 build job: 'k8s-sample-web-app-deployment', parameters: [string(name: 'DOCKERTAG', value: env.BUILD_NUMBER)]
//         }
//     }
// }




